# Skill: trace

**Purpose:** Walk every artefact in the RE pipeline and produce a single traceability matrix at `artifacts/06-traceability/traceability-matrix.md`. The matrix links Stakeholders → BUCs → Functional / Non-Functional Requirements → Epics → User Stories → Acceptance Criteria → Test Cases. The skill detects orphans at every level, computes coverage statistics, finds cross-artefact drift (e.g. an AC text that differs between elicit doc, SRS, and Story), and produces an impact-analysis report showing which downstream elements depend on every Pending or Rejected upstream element. This is the framework's auditor — it runs anytime against whatever pipeline state exists, never modifies upstream artefacts, and never invents content.

**Invocation:**
- Claude Code: `/trace`
- GitHub Copilot: "Run the trace skill" or "Follow `skills/trace/skill.md`"

**Inputs (all optional — the skill runs whatever state exists):**
- `artifacts/01-elicitation/elicitation-document.md`
- `artifacts/02-epics/epic-*.md` and `index.md`
- `artifacts/03-user-stories/story-*.md` and `index.md`
- `artifacts/04-srs/srs.md`
- `artifacts/05-test-concept/test-concept.md`, `test-case-*.md`, and `index.md`

**Output:**
- `artifacts/06-traceability/traceability-matrix.md` — single self-contained matrix file (rebuilt every run)

---

## Step 0 — No gate; gracefully detect the pipeline state

`/trace` is diagnostic, not generative. It runs whenever the user invokes it and reports whatever state it finds — even if only the elicit doc exists, even if some artefacts are still Pending. The skill never refuses to run.

Detect which pipeline phases have artefacts:

| Phase | Detection rule | If absent |
|-------|----------------|-----------|
| 1 — Elicitation | `artifacts/01-elicitation/elicitation-document.md` exists | Stop with a clean message: "No Elicitation Document — start with `/elicit`. Nothing to trace yet." |
| 2 — Epics | `artifacts/02-epics/` contains at least one `epic-*.md` | Note "Epics not yet generated" in coverage stats; everything Epic-and-below treated as not-yet-applicable |
| 3 — Stories | `artifacts/03-user-stories/` contains at least one `story-*.md` | Note "Stories not yet generated"; matrix rows show `—` for the Story column |
| 4 — SRS | `artifacts/04-srs/srs.md` exists | Note "SRS not yet compiled"; matrix shows `—` for Section-8 / SRS-AC columns |
| 5 — Tests | `artifacts/05-test-concept/` contains at least one `test-case-*.md` | Note "Test Cases not yet generated"; matrix shows `—` for the TC column |

The elicitation document is the only mandatory input — without it, there is nothing to trace.

---

## Step 1 — Read every available artefact

Extract elements from each phase that exists. The skill never modifies any upstream artefact; it reads.

| Source | What to extract |
|--------|-----------------|
| Elicitation Document | SH-### (Role, Primary Concerns, BUC ownership), BUC-### (Primary Actor, Stakeholders, Trigger, Expected Outcome, Status), FR-### (Title, Description, Priority, BUC link, Stakeholder, Status), NFR-### (Title, Description, Category, BUC scope, Cross-cutting flag, Status), CON-### (Type, Status), AC-FR-###-NN and AC-NFR-###-NN (Given/When/Then or Criterion, parent FR/NFR, Status), ASMP-### / RSK-### / OQ-### (cross-pipeline open-question namespace) |
| Epic files | EP-### (Primary BUC(s), In-Scope FRs / NFRs / CONs, Cross-cutting NFRs, Owner, Status), Source field (merged-from / split-from), Story coverage references |
| Story files | US-### (Parent FR, Parent Epic, Owner, Story Points, Status, Acceptance Criteria references) |
| SRS | Section 4 FRs, Section 5 NFRs (with cross-cutting flag), Section 6 CONs, Section 8 ACs, Section 9 SRS-internal traceability matrix; SRS frontmatter `status` and `version` |
| Test Concept + Test Case files | TC-### (parent AC, parent FR/NFR, parent Epic, parent Story, Owner, Type, Level, Status) |
| inputs/manifest.md | input-document filenames (informational; used for the Project Overview section) |

The skill uses the IDs and structural fields, not the full prose content. Cross-artefact drift detection in Step 6 reads the AC text and FR title prose to compare across artefacts.

---

## Step 2 — Build the Forward Trace Matrix

The forward chain is `SH → BUC → FR/NFR → EP → US → AC → TC`. One row per **leaf path** — every distinct combination from a Stakeholder all the way down to a Test Case (or to the deepest reachable element if the chain breaks earlier).

Walk the chain top-down, joining on the explicit links each artefact records:

- SH owns BUC via `Primary Actor` and `Stakeholders` fields in elicit Section 3
- BUC links to FR/NFR via the FR/NFR's `Business Use Case` field (one-to-one for FRs; one-to-many for NFRs)
- FR/NFR is In-Scope of Epic via `In-Scope` tables in `epic-NNN.md` Section 4
- FR generates Story via Story's `parent-fr` frontmatter field
- AC ties to FR/NFR via the AC's ID prefix (`AC-FR-###-NN` → FR-###, `AC-NFR-###-NN` → NFR-###)
- AC generates TC via TC's `parent-ac` frontmatter field

Render as a Markdown table with columns: **SH | BUC | FR / NFR | EP | US | AC | TC**. Every cell that has no link in the current state shows `—`. Sort rows by SH, then BUC, then FR/NFR, then AC.

NFR rows often have `—` in the US column (NFRs frequently don't trace through Stories) — that is correct, not a defect.

---

## Step 3 — Build the Backward Trace Matrix

Same matrix, sorted bottom-up: TC → AC → FR/NFR → EP → US (where applicable) → BUC → SH. Useful for impact analysis and for verifying that every Test Case earns its keep — every TC must trace back to at least one AC, an FR/NFR, a BUC, and a Stakeholder.

Render as a separate table after the forward matrix.

---

## Step 4 — Coverage Statistics

Compute counts and percentages for each level of the chain.

| Level | Stat to compute |
|-------|-----------------|
| Stakeholders | total / owning at least one BUC |
| BUCs | total Accepted / having at least one Accepted FR or NFR |
| FRs | total Accepted / having an In-Scope Epic / having a Story / having an AC / having a TC |
| NFRs | total Accepted / having In-Scope Epic(s) / having an AC / having a TC; cross-cutting count separately |
| CONs | total Accepted / referenced in at least one Epic |
| Epics | total Accepted / having Stories / having Stories all Accepted |
| Stories | total Accepted / having an AC / having a TC |
| ACs | total / having a TC |
| TCs | total / Pending / Accepted / Rejected |

Render as a single table `Element | In Scope | Covered | Coverage %`.

---

## Step 5 — Orphan Reports

Group orphans by element type. An "orphan" is an element that lacks the next forward link. Severity reflects how late in the pipeline the gap appears.

| Orphan kind | Severity |
|-------------|----------|
| Stakeholder owning no BUC | Medium |
| Accepted BUC with no Accepted FR or NFR | High (suggests scope mismatch) |
| Accepted FR not In-Scope of any Epic | Critical (Epic phase governance violation) |
| Accepted FR with no Story | High (Story phase incomplete) |
| Accepted NFR not In-Scope of any Epic | Critical |
| Story whose parent FR is not Accepted | High |
| AC with no Test Case (and Test phase has run) | High (Test phase coverage gap) |
| Test Case whose parent AC is not in the SRS canonical list | Critical |

Each orphan listed with its ID and a one-line reason. Total count summarised at the end of the section.

---

## Step 6 — Cross-Artefact Drift Detection

Compare the same logical content across artefacts where it is duplicated. Drift is silent corruption — one artefact says one thing, another says another, no one notices until a test fails for the wrong reason.

Pairs to check:

| Pair | What to compare |
|------|-----------------|
| FR Title in elicit doc vs SRS Section 4 | exact string equality |
| FR Description in elicit doc vs SRS Section 4 | exact string equality |
| NFR Measurable Target in elicit doc vs SRS Section 5 | exact string equality |
| AC text (Given/When/Then) in elicit doc Section 6 vs SRS Section 8 | exact string equality |
| AC text in SRS Section 8 vs the same AC reproduced in `story-NNN.md` Section 4 | exact string equality |
| AC text in SRS Section 8 vs the parent of `test-case-NNN.md` Section 6/8 | exact string equality |

Each drift listed as a row: `<element ID>` | `<artefact A> says: '<excerpt>'` | `<artefact B> says: '<excerpt>'`. Severity is `High`. The matrix does not invent a resolution — it reports the conflict so the human can reconcile upstream.

If no drift is detected: write "No cross-artefact drift detected. All upstream pairs agree on the lifted content."

---

## Step 7 — Impact Analysis

For every upstream element with `Status = Pending` or `Status = Rejected`, list every downstream element that currently references it. This is the change-impact report — answering "if this changes, what else needs review?"

Group by upstream element ID, listing dependent IDs:

> **FR-005 (Pending in elicit doc)** affects:
> - EP-002 (lists FR-005 In-Scope)
> - US-005 (parent-fr: FR-005)
> - AC-FR-005-01, AC-FR-005-02 (children of FR-005)
> - TC-005, TC-006 (parent-ac references)

If an upstream element is Pending or Rejected and has no dependants yet (e.g. a Pending FR not yet referenced by any Epic): write `(no downstream impact yet)`.

If every upstream element is Accepted and stable: write "No Pending or Rejected upstream elements with downstream impact."

---

## Step 8 — Write the matrix

1. Generate the document from `skills/trace/templates/traceability-matrix.md`. Update `last-updated` and `version` (incremented per run; a small registry of run dates kept in Section 9 — Revision History).
2. Write to `artifacts/06-traceability/traceability-matrix.md`. Always overwrite — `/trace` produces a single canonical artefact and re-running rebuilds it from current upstream state.
3. The trace artefact does NOT have an `Accepted` status — there is nothing to accept. Status field stays as `Auto-generated`. The matrix is a snapshot, not a settled artefact.

---

## Step 9 — Review summary

Present to the user:

> **Trace report — `<project name>`, run <YYYY-MM-DD>**
> - **Pipeline state:** [list which phases are present: e.g., "Elicit ✓, Epics ✓, Stories ✓, SRS ✓ (Accepted), Tests ✓"]
> - **Total leaf paths in forward matrix:** N
> - **Coverage** (one summary line per element type with `Covered / Total = %`)
> - **Orphans** (one line per kind, e.g., "Critical: 0; High: 2; Medium: 1")
> - **Drift findings:** N (or "none")
> - **Impact analysis:** [list of Pending/Rejected upstream elements with their dependant counts; or "no Pending/Rejected upstream elements"]

Then give your **Professional Assessment**:

**Critical findings (block downstream phases until resolved):**
- Critical-severity orphans
- Drift on Acceptance Criteria text (a downstream test case may verify the wrong behaviour)
- Test Cases referencing ACs not in the SRS canonical list

**Advisory findings (worth addressing in the next iteration):**
- High-severity orphans
- Drift on FR/NFR titles or descriptions
- Pending upstream elements with several Accepted dependants (changing the upstream now will cascade)

If everything is clean: state `"No issues — pipeline traceability is intact and consistent."`

> Read `artifacts/06-traceability/traceability-matrix.md` for the full report.
> The matrix is auto-generated and has no APPROVED gate — re-run `/trace` after upstream changes to refresh.

---

## ID Reference

`/trace` mints no IDs. It only reads existing IDs and reports them. The OQ-### namespace is shared across the pipeline; `/trace` does not log new OQs — it logs findings inline in the matrix's Orphan Reports and Drift Detection sections, leaving the OQ-### namespace for skills that generate content.

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| `artifacts/01-elicitation/elicitation-document.md` does not exist | Stop. "No Elicitation Document — start with `/elicit`. Nothing to trace yet." |
| Only elicit doc exists; nothing downstream | Run normally. Matrix shows `—` for Epic/Story/AC/TC columns; coverage stats show 0% for those levels; no orphan errors raised because the framework hasn't progressed there yet (the absence is expected, not a defect). |
| Some Epic files reference an FR ID that no longer exists in the elicit doc | List as a "ghost reference" in Orphan Reports under "Critical: Epic referencing non-existent FR". |
| Two TCs share the same `parent-ac` | List as Critical orphan: "AC-### has more than one TC". |
| An elicit-doc OQ remains Open | List in the Project Overview section as "Open Questions: N — see elicit doc Section 7". `/trace` does not block on this; it reports. |
| `artifacts/06-traceability/` does not exist | Create the directory. Write the matrix. |
| Existing `traceability-matrix.md` was edited manually | Overwrite. Note in the Revision History row: "Note YYYY-MM-DD: previous content overwritten on re-run; manual edits to this file are not preserved." `/trace` is read-only on upstream; on its own output it is fully regenerative. |
