# Skill: create-epics

**Purpose:** Decompose the approved Elicitation Document into a set of Epics — one Markdown file per Epic plus a generated `index.md` aggregator. Every run reads the elicit doc and any existing epic files, applies the BUC-default-with-merge/split heuristic, allocates Accepted requirements to Epics, populates IEEE/SAFe-style Epic fields, and produces a single review gate over the whole Epic set. Re-runs preserve Accepted Epics, refine Pending Epics, and never reuse EP-IDs.

**Invocation:**
- Claude Code: `/create-epics`
- GitHub Copilot: "Run the create-epics skill" or "Follow `skills/create-epics/skill.md`"

**Inputs:**
- `artifacts/01-elicitation/elicitation-document.md` (must have `status: Approved` in frontmatter)
- `artifacts/02-epics/epic-*.md` and `artifacts/02-epics/index.md` (existing Epics, if any)

**Outputs:**
- `artifacts/02-epics/epic-NNN.md` (one file per Epic, NNN = zero-padded EP-### sequence)
- `artifacts/02-epics/index.md` (rebuilt every run from current Epic files)

---

## Step 0 — Approval gate (hard)

Open `artifacts/01-elicitation/elicitation-document.md` and read its YAML frontmatter.

- If `status` is not `Approved`: stop and tell the user:
  > Elicitation Document is not Approved (current status: `<value>`). Run `/elicit` and have the human approve before invoking `/create-epics`.
- If the document does not exist: stop and tell the user to run `/elicit` first.

Then scan the elicit doc body:

- If any Open Question with Severity = Critical has Status = Open: stop. List the OQ-IDs and tell the user to resolve them in `/elicit` first. Per `skills/GOVERNANCE.md`, APPROVED is invalid while a Critical OQ is Open — do not proceed.
- If any NFR has Measurable Target equal to `PENDING — see OQ-xxx` or contains only qualitative language: stop. List the NFR-IDs and tell the user to resolve in `/elicit` first.

This gate enforces the same Approval Integrity Rules that `/elicit` enforces. The skill never silently proceeds on an unstable upstream artifact.

---

## Step 1 — Read the Elicitation Document

Extract every element with its current Status and acceptance fields. Tag the source as `elicitation-document.md`.

| Element | Capture |
|---------|---------|
| Stakeholders | SH-### → name, role, primary concerns |
| Business Use Cases | BUC-### → title, description, primary actor, expected outcome, accepted by, status |
| Functional Requirements | FR-### → title, description, priority, BUC link, source, status, accepted by |
| Non-Functional Requirements | NFR-### → title, description, category, measurable target, BUC link(s), priority, status, accepted by |
| Constraints | CON-### → title, description, type, status |
| Assumptions | ASMP-### → description, owner, status |
| Risks | RSK-### → description, owner, likelihood, impact, status |
| Open Questions | OQ-### → question, severity, status |

Note the **highest existing OQ-### across the elicit doc** — new OQs created by this skill will continue from `max + 1`.

---

## Step 2 — Read existing Epic files

Read every file matching `artifacts/02-epics/epic-*.md`. Also read `artifacts/02-epics/index.md` if present.

For each existing Epic file capture: EP-ID, Title, Status, Owner, Primary BUC(s), In-Scope FR/NFR/CON sets, Dependencies, Success Metrics, Effort estimate, Open Questions referenced.

Also scan all existing Epic files for **the highest OQ-### referenced**. Update the running OQ-### counter to `max(elicit_max, epic_max)`.

If no Epic files exist: this is a first run. The next-EP-ID counter starts at `EP-001`.

---

## Step 3 — Seed Epics (one per BUC)

For every BUC-### in the elicit doc with Status = Accepted, build a seed Epic candidate:

- **Title:** the BUC's title (verbatim — refine in Step 7)
- **Primary BUC:** BUC-###
- **In-Scope FRs:** every FR with Status = Accepted whose Business Use Case field = this BUC
- **In-Scope NFRs:** every NFR with Status = Accepted whose Business Use Case field includes this BUC
- **Owner:** the BUC's Accepted By (an SH-###)

A seed Epic with zero Accepted FRs **and** zero Accepted NFRs is deferred — do not mint an EP-### for it. Generate OQ Severity=Medium: "BUC-### has no Accepted requirements yet — Epic seed deferred until at least one FR or NFR is accepted in `/elicit`."

A seed Epic for a BUC whose Status is not Accepted is also deferred — generate OQ Severity=Medium: "BUC-### is not Accepted — Epic seed deferred."

---

## Step 4 — Apply merge/split heuristic (first-run only for each BUC)

The heuristic only proposes structural changes when minting a new Epic for a BUC. Once an Epic for a BUC exists in `artifacts/02-epics/`, the skill does **not** silently restructure it on re-run — restructuring requires human direction.

### 4a — Merge

In the Elicitation Document each FR links to exactly one BUC, while an NFR may span several BUCs. FR-overlap between two BUCs is therefore zero by construction — the merge heuristic must read coupling from BUC-level signals instead.

For each pair of seed Epics A and B that **do not yet have a corresponding existing Epic file**, propose a merge when **both** of these signals hold:

1. **Shared NFR coupling:** the count of NFRs that are In-Scope of both A and B (cross-cutting NFRs that reference both BUCs) is ≥ 2 **and** ≥ 50% of the smaller seed's NFR set, AND
2. **Same Primary Actor:** BUC.Primary Actor is the same SH-### for both BUCs.

Or, independently, propose a merge when:

3. **Sequential coupling:** the `Trigger` field of one BUC explicitly names the other BUC's title or Expected Outcome (the second BUC is the natural continuation of the first).

For each proposed merge:
- Combine both BUCs into the merged Epic's `Primary BUC(s)` field.
- Union the in-scope FR/NFR sets (FRs from each BUC plus the shared cross-cutting NFRs, listed once).
- Mint a single EP-### for the merged Epic.
- Generate OQ Severity=High: "EP-### was seeded by merging BUC-AAA and BUC-BBB. Signal: [shared NFRs: NFR-###, NFR-###; same Primary Actor SH-###] / [sequential coupling: BUC-BBB.Trigger names BUC-AAA]. Confirm the merger, or instruct to keep them separate."
- Record `merged-from: [BUC-AAA, BUC-BBB]` in the Epic's Source field.

### 4b — Split

For each seed Epic with **more than seven In-Scope FRs** that does not yet have a corresponding existing Epic file:

- Cluster its FRs by sub-theme: group by shared action verb, target noun, or stakeholder owner.
- If a clean partition into 2 sub-themes exists (each cluster ≥ 2 FRs), propose splitting.
- Mint one EP-### per resulting sub-Epic.
- Generate OQ Severity=High: "EP-### through EP-### were seeded by splitting BUC-XXX (N FRs) along sub-themes [theme-1] / [theme-2]. Confirm the split, or instruct to keep merged."
- Record `split-from: BUC-XXX` in each resulting Epic's Source field.

If no clean partition exists for a >7-FR seed: do not split. Generate OQ Severity=Medium: "EP-### covers BUC-XXX with N FRs but no clean sub-theme partition was found. Consider whether this Epic is too large — a split may require human reframing of the BUC."

### 4c — Cross-cutting NFR allocation

For every Accepted NFR whose Business Use Case field references multiple BUCs, or equals "General" / blank:

- Add this NFR to the In-Scope NFR set of every Epic whose Primary BUC(s) include any referenced BUC (or every Epic, if "General").
- Mark the NFR `cross-cutting: yes` in each Epic's NFR table.

This is the only case where a single FR/NFR may legitimately appear In-Scope of more than one Epic. FRs are never duplicated across Epics.

---

## Step 5 — Match seeds against existing Epic files

For each seed Epic produced by Step 3 + Step 4:

- **Match found by Primary BUC(s) overlap, existing Status = Pending:** update in place, preserve EP-ID. Refine fields per Step 7. Do not change Primary BUC(s) silently — if Step 4 would change them, generate OQ Severity=High: "Re-run analysis suggests restructuring EP-### (currently covers BUC-XXX) to also cover BUC-YYY. Confirm or reject."
- **Match found, existing Status = Accepted or Rejected:** do not modify the Epic file content. Append a review note at the bottom of Section 12 (Revision History): `Note [YYYY-MM-DD]: re-run on /elicit update — human review of this Epic recommended.` Continue: do not regenerate any field.
- **No match:** assign the next available EP-### and create a new file from `skills/create-epics/templates/epic.md`.

EP-### IDs are **never reused**, even after deletion or rejection. Track the next-available counter as `max(EP-### across all existing files and existing index.md) + 1`.

---

## Step 6 — Allocate remaining elements

After Step 4 and Step 5, every Accepted FR must belong to exactly one Epic; every Accepted NFR must belong to at least one Epic; every Accepted CON must be referenced by every Epic it constrains.

For each Accepted CON in the elicit doc: include it in the Constraints table of every Epic whose In-Scope FRs/NFRs the CON binds. If a CON is system-wide (Type = Regulatory or Organizational): include in every Epic.

For each Pending FR/NFR linked to a BUC that has an Epic: list it in that Epic's "Candidate Requirements (Pending)" section — informational only, not In-Scope. Do this even if the Epic's Status is Accepted (the Candidate section is informational and may be regenerated; do not touch any other section of an Accepted Epic).

For each Rejected FR/NFR linked to a BUC that has an Epic: list it in that Epic's Out-of-Scope section with one-line citation.

---

## Step 7 — Populate Epic fields

For each Pending Epic (do not modify Accepted/Rejected Epics), populate every field. When information is not derivable from the elicit doc, **do not invent it** — generate an OQ at the appropriate severity instead.

| Field | Source | If not derivable |
|-------|--------|------------------|
| Description | One paragraph synthesised from BUC.Description + In-Scope FR titles | OQ Severity=Medium: "EP-### needs a clearer description — the BUC description was thin and FRs span multiple themes." |
| Business Value | BUC.Expected Outcome + Stakeholder.Primary Concerns of the Owner | OQ Severity=High: "EP-### has no clear business value statement. What outcome does this Epic deliver?" |
| Primary BUC(s) | from Step 4 | n/a (always set) |
| Priority | The highest priority among In-Scope FRs/NFRs (Must Have > Should Have > Could Have > Won't Have) | n/a |
| Effort (T-shirt) | Heuristic only: S = ≤2 FRs and no Performance/Security NFR; M = 3–5 FRs; L = 6–7 FRs or contains a Performance/Security NFR; XL = >7 FRs or contains regulatory CON | always include note "AI estimate — confirm with team" |
| Dependencies (Depends on / Blocks) | Only if elicit doc explicitly states — e.g., FR.Rationale references another FR's BUC, or BUC.Trigger references another BUC's outcome | leave table empty; do not invent |
| Success Metrics | Copy each measurable target verbatim from In-Scope NFRs | If no In-Scope NFR has a measurable target → OQ Severity=High: "EP-### has no measurable success metrics. What KPI defines success for this Epic?" |
| Owner | BUC's Accepted By (SH-###) | OQ Severity=Critical: "EP-### has no Owner — BUC-XXX has no Accepted By." |
| Accepted By | same as Owner (default; human may override at review time) | n/a |

The skill must not invent dependencies or metrics. The Epic's job at this phase is to organise existing requirements into outcome-shaped containers, not to generate net-new requirements.

---

## Step 8 — Validation checks (Pending Epics only)

Run every check against the current set of Pending Epics. Add OQs at the indicated severity.

1. **FR coverage:** every Accepted FR appears In-Scope of exactly one Epic. Orphan → OQ Severity=Critical: "FR-### is Accepted but not In-Scope of any Epic. Which Epic should cover it?" Duplicate (in two Epics) → OQ Severity=Critical: "FR-### is In-Scope of EP-AAA and EP-BBB. FRs may not be duplicated across Epics — only cross-cutting NFRs may be."
2. **NFR coverage:** every Accepted NFR appears In-Scope of at least one Epic. Orphan → OQ Severity=Critical: "NFR-### is Accepted but not In-Scope of any Epic."
3. **Epic owner:** every Pending Epic has Owner = SH-###. Missing → OQ Severity=Critical (per Step 7).
4. **Dependency cycle:** topological sort over `Depends on` edges across Pending Epics. Cycle → OQ Severity=Critical: "Dependency cycle detected: EP-AAA → EP-BBB → EP-AAA. Resolve by removing or inverting one edge."
5. **Measurable success metric:** every Pending Epic with Priority = Must Have has at least one entry in Success Metrics (per Step 7).
6. **Effort sanity:** every Pending Epic carries the "AI estimate — confirm with team" note on its Effort field.

Add a one-line summary to the index.md changelog: "Validation: [N] OQs added across coverage/owner/cycle/metric checks."

---

## Step 9 — Build `index.md`

`index.md` is **always fully rebuilt** from the current state of all `epic-*.md` files. Never merge into the previous index.

Sections to generate:

1. **Project Overview** — project name (from elicit doc frontmatter), counts (Pending / Accepted / Rejected), elicit doc version + Approved date.
2. **Epic Map** — Mermaid `flowchart LR` showing each BUC node arrow-linking to its Epic node. Cross-cutting NFRs shown as a separate floating subgraph linking to multiple Epics.
3. **Epic List** — table: EP-ID, Title, Primary BUC(s), Owner, Priority, Effort, Status, file path.
4. **FR Coverage Matrix** — every Accepted FR with the Epic it belongs to (and status: Covered / Orphan).
5. **NFR Coverage Matrix** — every Accepted NFR with the Epic(s) it belongs to (and Cross-cutting flag).
6. **Open Questions (across all Epics)** — every Open OQ from every Epic file, sorted by Severity (Critical → High → Medium → Low). Include OQ-ID, Severity, Question, Affecting Epic, Status.
7. **Acceptance Status Overview** — table mirroring Section 8 of the elicit doc but for Epics: EP-ID, Title, Owner, Status, Accepted Date.
8. **Revision History** — append today's date and one-line summary of this run's changes.

Use the elicit doc's Mermaid conventions: `%%{init: {'theme': 'neutral'}}%%`, no `<br/>` in labels, short single-phrase labels, numeric-only node IDs (`EP001`, `BUC001`).

---

## Step 10 — Write outputs

1. For each Pending Epic with changes: rewrite the corresponding `artifacts/02-epics/epic-NNN.md` (NNN zero-padded to 3 digits matching EP-### number). Update its `last-updated` frontmatter to today.
2. For each Accepted/Rejected Epic with appended review notes: write only the Section 12 update — leave every other section untouched.
3. For each newly-minted Epic: create a new file from `skills/create-epics/templates/epic.md`.
4. Always rewrite `artifacts/02-epics/index.md` from scratch using the data assembled in Step 9.

Do not delete files — even if an Epic is rejected, the file persists so the EP-ID is auditable.

---

## Step 11 — Review gate

Present to the user:

> **Changes in this run:**
> - **ADDED:** [list new EP-IDs with one-line title]
> - **REFINED:** [list Pending EPs updated, with reason — e.g., "EP-002: NFR-005 added as cross-cutting"]
> - **UNCHANGED:** [list Pending EPs with no new information this run, or omit if long]
> - **PROTECTED:** [list Accepted/Rejected EPs that received review notes only]
> - **MERGED/SPLIT:** [list each merge or split with the OQ-### that asks for confirmation]
> - **COVERAGE:** [N FRs, M NFRs, K CONs allocated; orphans: list FR/NFR-IDs]

If any OQs remain Open:
> **Warning — Unresolved Open Questions:** [table of open OQs with Severity column]
> Critical OQs block APPROVED. High/Medium/Low OQs do not block but will affect downstream artifacts.

Then give your **Professional Assessment** — cite specific element IDs:

**Blocking — APPROVED is invalid until resolved:**
- Critical OQs still Open: list OQ-### IDs.
- Pending Epics with no Owner: list EP-### IDs.
- Orphaned Accepted FRs/NFRs: list FR-### / NFR-### IDs.
- Dependency cycles: cite the cycle.

**Advisory — flag before approval:**
- Pending Epics with > 7 In-Scope FRs that resisted clean splitting: list EP-### IDs and recommend reframing the underlying BUC.
- Merge/split proposals (Step 4) without human confirmation yet.
- Pending Must-Have Epics with no measurable Success Metric.
- Effort estimates that look implausibly small (M with regulatory CON) or large (XL with ≤3 FRs).

If none of these issues exist: state "No quality concerns — Epic set is ready for approval."

> Review `artifacts/02-epics/index.md` first, then drill into each `epic-NNN.md`.
> Type **APPROVED** to proceed to `/create-stories`, or provide corrections.
> **Approval is invalid if any Critical OQ is Open or any Pending Epic lacks an Owner or has an unresolved orphan FR/NFR.**

On APPROVED: "Epic phase complete. You may now run `/create-stories`."
Do not invoke the next skill automatically.

---

## ID Reference

| Artifact | Format | Example | Source |
|----------|--------|---------|--------|
| Epic | EP-### | EP-001 | minted by this skill |
| Open Question | OQ-### | OQ-007 | continues from elicit doc's namespace |

EP-### IDs are never reused. OQ-### IDs are never reused — including across the elicit doc and all Epic files.

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| Elicit doc not Approved | Stop in Step 0. Tell user to approve in `/elicit` first. |
| Elicit doc has Critical OQ Open or unmeasured NFR | Stop in Step 0. Tell user to resolve in `/elicit` first. |
| Elicit doc has zero Accepted BUCs | Stop. Report: "No Accepted BUCs — no Epics can be derived. Have stakeholders accept BUCs in `/elicit` first." |
| All FRs/NFRs are Pending (none Accepted) | Stop. Report: "No Accepted FRs/NFRs — In-Scope sets would be empty. Accept individual requirements in `/elicit` first." |
| Existing Epic file references FR-### no longer in elicit doc | Add review note + OQ Severity=High: "EP-### references FR-### which is no longer in the elicit doc. Was it deleted, renamed, or merged?" |
| Human edited an Epic file manually between runs | Read current state as truth. Re-derive index.md from current state. Do not overwrite manual edits except in regenerated sections of Pending Epics. |
| Merge proposal where one of the candidate Epics is already Accepted | Do not merge. Add OQ Severity=Medium: "EP-### (Accepted) and EP-XXX (Pending) overlap heavily — restructuring would require re-opening EP-###. Skipped." |
| Two Pending Epics with identical Primary BUC (defensive) | Pick the lower EP-ID, mark the higher as Rejected with note "duplicate of EP-### — superseded". Add OQ Severity=High asking the human to confirm. |
