---
artifact: implementation-task
project: <!-- PROJECT_NAME -->
task-id: <!-- TASK-### -->
parent-story: <!-- US-### (primary; cross-cutting tasks list extras in Section 2) -->
parent-acs: <!-- [AC-FR-###-NN, ...] -->
parent-fr: <!-- FR-### or — (omit one of parent-fr/parent-nfr depending on parent AC type) -->
parent-nfr: <!-- NFR-### or — -->
parent-epic: <!-- EP-### -->
parent-tcs: <!-- [TC-###, ...] (the Test Cases that verify the ACs this Task contributes to) -->
cross-cutting: <!-- Yes / No -->
created: <!-- CREATION_DATE -->
last-updated: <!-- LAST_UPDATED_DATE -->
status: Pending
owner: <!-- SH-### (inherited from parent Story Owner) -->
priority: <!-- Must Have / Should Have / Could Have / Won't Have (inherited from parent FR/NFR) -->
effort: <!-- S / M / L (AI provisional) -->
reviewed-by: <!-- SH-### -->
approved-date: —
---

# <!-- TASK-### -->: <!-- Task Title -->

> **Status:** Pending | **Created:** <!-- CREATION_DATE --> | **Last Updated:** <!-- LAST_UPDATED_DATE -->
> **Parent Story:** <!-- US-### --> | **Parent ACs:** <!-- AC-FR-###-NN, ... --> | **Owner:** <!-- SH-### -->
> **Effort:** <!-- S / M / L (AI provisional) --> | **Cross-cutting:** <!-- Yes / No --> | **Priority:** <!-- MoSCoW -->
>
> Implementation Tasks are codebase-agnostic handoff artefacts. They describe **intent + contract** — Inputs, Outputs, Definition of Done — that the Dev-Team's coding agent consumes. They never reference source files, class names, framework choices, or library versions. The Dev-Team's agent owns the mapping from intent to codebase.

---

## 1. Intent

<!-- One paragraph describing what behaviour or quality this Task delivers, expressed as intent — never as HOW. Synthesised from the parent Story's Description and the parent AC's Then clause. No code. No file paths. No framework names. No library versions. If the language drifts toward implementation prescription (e.g., "add an endpoint to X" or "create a schema for Y"), rewrite as observable-outcome language (e.g., "deliver behaviour that accepts X and produces Y under condition Z"). -->

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | <!-- US-### --> | <!-- Story title --> |
| Additional Stories (cross-cutting only) | <!-- US-###, US-### or — --> | <!-- Reason for cross-cutting linkage --> |
| Parent ACs | <!-- AC-FR-###-NN, ... --> | <!-- one-line summary per AC --> |
| Parent FR or NFR | <!-- FR-### or NFR-### --> | <!-- title --> |
| Source BUC | <!-- BUC-### --> | <!-- BUC title --> |
| Parent Epic | <!-- EP-### --> | <!-- Epic title --> |
| Parent TCs | <!-- TC-###, ... --> | <!-- one-line summary per TC --> |
| Stakeholder | <!-- SH-### --> | <!-- Role --> |

## 3. Inputs

<!-- Bullet list of data shapes / preconditions the Task consumes. Derived from the Given clauses of the parent ACs. Describe shape in plain language — never in code-level types. Examples:
       - "a user identifier (uniquely identifies the actor)"
       - "the recipient's email and display name as provided by the actor"
     If the parent ACs imply no specific inputs beyond baseline state: write "(none beyond the system's baseline state)". -->

- <!-- input 1 -->
- <!-- input 2 -->

## 4. Outputs

<!-- Bullet list of observable results the Task produces. Derived from the Then clauses of the parent ACs. Express as state changes or visible behaviour, not return values. Examples:
       - "the recipient receives a notification within 5 seconds"
       - "the system records an audit entry attributing the action to the actor"
     If the parent ACs imply no observable outputs beyond a successful invocation: write "(success indication only)". -->

- <!-- output 1 -->
- <!-- output 2 -->

## 5. Technical Context

<!-- Bullets lifted from UPSTREAM artefacts ONLY. Sources permitted:
       - parent Story Section 8 (Implementation Notes)
       - SRS Section 4 (logical component(s) this Task touches)
       - SRS Section 5 (NFRs the parent Epic exposes — Performance, Security, Reliability, etc.)
       - SRS Section 6 (CONs that bind this Task — Regulatory / Technology constraints already recorded)
     The skill NEVER adds new technical assumptions. New constraints belong upstream in /elicit or /create-srs.
     If no upstream context applies: write "(none — this Task is unconstrained beyond the project-wide CONs)". -->

- <!-- e.g., "Cross-cutting NFR-002 (Session Authentication) applies — any actor-facing behaviour SHALL require authenticated session" -->
- <!-- e.g., "Touches logical component COMP-002 (Location Service) per SRS §4" -->
- <!-- e.g., "Bound by CON-002 (GDPR Applicability) — any retention behaviour must satisfy NFR-003" -->

## 6. Definition of Done (per-Task)

<!-- The skill seeds these mandatory items. The team may add task-specific items below the delimiter comment; the skill itself never adds engineering specifics. -->

- [ ] <!-- AC-FR-###-NN verified by TC-### (TC result: pass) -->
- [ ] <!-- Repeat one line per parent AC -->
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

<!-- Populate ONLY when upstream artefacts state a dependency explicitly:
       - parent Story Section 7 (Dependencies) names another Story whose Task this Task depends on
       - a cross-cutting NFR is shared with another Story whose Task must land first (e.g., a foundational Auth Task before per-Story Auth integration)
     Do NOT invent dependencies. Cycles between Pending Tasks generate OQ Severity=Critical. -->

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | <!-- TASK-### --> | <!-- Specific reason from upstream artefact --> | <!-- US-### / EP-### / NFR-### --> |
| Blocks | <!-- TASK-### --> | <!-- ... --> | <!-- ... --> |

## 8. Effort (AI provisional)

- **Effort:** <!-- S / M / L -->
- **Heuristic applied:**
  - S — 1 AC, no Performance/Security/Reliability NFR exposure
  - M — 2–3 ACs OR 1 AC plus a Performance/Security/Reliability NFR threshold
  - L — 4+ ACs OR cross-cutting NFR with multi-Story scope
- **Rationale:** <!-- One sentence: which factor drove the estimate -->
- **Note:** **AI estimate — confirm with team.** Sizing is not derivable from upstream artefacts; the delivery team's coding agent and sprint-planning forum must calibrate before scheduling.

## 9. Coverage Notes

<!-- Which ACs this Task contributes to and which TCs verify it. Cross-references are not duplicated narratively beyond what Section 2's table already shows; this section adds the *contribution* commentary — e.g., "covers the happy-path AC; the negative-path AC for the same FR is covered by TASK-NNN". -->

- <!-- e.g., "Covers AC-FR-001-01 (happy path). The negative-path AC-FR-001-02 is covered by TASK-002." -->
- <!-- e.g., "Verified by TC-003 (Acceptance level); cross-cutting NFR-002 verified at System level by TC-009." -->

## 10. Open Questions

<!-- OQs raised by /create-tasks that affect THIS Task. The shared OQ-### namespace continues from the highest existing OQ-### across the elicit doc, all Epic files, all Story files, the SRS, all Test Case files, and all Task files. IDs are never reused. The index.md aggregates all open OQs across all Tasks. -->

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| <!-- OQ-### --> | <!-- Question text --> | <!-- Critical / High / Medium / Low --> | Open | create-tasks skill |

## 11. Boundary Audit

<!-- The /create-tasks skill scans Sections 1, 3, 4, 5, 6, 7, 9 for codebase-specific content (file extensions, framework names, code fences, class/function name patterns). A clean audit reads: "No codebase-specific assumptions detected by /create-tasks Step 6 validation." If a hit was raised, the OQ-### is recorded here. -->

- <!-- e.g., "No codebase-specific assumptions detected by /create-tasks Step 6 validation." -->

## 12. Acceptance

- **Status:** Pending
- **Owner:** <!-- SH-### -->
- **Accepted By:** <!-- SH-### (default: same as Owner; typically the delivery lead) -->
- **Accepted Date:** —
- **Source:** parent Story <!-- US-### -->; AC list <!-- AC-FR-###-NN, ... -->; TC list <!-- TC-###, ... -->.

## 13. Revision History

<!-- AUTO-APPEND BEHAVIOUR: /create-tasks appends one row to this table every time the Task
     is created or refined. For Pending Tasks this is the running history of what the skill
     has done. For Accepted Tasks this is the only section the skill ever writes to — content
     in Sections 1–12 is immutable; new information that could affect the Task appears here as
     a review note like:
       Note 2026-06-04: re-run on /create-stories update — human review of this Task recommended.
     The same rule applies to Rejected Tasks. -->

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | <!-- CREATION_DATE --> | create-tasks skill (initial run) | Initial Task minted from US-### / AC-### / TC-### |
