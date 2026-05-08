---
artifact: test-case
project: <!-- PROJECT_NAME -->
tc-id: <!-- TC-### -->
parent-ac: <!-- AC-FR-###-NN or AC-NFR-###-NN -->
parent-fr: <!-- FR-### or — (omit one of parent-fr/parent-nfr depending on AC type) -->
parent-nfr: <!-- NFR-### or — -->
parent-epic: <!-- EP-### -->
parent-story: <!-- US-### or — (NFR ACs may not have a Story) -->
created: <!-- CREATION_DATE -->
last-updated: <!-- LAST_UPDATED_DATE -->
status: Pending
owner: <!-- SH-### (inherited from parent FR/NFR Stakeholder) -->
priority: <!-- Must Have / Should Have / Could Have / Won't Have (inherited from parent FR/NFR) -->
type: <!-- Functional / Performance / Security / Usability / Reliability / Scalability / Maintainability / Compliance -->
level: <!-- Acceptance / System / Integration / Unit -->
reviewed-by: <!-- SH-### (typically the QA lead) -->
approved-date: —
---

# <!-- TC-### -->: <!-- Test Title -->

> **Status:** Pending | **Created:** <!-- CREATION_DATE --> | **Last Updated:** <!-- LAST_UPDATED_DATE -->
> **Parent AC:** <!-- AC-FR-###-NN --> | **Parent FR/NFR:** <!-- FR-### or NFR-### --> | **Owner:** <!-- SH-### -->
> **Type:** <!-- Functional / Performance / Security / ... --> | **Level:** <!-- Acceptance / System / ... --> | **Priority:** <!-- MoSCoW -->
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

<!-- One paragraph: what behaviour or quality this Test Case verifies. Synthesised from the parent FR/NFR Description and the AC. Do not duplicate the AC's Given/When/Then text — Sections 6–8 do that. -->

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | <!-- AC-### --> | <!-- AC summary --> |
| Parent FR or NFR | <!-- FR-### or NFR-### --> | <!-- title --> |
| Source BUC | <!-- BUC-### --> | <!-- BUC title --> |
| Parent Epic | <!-- EP-### --> | <!-- Epic title --> |
| Parent Story | <!-- US-### or — --> | <!-- Story title (FR ACs only; NFR ACs may not have a Story) --> |
| Stakeholder | <!-- SH-### --> | <!-- Role --> |

## 3. Type and Level (AI assignment)

- **Type:** <!-- Functional / Performance / Security / Usability / Reliability / Scalability / Maintainability / Compliance -->
- **Level:** <!-- Acceptance / System / Integration / Unit -->
- **Sub-type:** <!-- Behavioural (Given/When/Then) for FR ACs; Threshold-based for Performance/Security/...; Audit for Compliance -->
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
  - NFR AC, Category=Performance → Performance / System
  - NFR AC, Category=Security → Security / System
  - NFR AC, other Category → Category / System
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

<!-- Brief note on what aspect of the parent FR / NFR this TC contributes to.
     For Must-Have FRs, note that this TC is part of the Acceptance gate for the Story.
     For Performance/Security NFRs, note that this TC validates the measurable threshold. -->

## 5. Test Data

<!-- For FR ACs that mention specific data (e.g., "valid email", "100 contacts", "30-day-old record"): list the data inputs the test needs.
     For ACs that don't reference specific data: write "(none required beyond the system's baseline state)". -->

- <!-- e.g., "Test user account: alex@example.test with active sharing session" -->

## 6. Preconditions

<!-- Lift the Given clause of the parent AC verbatim. For NFR ACs (which use a Criterion field instead of Given/When/Then), the precondition is the system in its baseline state — note this explicitly. -->

- **Given:** <!-- preserved from parent AC -->

## 7. Test Steps

<!-- Lift the When clause of the parent AC and break it into numbered steps. One step per discrete action. Do not invent additional steps. For NFR ACs, the steps describe the measurement protocol implied by the Measurable Target. -->

1. <!-- Step 1 -->
2. <!-- Step 2 -->

## 8. Expected Result

<!-- Lift the Then clause of the parent AC verbatim. For NFR ACs, the Expected Result is the Criterion field copied verbatim (which is itself the parent NFR's Measurable Target). -->

- **Then:** <!-- preserved from parent AC -->

## 9. Test Environment

<!-- Driven by parent NFR's Measurable Target where applicable. For FR ACs without environment requirements: write "(any functional test environment: staging or local)". -->

- <!-- e.g., "Load test environment: 500 concurrent virtual users sustained for 5 minutes" -->

## 10. Pass / Fail Criteria

- **Pass:** <!-- For FR ACs: Then clause observed within the timeout the team sets at sprint planning. For NFR ACs: Measurable Target met under the specified conditions. -->
- **Fail:** <!-- anything else -->

Do not invent thresholds beyond what the parent AC states. The team may add team-specific tolerances during sprint planning.

## 11. Open Questions

<!-- OQs raised by /create-tests that affect THIS TC. The shared OQ-### namespace continues from the highest OQ-### across the elicit doc, all Epic files, all Story files, the SRS, and all Test Case files. IDs are never reused. -->

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| <!-- OQ-### --> | <!-- Question text --> | <!-- Critical / High / Medium / Low --> | Open | create-tests skill |

## 12. Acceptance

- **Status:** Pending
- **Owner:** <!-- SH-### -->
- **Accepted By:** <!-- SH-### (default: same as Owner; typically the QA lead) -->
- **Accepted Date:** —
- **Source:** SRS Section 8 (AC-###); cross-checked against elicit Section 6.

## 13. Revision History

<!-- AUTO-APPEND BEHAVIOUR: /create-tests appends one row to this table every time the TC
     is created or refined. For Pending TCs this is the running history of what the skill
     has done. For Accepted TCs this is the only section the skill ever writes to — content
     in Sections 1–12 is immutable; new information that could affect the TC appears here as
     a review note like:
       Note 2026-05-12: re-run on /create-srs update — human review of this TC recommended. -->

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | <!-- CREATION_DATE --> | create-tests skill (initial run) | Initial TC minted from AC-### |
