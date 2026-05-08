# Skill: create-stories

**Purpose:** Decompose Accepted Epics into User Stories — one Markdown file per User Story (one Story per Accepted Functional Requirement) plus a generated `index.md` aggregator. Each Story carries the Connextra narrative ("As a / I want / so that"), Acceptance Criteria lifted verbatim from the Elicitation Document, an AI-provisional Fibonacci Story-point estimate, explicit-only dependencies, and Implementation Notes derived from the Story's NFR exposure. Re-runs are idempotent: Pending Stories are refined in place, Accepted Stories are immutable, and US-### IDs are never reused.

**Invocation:**
- Claude Code: `/create-stories`
- GitHub Copilot: "Run the create-stories skill" or "Follow `skills/create-stories/skill.md`"

**Inputs:**
- `artifacts/02-epics/epic-*.md` (only Epics with `Status: Accepted` are processed)
- `artifacts/01-elicitation/elicitation-document.md` (FR descriptions, BUC context, Stakeholders, Section 6 Acceptance Criteria, NFRs / CONs for Implementation Notes)
- `artifacts/03-user-stories/story-*.md` and `artifacts/03-user-stories/index.md` (existing Stories, if any)

**Outputs:**
- `artifacts/03-user-stories/story-NNN.md` (one file per Story; NNN = zero-padded US-### sequence)
- `artifacts/03-user-stories/index.md` (always rebuilt every run from current Story file state)

---

## Step 0 — Approval gate (incremental)

Read every file matching `artifacts/02-epics/epic-*.md`.

- If `artifacts/02-epics/` does not exist or is empty: stop and tell the user:
  > No Epics found in `artifacts/02-epics/`. Run `/create-epics` first.
- Filter to Epics whose frontmatter `status:` is `Accepted`. Call this set the **Accepted Epic set**.
- If the Accepted Epic set is empty: stop and tell the user:
  > No Accepted Epics yet. Have the human reviewer accept at least one Epic in `/create-epics` (set its frontmatter `status: Accepted`) before invoking `/create-stories`.

The skill operates **only on Accepted Epics**. Pending and Rejected Epics are skipped — their Stories are minted on a future re-run after the human approves the Epic. This incremental gate (vs. an all-or-nothing one) lets large projects land Story work for one Epic while other Epics are still being negotiated upstream.

Also verify the upstream chain has not regressed:

- The Elicitation Document at `artifacts/01-elicitation/elicitation-document.md` must exist and have `status: Approved` in its frontmatter. If not: stop. (An Accepted Epic should not exist if the upstream elicit doc was un-Approved, but the skill checks defensively.)

---

## Step 1 — Read upstream artifacts

Read the Elicitation Document and extract every element the Story phase needs:

| What | Why |
|------|-----|
| SH-### with Role and Primary Concerns | Story narrative "As a <Role>" and "so that <outcome>" composition |
| BUC-### Description, Primary Actor, Trigger, Expected Outcome | Story narrative outcome; parent traceability |
| FR-### Description, Priority, Business Use Case, Stakeholder, Source, Status | Eligibility filter; narrative action; parent traceability |
| Section 6 Acceptance Criteria — every AC-FR-###-NN row | **Lifted verbatim** into the Story (Status=Pending preserved on a fresh AC; Accepted ACs stay Accepted) |
| NFR-### with Category, Measurable Target, Business Use Case scope | Implementation Notes (NFR exposure for the Story's parent Epic) |
| CON-### with Type | Implementation Notes (regulatory / organisational constraints) |

Read every Accepted Epic file from Step 0 and capture: EP-ID, Title, Primary BUC(s), In-Scope FRs, In-Scope NFRs (with cross-cutting flag), Constraints, Owner.

For each Accepted FR, compute its **eligibility** for Story minting:

- The FR's `Business Use Case` field references at least one BUC that is the Primary BUC of an Accepted Epic, AND
- The FR's `Status` is `Accepted`.

FRs that fail eligibility are **skipped this run**. Their Stories will be minted in a future run if the parent Epic is later Accepted.

---

## Step 2 — Read existing Story files

Read every file matching `artifacts/03-user-stories/story-*.md` and `artifacts/03-user-stories/index.md`. For each, capture: US-ID, Title, Parent Epic (EP-###), Parent FR (FR-###), Status, Owner, Story Points, Dependencies, OQs referenced.

Compute the running counters:

- `next_US_id = max(existing US-### across all story files) + 1`
- `next_OQ_id = max(OQ-### across elicit doc + every Epic file + every Story file) + 1`

US-### IDs and OQ-### IDs are never reused, even after deletion or rejection. The shared OQ namespace continues forward through the pipeline.

---

## Step 3 — Mint or update one Story per eligible FR

For every eligible FR (from Step 1):

- **No matching Story exists** (no story-*.md has `parent-fr: FR-###`): mint a new Story. Assign `next_US_id`. Increment counter. Create `artifacts/03-user-stories/story-NNN.md` from `skills/create-stories/templates/story.md`.
- **Matching Story exists, Status = Pending**: refine fields (per Step 4) in place. Preserve US-###. Update `last-updated` frontmatter.
- **Matching Story exists, Status = Accepted**: do **not** modify any field. Append a review note to Section 12 (Revision History) only:
  > `Note YYYY-MM-DD: re-run on /elicit or /create-epics update — human review of this Story recommended.`
- **Matching Story exists, Status = Rejected**: same as Accepted. The US-### is permanently retired but the file is preserved for audit.
- **An Accepted Story references an FR that is no longer in the elicit doc** (the FR was deleted or renamed upstream): append review note + log `OQ Severity=High` asking the human to reconcile.

The skill never restructures: it does not split or merge Stories, and it does not change a Story's parent FR or parent Epic on re-run. Restructuring requires explicit human action (Reject the existing Story, edit the elicit/epic upstream, then re-run).

---

## Step 4 — Populate Story fields

For every Pending Story (do not modify Accepted/Rejected), populate every field. When information is not derivable, generate an OQ at the appropriate severity rather than inventing content.

### 4.1 — Title and frontmatter

- **Title:** the parent FR's title verbatim.
- **Frontmatter:** `artifact: user-story`, `project: <name>`, `us-id: US-###`, `parent-epic: EP-###`, `parent-fr: FR-###`, `status: Pending`, `owner: SH-###`, `story-points: <heuristic>`, `priority: <FR Priority>`, `created`, `last-updated`, `reviewed-by`, `approved-date`.

### 4.2 — Connextra narrative (Section 1)

Compose `As a <role>, I want <action>, so that <outcome>` from upstream sources:

- **`<role>`:** the parent FR's `Stakeholder` (SH-###), expressed as the Stakeholder's `Role` field (e.g., `Product Owner`, `End User`). If multiple stakeholders are referenced, use the first.
- **`<action>`:** the parent FR's Description, stripped to its core verb-object phrase. Drop the `The system SHALL/SHOULD/MAY` prefix and rephrase as a first-person user goal. Example: FR.Description "The system SHALL provide a control to start a real-time location sharing session" → action "start a real-time location sharing session".
- **`<outcome>`:** the parent BUC's `Expected Outcome`, expressed as a user-facing benefit. Example: BUC-001 Expected Outcome "Selected contacts receive a live location pin" → outcome "selected contacts can see where I am".

If any of the three components cannot be derived cleanly (ambiguous Description, missing Expected Outcome, unclear Role): fill the field with a best-effort phrasing **and** generate `OQ Severity=Medium`: `"US-### narrative <component> is unclear. Refine the upstream FR/BUC/SH or rewrite the narrative directly."`

### 4.3 — Acceptance Criteria (Section 4)

**Lift verbatim** every AC-FR-###-NN row from elicit doc Section 6 that has the parent FR as its prefix. Preserve the AC ID, the Given/When/Then text (or the Criterion field for NFR-derived ACs), and the AC's existing Status / Accepted By / Accepted Date — these acceptance fields belong to the AC, not the Story, and must not be regenerated as Pending if they are already Accepted in the elicit doc.

If the parent FR has zero ACs in elicit Section 6: generate `OQ Severity=Critical`: `"FR-### has no Acceptance Criteria in the Elicitation Document. Story US-### cannot be implemented without a testable definition of done."`

### 4.4 — Definition of Done (Section 5)

Every Story carries a Definition of Done with these baseline items (the skill writes them; the human team adapts on Acceptance):

- All Acceptance Criteria pass in automated tests
- Code reviewed and approved by at least one peer
- No regressions in tests for related Stories
- Documentation (user-facing or API) updated where the Story changes observable behaviour
- Deployed to a staging environment matching production configuration

The team may add or remove items per their delivery context; the AI's role is to seed a sane default, not to authority on team practice.

### 4.5 — Story Points (Section 6)

Compute a Fibonacci-band estimate from observable signals:

| Points | Trigger |
|--------|---------|
| 1 | 1 AC AND no Performance/Security NFR is In-Scope of the parent Epic |
| 2 | 2 ACs AND no Performance/Security NFR |
| 3 | 3 ACs AND no Performance/Security NFR |
| 5 | 1–3 ACs AND parent Epic contains a Performance OR Security NFR; OR 4–5 ACs with no NFR |
| 8 | 4+ ACs AND parent Epic contains a Performance/Security NFR; OR parent Epic carries a Regulatory CON binding this FR |
| 13 | 6+ ACs, OR a 4+ AC Story whose parent Epic carries multi-NFR exposure plus a Regulatory CON — flag for splitting |

If the heuristic produces 13: also generate `OQ Severity=High`: `"US-### sized at 13 points is too large for a single sprint. Consider splitting along ACs that test independent observable outcomes."`

Always carry the note `**AI estimate — confirm with team.**` Sizing is not derivable from the upstream artefacts; the AI provides a defensible starting point so the planning meeting begins with something concrete.

### 4.6 — Dependencies (Section 7)

Populate `Depends on` and `Blocks` only when the elicit doc or the parent Epic explicitly states a dependency:

- The parent FR's `Rationale` field references another FR's outcome (e.g., "Complementary to FR-001 — sharing is only useful if the recipient can see the location" implies FR-003 depends on FR-001 → US-003 depends on US-001).
- The parent BUC's `Trigger` field names another BUC's Expected Outcome.
- The parent Epic's `Dependencies` section lists an EP-level dependency that propagates to each Story it contains.

Do **not** invent dependencies. Cycles between Pending Stories are detected in Step 5 and generate `OQ Severity=Critical`.

### 4.7 — Implementation Notes (Section 8)

Capture only **non-trivial** technical context derivable from upstream artefacts:

- Cross-cutting NFRs from the parent Epic that constrain this Story's implementation (e.g., "NFR-002 Session Authentication applies — this Story's API endpoints MUST be authenticated").
- Component diagram references (Section 4.0 of the elicit doc) when the Story affects a specific component.
- Regulatory CONs that the implementation must satisfy.

If no constraints are derivable: write `(none — this Story is unconstrained beyond the project-wide CONs)`. Do not pad with generic engineering advice.

### 4.8 — Owner and Acceptance fields (Section 11)

- **Owner:** the parent FR's `Stakeholder` (SH-###); default `Accepted By` to the same.
- **Status:** `Pending` (the human reviewer changes it).
- **Accepted Date:** `—`.
- **Source:** `elicitation-document.md (FR-###); parent epic-NNN.md (EP-###)`.

---

## Step 5 — Validation (Pending Stories only)

Run every check; add OQs at the indicated severity.

1. **FR coverage:** every Accepted FR linked to an Accepted Epic has exactly one Pending or Accepted Story. Orphan → `Critical`. Duplicate (two Stories with same parent FR) → `Critical`.
2. **AC coverage:** every Pending Story has at least one AC referenced from elicit Section 6. Empty → `Critical` (already raised in Step 4.3).
3. **Owner present:** every Pending Story has Owner = SH-###. Missing → `Critical`.
4. **Dependency cycle:** topological sort over `Depends on` edges across Pending Stories. Cycle → `Critical`.
5. **Story-points sanity:** every Pending Story has a Story Points value 1–13 with the "AI estimate — confirm with team" note. Story sized 13 → `High` (split flag — already raised in Step 4.5).
6. **Narrative sanity:** every Pending Story has a non-empty `As a / I want / so that` narrative. Empty or placeholder → `Medium` (already raised in Step 4.2).

Add a one-line summary to the index.md changelog: `"Validation: [N] OQs added across coverage / owner / cycle / sanity checks."`

---

## Step 6 — Build `index.md`

`index.md` is **always fully rebuilt** every run from the current state of all Story files. Never merge.

Sections:

1. **Project Overview** — counts (Pending / Accepted / Rejected), source elicit doc + Accepted Epic count, Story coverage stats.
2. **Story Map** — Mermaid `flowchart LR` showing each Accepted Epic as a parent node with arrows to every Story under it. Use numeric-only node IDs (`EP001`, `US001`).
3. **Story List** — table: US-ID, Title, Parent Epic, Parent FR, Owner, Priority, Story Points, Status, file path.
4. **FR Coverage Matrix** — every Accepted FR linked to an Accepted Epic with the Story it generated and a `Status` of Covered / Orphan.
5. **Epic Grouping** — for each Accepted Epic: list its Stories with point totals, Owner.
6. **Open Questions (across all Stories)** — every Open OQ from every Story file, sorted by Severity (Critical → High → Medium → Low). Includes OQ-ID, Severity, Question, Affecting Story, Status.
7. **Acceptance Status Overview** — table: US-ID, Title, Owner, Status, Accepted Date.
8. **Revision History** — append today's date and one-line summary of this run's changes.

Use the framework's Mermaid conventions: `%%{init: {'theme': 'neutral'}}%%`, no `<br/>` in labels, short single-phrase labels, numeric-only node IDs.

---

## Step 7 — Write outputs

1. For each Pending Story with changes: rewrite `artifacts/03-user-stories/story-NNN.md` (NNN zero-padded to 3 digits matching US-### number). Update `last-updated` frontmatter.
2. For each Accepted/Rejected Story with appended review notes: write only Section 12; leave Sections 1–11 untouched.
3. For each newly-minted Story: create a new file from `skills/create-stories/templates/story.md`.
4. Always rewrite `artifacts/03-user-stories/index.md` from scratch using the data assembled in Step 6.

Do not delete files — even Rejected Stories persist so the US-### is auditable.

---

## Step 8 — Review gate

Present to the user:

> **Changes in this run:**
> - **ADDED:** [list new US-IDs with one-line title and parent EP-###]
> - **REFINED:** [list Pending Stories updated, with reason — e.g., "US-005: AC-FR-005-02 updated upstream; Story Points recomputed S=3 → 5"]
> - **UNCHANGED:** [list Pending Stories with no new information this run, or omit if long]
> - **PROTECTED:** [list Accepted/Rejected Stories that received review notes only]
> - **DEFERRED:** [list FRs whose Stories were not minted because the parent Epic is not Accepted yet — informational]
> - **COVERAGE:** [N FRs eligible (Accepted FR + Accepted Epic), M Stories minted or refined; orphans: list FR-IDs]

If any OQs remain Open:
> **Warning — Unresolved Open Questions:** [table of open OQs with Severity column]
> Critical OQs block APPROVED. High/Medium/Low OQs do not block but will affect downstream artifacts.

Then give your **Professional Assessment** — cite specific element IDs:

**Blocking — APPROVED is invalid until resolved:**
- Critical OQs still Open: list OQ-### IDs.
- Pending Stories with no Owner: list US-### IDs.
- Orphaned eligible FRs (Accepted FR + Accepted Epic but no Story): list FR-### IDs.
- Pending Stories with zero ACs: list US-### IDs.
- Dependency cycles: cite the cycle.

**Advisory — flag before approval:**
- Stories sized at 13 points (split-flag): list US-### IDs.
- Stories whose narrative was AI-best-effort (Step 4.2 OQ-Medium present): list US-### IDs and recommend human refinement.
- Stories whose parent Epic is now non-Accepted (e.g., Epic was Rejected after the Story was minted): list US-### IDs and recommend Story rejection.

If none of these issues exist: state `"No quality concerns — Story set is ready for approval."`

> Review `artifacts/03-user-stories/index.md` first, then drill into each `story-NNN.md`.
> Type **APPROVED** to proceed to `/create-srs`, or provide corrections.
> **Approval is invalid if any Critical OQ is Open or any Pending Story lacks an Owner, an AC, or carries an orphaned eligible FR.**

On APPROVED: state `"Story phase complete. You may now run /create-srs."`
Do not invoke the next skill automatically.

---

## ID Reference

| Artifact | Format | Example | Source |
|----------|--------|---------|--------|
| User Story | US-### | US-001 | minted by this skill |
| Open Question | OQ-### | OQ-014 | continues from elicit + epic namespaces |
| Acceptance Criterion | AC-FR-###-NN | AC-FR-001-01 | inherited from elicit Section 6 (not minted by this skill) |

US-### IDs are never reused, even after deletion or rejection. OQ-### IDs are never reused — including across the elicit doc, all Epic files, and all Story files.

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| `artifacts/02-epics/` does not exist or is empty | Stop in Step 0. "Run `/create-epics` first." |
| No Accepted Epics | Stop in Step 0. "Have the human accept at least one Epic in `/create-epics`." |
| Elicit doc has regressed (status no longer `Approved`) | Stop. Tell user to re-Approve in `/elicit`. |
| All eligible FRs already have Stories and nothing has changed | Run completes; index.md is rebuilt; review gate reports `UNCHANGED` for every Story. |
| FR linked to multiple BUCs spanning Accepted + non-Accepted Epics | Treat as eligible (one Accepted-Epic parent is enough). Pick the Accepted Epic's EP-ID as the Story's parent-epic. If multiple Accepted Epics share the FR (impossible by `/create-epics` design but checked defensively): generate `OQ Severity=Critical`. |
| Existing Story file references EP-### that is no longer Accepted | Append review note + `OQ Severity=High`: "Parent Epic of US-### is no longer Accepted. Review whether this Story should be Rejected." |
| Existing Story file references FR-### that is no longer in elicit doc | Append review note + `OQ Severity=High`: "Parent FR of US-### is no longer in the elicit doc. The FR was deleted, renamed, or merged — reconcile manually." |
| Human edited a Story file manually between runs | Read current state as truth. Re-derive index.md. Do not overwrite manual edits in regenerated sections of Pending Stories. |
| Two Pending Stories with identical Parent FR (defensive) | Pick the lower US-ID; mark the higher as Rejected with note "duplicate of US-### — superseded". `OQ Severity=High` asks the human to confirm. |
