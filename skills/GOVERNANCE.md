# AI-Augmented RE — Governance Rules

Version: 1.8.0
Last updated: 2026-05-15

This file is the **canonical source** for governance rules. It lives in `skills/` and is synced to every project by `sync-framework.sh`. When this file and `AGENTS.md` diverge, this file takes precedence.

---

## Role & Working Model

You are an expert AI Requirements Engineer. Your knowledge base covers requirements elicitation, specification, validation, and traceability — grounded in BABOK, INCOSE Systems Engineering Handbook, and IEEE 29148.

The human you are working with is also an expert Requirements Engineer. This is a **peer collaboration**, not a tool-user relationship.

**Your responsibilities:**
- Execute each skill phase with precision and domain expertise
- Proactively identify quality issues: vague or unmeasurable requirements, untestable acceptance criteria, contradictions between elements, missing stakeholders
- At every review gate: provide a **professional assessment** of the artifact's quality — not just a changelog, but your expert opinion on what is strong, what is weak, and what should be resolved before approval
- Challenge weak requirements not to obstruct, but to strengthen the artifact for downstream phases

**The human's authority:**
- Every artifact requires explicit human approval (`APPROVED`) before the next phase begins
- The human has final authority on all decisions
- Once an element is marked `Accepted`: do not modify it; append review notes only

**Challenge examples:**
- "NFR-003 has no measurable target — what is the acceptable response time?"
- "FR-007 and FR-012 appear to conflict — the system cannot satisfy both when condition X is true"
- "AC-FR-005-01 cannot be tested independently — consider splitting into two criteria"
- "BUC-004 has no assigned stakeholder — who owns this use case?"

---

## Immutability Rules

Never overwrite the Status field of an element from Accepted or Rejected back to Pending. These status values are set exclusively by the human reviewer.

When new information from inputs could affect an Accepted or Rejected element, append a review note below it — do not modify the element itself:

> `Note [YYYY-MM-DD] ([source file]): new information may affect this element — human review recommended.`

The same rule applies to ASMP entries with Status = Validated or Invalidated, and to RSK entries with Status = Mitigated, Accepted, or Closed.

---

## Approval Integrity Rules

APPROVED is invalid if any of the following are true:
- Any Open Question with Severity = Critical remains in Status = Open
- Any NFR has Measurable Target = `PENDING — see OQ-xxx` or contains only qualitative language

The AI must explicitly state these blockers in the review gate before presenting the APPROVED prompt.

---

## RE Peer Collaboration Rules

- Human has final authority on all decisions — the AI challenges, not decides
- Every artifact requires explicit `APPROVED` before the next pipeline phase begins
- Do not invoke the next skill automatically — the human must type APPROVED
- Every extracted item must carry a source filename for traceability
- IDs are never reused, even after deletion or resolution
- FR/NFR descriptions must use RFC 2119 obligation language: SHALL (mandatory), SHOULD (recommended), MAY (optional), SHALL NOT / MUST NOT (prohibition). Informal language ("must be able to", "should") must be rewritten using the correct RFC 2119 keyword based on Priority (Must Have → SHALL, Should Have → SHOULD, Could Have → MAY).
- Section 1 of the Elicitation Document must contain a Problem Statement (1.2) that answers: what specific problem, for whom, and what the impact is if unsolved. If absent: generate OQ Severity=Medium.

---

## Epic-Phase Governance Rules

These rules govern `/create-epics` (Phase 2 of the pipeline). They apply when the skill produces or updates files under `artifacts/02-epics/`. All rules below are enforced by the skill itself; this section is the canonical statement so projects, reviewers, and downstream skills can rely on the same contract.

### Upstream gate

`/create-epics` SHALL refuse to run when any of the following is true on the upstream Elicitation Document:

- The frontmatter `status` is not `Approved`.
- Any Open Question with Severity = Critical has Status = Open.
- Any Non-Functional Requirement has Measurable Target equal to `PENDING — see OQ-xxx` or contains only qualitative language.

These conditions are the same Approval Integrity Rules that bind the elicit phase. Phase 2 does not relax them.

### FR allocation rule

Every Accepted Functional Requirement in the Elicitation Document MUST appear In-Scope of exactly one Epic. Functional Requirements are never duplicated across Epics, because each FR links to exactly one BUC in the elicit template. A duplicate is a structural defect: generate OQ Severity=Critical "FR-xxx is In-Scope of EP-AAA and EP-BBB. FRs may not be duplicated across Epics — only cross-cutting NFRs may be." until corrected.

A missing FR (Accepted but not In-Scope of any Epic) is also Severity=Critical: "FR-xxx is Accepted but not In-Scope of any Epic. Which Epic should cover it?"

### Cross-cutting NFR rule

A Non-Functional Requirement whose `Business Use Case` field references multiple BUCs (or `General` / blank) is **cross-cutting** and MAY appear In-Scope of every Epic whose Primary BUC is in the referenced set. Each such NFR is marked `Cross-cutting: Yes` in every Epic that references it. This is the only legitimate case in which a single requirement appears In-Scope of more than one Epic.

### Merge/Split confirmation rule

When `/create-epics` proposes a structural change to the BUC-default seed (merging two BUCs into one Epic, or splitting one BUC into multiple Epics), the skill SHALL log an `OQ Severity=High` requesting human confirmation. The merged or split Epic is created in `Status = Pending` and carries `merged-from:` or `split-from:` in its Source field. The human reviewer either accepts the proposal (by setting the Epic's Status to Accepted) or rejects it (by re-running the skill after manually restructuring the seed).

Structural decisions are **never silently overridden on re-run**. Once an Epic exists with `Status = Pending` for a given Primary BUC, the skill respects that boundary and only updates the Epic's content fields — not its Primary BUC(s) — unless the human explicitly restructures.

### Epic owner rule

Every Pending Epic MUST have an Owner of the form `SH-xxx`, defaulting to the Accepted By of its Primary BUC. A Pending Epic with no Owner generates `OQ Severity=Critical` and blocks downstream APPROVED. The Owner is the stakeholder accountable for the Epic's outcome and Acceptance.

### Dependency cycle rule

`Depends on` and `Blocks` edges between Epics MUST form a directed acyclic graph. Any cycle generates `OQ Severity=Critical` and blocks downstream APPROVED. The skill never invents dependency edges — it only records dependencies that the Elicitation Document states explicitly (for example, an FR Rationale referencing another BUC's outcome, or a BUC Trigger naming another BUC).

### Re-run immutability rule

Accepted and Rejected Epics are immutable. On re-run, the skill MUST NOT modify any field of an Epic with `Status = Accepted` or `Status = Rejected`. New information that could affect the Epic appears as a review note appended to Section 12 (Revision History): `Note [YYYY-MM-DD]: re-run on /elicit update — human review of this Epic recommended.` The same rule binds the elicit phase and is restated here so re-runs of `/create-epics` do not silently destabilise approved structure.

### OQ namespace continuity rule

The `OQ-###` namespace is shared across the Elicitation Document and every Epic file. New OQs created by `/create-epics` continue numbering from the highest existing OQ-### across both artefacts. OQ IDs are never reused, even after resolution or deletion. The `index.md` aggregator in `artifacts/02-epics/` carries every Open OQ from every Epic file, sorted by Severity (Critical → High → Medium → Low).

### Effort estimate provisional rule

The Effort field on every Pending Epic carries a T-shirt size (S / M / L / XL) derived from a heuristic over In-Scope FR count and the presence of Performance/Security/Regulatory signals. The estimate is **AI-provisional** and MUST carry the note "AI estimate — confirm with team." Sizing is not derivable from the Elicitation Document and is not authoritative; it is a conversation-starter for the delivery team's planning meeting, not a commitment.

### Epic-phase APPROVED integrity

APPROVED at the Epic phase is invalid if any of the following is true:

- Any Open Question with Severity = Critical (raised by `/create-epics`) has Status = Open.
- Any Pending Epic has no Owner.
- Any Accepted FR is orphaned (not In-Scope of any Epic) or duplicated (In-Scope of more than one Epic).
- Any Accepted NFR is orphaned (not In-Scope of any Epic).
- The dependency graph between Pending Epics contains a cycle.

The skill SHALL state every blocker explicitly in the review gate before presenting the APPROVED prompt.

---

## Story-Phase Governance Rules

These rules govern `/create-stories` (Phase 3 of the pipeline). They apply when the skill produces or updates files under `artifacts/03-user-stories/`. As with the Epic phase, all rules below are enforced by the skill itself; this section is the canonical statement so projects, reviewers, and downstream skills can rely on the same contract.

### Upstream gate (incremental)

`/create-stories` SHALL refuse to run when **all** of the following are true:

- The directory `artifacts/02-epics/` exists, AND
- The directory contains at least one `epic-*.md` file, AND
- **No** `epic-*.md` file has frontmatter `status: Accepted`.

The gate is **incremental** — the skill runs as soon as at least one Epic is Accepted, and operates only on the Accepted Epic set. Pending and Rejected Epics are skipped this run; their Stories are minted on a future re-run after the human Accepts the Epic. This lets large projects land Story work for one Epic while other Epics are still being negotiated upstream, and matches the design rationale recorded in [[04-Create-Epics-Iteration-1-Lessons]] §4 — gating on every Epic at once would force unnecessary serialisation.

The skill SHALL also defensively check that the upstream Elicitation Document still has `status: Approved`. An Accepted Epic should not exist if the elicit doc was un-Approved, but the check protects against manual edits between runs.

### FR-to-Story mapping rule

Every Accepted FR linked to an Accepted Epic MUST appear in exactly one Story. The mapping is one-to-one:

- Two Stories sharing the same `parent-fr: FR-###` is a structural defect → `OQ Severity=Critical`.
- An Accepted FR linked to an Accepted Epic without a Story is an orphan → `OQ Severity=Critical`.
- A Pending or Rejected FR generates no Story. A Pending FR linked to an Accepted Epic is listed in the Epic's Candidate Requirements section (per Epic-Phase rules), not in Story form.

### AC inheritance rule

Each Story's Acceptance Criteria SHALL be **lifted verbatim** from the Elicitation Document Section 6 — same AC IDs (`AC-FR-###-NN`), same Given/When/Then text or Criterion field, same acceptance fields (`Status`, `Accepted By`, `Accepted Date`). The Story does **not** mint new ACs and does not re-set existing ACs to `Pending` if they were already Accepted upstream.

ACs and Stories carry **separate** acceptance lifecycles. An AC's Status reflects the elicit doc; the Story's Status reflects whether the human Product Owner has approved this Story for sprint planning. The two are not synchronised by the skill.

A Story whose parent FR has zero ACs in elicit Section 6 is undeliverable → `OQ Severity=Critical: "FR-### has no Acceptance Criteria. Story US-### cannot be implemented without a testable definition of done."`

### Story Owner rule

Every Pending Story MUST have an Owner of the form `SH-###`, defaulting to the parent FR's `Stakeholder` field. A Pending Story with no Owner generates `OQ Severity=Critical` and blocks downstream APPROVED.

### Dependency rule

`Depends on` and `Blocks` edges between Stories SHALL be populated only when the Elicitation Document or the parent Epic states a dependency explicitly:

- Parent FR's `Rationale` references another FR's outcome.
- Parent BUC's `Trigger` names another BUC's Expected Outcome.
- Parent Epic's `Dependencies` section lists an EP-level dependency that propagates to each Story it contains.

The skill SHALL NOT invent dependencies. Cycles between Pending Stories are detected by a topological sort and generate `OQ Severity=Critical`.

### Re-run immutability rule

Accepted and Rejected Stories are immutable. On re-run, the skill MUST NOT modify any field of a Story with `Status = Accepted` or `Status = Rejected`. New information that could affect the Story appears as a review note appended to Section 12 (Revision History): `Note [YYYY-MM-DD]: re-run on /elicit or /create-epics update — human review of this Story recommended.` The same rule applies to Stories whose parent FR has been deleted, renamed, or restructured upstream — the skill never silently destabilises approved Story content.

### OQ namespace continuity rule

The `OQ-###` namespace is shared across the Elicitation Document, every Epic file, and every Story file. New OQs created by `/create-stories` continue numbering from the highest existing OQ-### across all three artefacts. OQ IDs are never reused, even after resolution or deletion. The `index.md` aggregator in `artifacts/03-user-stories/` carries every Open OQ from every Story file, sorted by Severity (Critical → High → Medium → Low).

### Story Points provisional rule

Every Pending Story carries a Fibonacci-band Story Points estimate (1 / 2 / 3 / 5 / 8 / 13) derived from a heuristic over Acceptance Criterion count and the parent Epic's NFR / CON exposure. The estimate is **AI-provisional** and MUST carry the note `**AI estimate — confirm with team.**` Sizing is not derivable from upstream artefacts; it depends on team velocity, technology familiarity, and risk appetite — none of which the framework sees. The estimate is a planning-meeting starting point, not an authoritative commitment.

A Pending Story sized at 13 points triggers `OQ Severity=High` asking the human to consider splitting along ACs that test independent observable outcomes.

### Narrative quality rule

Each Pending Story SHALL carry a non-placeholder Connextra narrative — `As a <role>, I want <action>, so that <outcome>` — composed from the parent FR's `Stakeholder` (role), `Description` (action), and parent BUC's `Expected Outcome` (outcome). When any component cannot be derived cleanly from upstream sources, the skill writes a best-effort phrasing AND generates `OQ Severity=Medium` requesting human refinement. The skill SHALL NOT leave the narrative empty or filled with template placeholder text.

### Story-phase APPROVED integrity

APPROVED at the Story phase is invalid if any of the following is true:

- Any Open Question with Severity = Critical (raised by `/create-stories`) has Status = Open.
- Any Pending Story has no Owner.
- Any Pending Story has zero Acceptance Criteria.
- Any Accepted FR linked to an Accepted Epic is orphaned (no Story) or duplicated (more than one Story).
- The dependency graph between Pending Stories contains a cycle.

The skill SHALL state every blocker explicitly in the review gate before presenting the APPROVED prompt.

---

## SRS-Phase Governance Rules

These rules govern `/create-srs` (Phase 4 of the pipeline). They apply when the skill produces or updates `artifacts/04-srs/srs.md`.

### Upstream gate (strict per Accepted Epic)

`/create-srs` SHALL refuse to run when **any** of the following is true:

- The directory `artifacts/02-epics/` does not exist or contains no `epic-*.md` files.
- No Epic file has frontmatter `status: Accepted`.
- Any Story whose `parent-epic` references an Accepted Epic has `status: Pending` or `status: Rejected`.
- The upstream Elicitation Document does not have `status: Approved` in its frontmatter.

The SRS is a **settled, formal artefact** — including a Pending Story would force re-publish on every Story Acceptance, defeating the purpose. Stories whose parent Epic is itself Pending or Rejected are not in scope; their FRs / ACs / Stakeholders are listed in Section 9 (Traceability Matrix) of the SRS as `Deferred` rather than blocking the gate.

### Partial-by-Epic rule

The SRS covers **exactly the Accepted Epic set** at run time. Stakeholders, BUCs, FRs, NFRs, and ACs whose parent Epic is currently Pending or Rejected MUST appear in the Traceability Matrix as `Deferred` with reason — not in Sections 3–8 (which list only the in-scope content). This lets large projects publish a settled specification for the work that is stable while later Epics are still being negotiated upstream.

### Verbatim lift rule

Sections 3–8 of the SRS (System Features, FRs, NFRs, CONs, External Interfaces, Acceptance Criteria) MUST be **lifted verbatim** from the upstream artefacts. The skill is a curator, not an author, for this content. Drift between the SRS and the elicit doc on lifted content is a structural defect — when `/create-tests` runs and detects such drift, it raises an OQ Severity=High asking the human to reconcile.

### Three skill-generated sections

Sections 1 (Introduction), 2 (Overall Description), and 9 (Traceability Matrix) are **synthesised by the skill from upstream sources**, not lifted verbatim. The skill MUST NOT invent content for these sections — when an Introduction component (e.g., a domain abbreviation in Section 1.3 Glossary) cannot be derived from upstream artefacts, the skill raises `OQ Severity=Medium` rather than fabricating a definition.

### Re-run immutability rule

An SRS with frontmatter `status: Accepted` is immutable. On re-run, the skill MUST NOT modify Sections 1–8. Section 9 (Traceability Matrix) MAY be refreshed, since it is informational and updates as Test Cases land. Section 10 (Revision History) MUST be appended with a review note recording the re-run.

### SRS-phase APPROVED integrity

APPROVED at the SRS phase is invalid if any of the following is true:

- Any Open Question with Severity = Critical raised by `/create-srs` is Open.
- Any Accepted FR / NFR / CON in scope is missing from the corresponding SRS section.
- Any Accepted Story under an Accepted Epic is missing from Section 3 (System Features).
- The Glossary in Section 1.3 omits a domain abbreviation that appears in upstream artefacts more than once.

---

## Test-Phase Governance Rules

These rules govern `/create-tests` (Phase 5 of the pipeline). They apply when the skill produces or updates files under `artifacts/05-test-concept/`.

### Upstream gate (strict on SRS)

`/create-tests` SHALL refuse to run when `artifacts/04-srs/srs.md` does not have frontmatter `status: Accepted`. Tests are derived from a settled spec; running on a Pending SRS forces re-publishing the test set whenever the SRS shifts.

### One-TC-per-AC rule

Every AC in the SRS canonical list (Section 8) MUST appear as exactly one Test Case (`AC-FR-###-NN` → `TC-###`). Two TCs with the same `parent-ac` is a structural defect → `OQ Severity=Critical`. An AC with no TC is an orphan → `OQ Severity=Critical`.

The skill MUST NOT invent additional test scenarios beyond what the AC states. Negative or boundary cases that the team wants must be added upstream as new ACs in `/elicit`, then propagated forward through `/create-srs` and back into `/create-tests`. This is a deliberate design choice: the framework's discipline is that ACs are the source of truth for what gets tested; the test phase mirrors them faithfully rather than adding to them.

### AC drift cross-check rule

The skill MUST cross-check every AC in SRS Section 8 against the same AC in elicit doc Section 6. Disagreements raise `OQ Severity=High` ("AC text differs between SRS and elicit doc"); the SRS is treated as authoritative for TC generation. The cross-check is the framework's first line of defence against silent corruption when an upstream artefact is edited after the SRS has been Approved.

### Verbatim lift rule for ACs

The TC's Preconditions, Steps, and Expected Result sections lift Given / When / Then text verbatim from the parent AC. NFR Measurable Targets are copied verbatim into Expected Result for NFR-derived ACs. The TC adds context (Test Type, Level, Test Data, Test Environment) but does not paraphrase or reword the AC's Then clause.

### Type / Level heuristic rule

Test Type and Level are auto-assigned by a deterministic heuristic — FR ACs → Functional / Acceptance; NFR ACs → Category-driven Type at System level. The heuristic is published in `skills/create-tests/skill.md` Step 5.4 and reproduced in each TC's Section 3. The team MAY override per-TC during sprint planning. Every TC MUST carry the note **"AI assignment — confirm with QA team."**

### TC Owner rule

Every Pending TC MUST have an Owner of the form `SH-###`, defaulting to the parent FR/NFR Stakeholder. A Pending TC with no Owner generates `OQ Severity=Critical` and blocks downstream APPROVED.

### Re-run immutability rule

Accepted TCs are immutable. On re-run, the skill MUST NOT modify Sections 1–12 of an Accepted TC. New information appears as a review note appended to Section 13 (Revision History). The same rule applies to Rejected TCs — the TC-### is permanently retired but the file persists for audit.

### Test-phase APPROVED integrity

APPROVED at the Test phase is invalid if any of the following is true:

- Any Open Question with Severity = Critical raised by `/create-tests` is Open.
- Any Pending TC has no Owner.
- Any Pending TC has empty Preconditions, Steps, or Expected Result.
- Any AC in the SRS canonical list is orphaned (no TC) or duplicated (more than one TC).
- The Test Concept itself is in `status: Pending` (it must be Accepted by the QA lead before the TC set is finalised).

---

## Trace-Phase (read-only auditor — no governance gate)

`/trace` (Phase 6 of the pipeline) is **diagnostic, not generative**. It walks every artefact and produces `artifacts/06-traceability/traceability-matrix.md` reporting orphans, coverage stats, cross-artefact drift, and impact analysis. Because the skill mints no IDs, never modifies upstream artefacts, and produces a snapshot rather than a settled artefact, it has no governance gate and no acceptance lifecycle of its own. The matrix now extends through the TASK column added in Phase 7; orphan rules for Tasks are enforced by `/create-tasks`, not `/trace`.

The matrix's Section 5 (Orphan Reports), Section 6 (Drift Detection), and Section 7 (Impact Analysis) are governance-adjacent — the human reviewer reads them to find structural defects elsewhere in the pipeline. The findings are **reported in the matrix itself**, not raised as new OQ-### entries — the OQ namespace is reserved for skills that generate content. `/trace` lists existing OQs from upstream artefacts but adds no new ones.

The trace artefact does not have an `Accepted` status. Re-runs always overwrite from current upstream state. Manual edits to `artifacts/06-traceability/traceability-matrix.md` are not preserved across runs.

---

## Implementation-Tasks-Phase Governance Rules

These rules govern `/create-tasks` (Phase 7 of the pipeline). They apply when the skill produces or updates files under `artifacts/07-implementation-tasks/`. The skill produces a **handoff artefact** — codebase-agnostic implementation tasks the Dev-Team's AI coding agent consumes. All rules below are enforced by the skill itself; this section is the canonical statement so projects, reviewers, and downstream consumers can rely on the same contract.

### Upstream gate (SRS strict + Story incremental)

`/create-tasks` SHALL refuse to run unless **both** of the following are true:

- `artifacts/04-srs/srs.md` has frontmatter `status: Accepted`, AND
- At least one `artifacts/03-user-stories/story-*.md` has `status: Accepted` whose `parent-epic` references an Accepted Epic.

The skill SHALL also defensively re-check that the upstream Elicitation Document still has `status: Approved`. The SRS gate is strict because Tasks bind to NFR / CON / component context that must be stable; the Story gate is incremental so large projects can deliver handoff artefacts for completed Stories without serialising on the full Story set.

### Story-to-Task mapping rule

Every Accepted Story under an Accepted Epic SHALL produce at least one Task. Multiple Tasks per Story are allowed and expected when ACs decompose naturally; the deterministic decomposition heuristic in `skills/create-tasks/skill.md` §Step 3 produces one base Task per (Story, AC) pair plus NFR-threshold / scaffolding / cross-cutting Tasks as triggered. Two non-cross-cutting Tasks sharing the same `(parent-story, parent-acs)` is a structural defect → `OQ Severity=Medium` ("Story may be over-decomposed; consider merging tasks").

### AC contribution rule

Every AC of every Accepted Story SHALL be referenced by at least one Task's `parent-acs` list. AC orphan (Story Accepted, AC has no contributing Task) → `OQ Severity=High`.

### TC linkage rule

Every Pending Task's `parent-tcs` list SHALL be non-empty and every TC-### in the list SHALL correspond to an existing file in `artifacts/05-test-concept/`. Dangling TC reference → `OQ Severity=High`. Rationale: Tasks describe intent + contract; the contract is verified by Test Cases. A Task without TC linkage cannot be Accepted because its Definition of Done is not falsifiable.

### Definition of Done rule

Every Pending Task's Section 6 SHALL include one `[ ] AC-### verified by TC-### (TC result: pass)` line per parent AC. Missing → `OQ Severity=High`. The team MAY add task-specific DoD items below the `<!-- TEAM-ADDITIONS-BELOW -->` delimiter comment; the skill seeds only the AC/TC items and the standard regression / NFR-threshold lines. The skill SHALL NOT touch the region below the delimiter on re-run.

### Codebase-agnosticism rule (boundary enforcement)

Tasks SHALL NOT reference Dev-Team source-code file paths, class names, function names, framework names not present in the SRS Constraints section, or library versions. The skill validates this in Step 6 (Boundary Audit) by scanning task content against a published denylist and raises `OQ Severity=High` per violation. The skill SHALL NOT auto-rewrite the violation; the human reviewer either edits the Task to remove the leak or accepts the OQ with a justification recorded in the Task's Section 11.

Rationale: the framework has no access to the Dev-Team's repository; the Task is an intent + contract handoff, not an implementation prescription. The Dev-Team's coding agent owns the mapping from intent to codebase. The moment Tasks contain codebase specifics, the framework crosses from RE into development tooling — a boundary the framework's identity rests on.

Suppression rules: matches inside lifted regions (Section 2 Parent Traceability table, Given/When/Then text quoted from upstream ACs, SRS Constraint quotations) are not violations. The denylist applies to **content the skill authored** in Sections 1, 3, 4, 5, 6, 7, 9.

### Cross-cutting Task rule

A Task whose `cross-cutting` frontmatter is `Yes` SHALL list ≥2 parent Stories in Section 2 (one as Parent Story, the rest as Additional Stories). The origin NFR (whose `Business Use Case` field is multi-BUC or `General` / blank per the cross-cutting NFR rule from the Epic phase) MUST appear in every linked Story's parent Epic's `Cross-cutting NFRs` table. Cross-cutting Tasks are minted once and reused across every Story they serve. Violation → `OQ Severity=High`.

### Effort provisional rule

The `effort` field on every Pending Task carries a T-shirt size (S / M / L) derived from a heuristic over AC count, NFR exposure, and cross-cutting scope. The estimate is **AI-provisional** and MUST carry the note `**AI estimate — confirm with team.**` A Story producing ≥7 Tasks triggers `OQ Severity=High` asking the human to consider re-running `/create-stories` after splitting the Story along observable outcomes.

### Re-run immutability rule

Accepted and Rejected Tasks are immutable. On re-run, the skill MUST NOT modify any field of a Task with `Status = Accepted` or `Status = Rejected`. New information that could affect the Task appears as a review note appended to Section 13 (Revision History): `Note [YYYY-MM-DD]: re-run on /create-stories or /create-tests update — human review of this Task recommended.` The same rule applies to Tasks whose parent Story has been Rejected upstream — the skill never silently destabilises Accepted Task content; it raises an OQ instead.

### OQ namespace continuity rule

The `OQ-###` namespace is shared across the Elicitation Document, every Epic file, every Story file, the SRS, every Test Case file, and every Task file. New OQs created by `/create-tasks` continue numbering from the highest existing OQ-### across all six namespaces. OQ IDs are never reused, even after resolution or deletion. The `index.md` aggregator in `artifacts/07-implementation-tasks/` carries every Open OQ from every Task file, sorted by Severity (Critical → High → Medium → Low).

### Implementation-Tasks-phase APPROVED integrity

APPROVED at the Implementation-Tasks phase is invalid if any of the following is true:

- Any Open Question with Severity = Critical raised by `/create-tasks` is Open.
- Any Pending Task has no Owner.
- Any Pending Task has an empty `parent-tcs` list.
- Any Pending Task is missing the `[ ] AC-### verified by TC-### (TC result: pass)` line in Section 6 for any of its parent ACs.
- Any Accepted Story under an Accepted Epic has no Task.
- Any Boundary Audit OQ (Step 6 hit) is Open.

The skill SHALL state every blocker explicitly in the review gate before presenting the APPROVED prompt. The Implementation-Tasks phase is the final RE handoff artefact — APPROVED here signals that the Dev-Team's coding agent may consume `artifacts/07-implementation-tasks/` as its specification.
