---
artifact: test-case
project: PocketPing
tc-id: TC-005
parent-ac: AC-FR-004-01
parent-fr: FR-004
parent-nfr: —
parent-epic: EP-001
parent-story: US-004
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Should Have
type: Functional
level: Acceptance
reviewed-by: SH-001
approved-date: —
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# TC-005: Test View 24-Hour Location Trail — polyline drawn from oldest to most recent

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-004-01 | **Parent FR/NFR:** FR-004 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Should Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the trail-rendering behaviour added on top of live location: for a contact who has been sharing for at least 1 hour, "Show Trail" must draw a polyline on the map connecting the contact's recorded positions for the previous 24 hours, ordered oldest-to-newest. This adds the "where did they come from" context that turns FR-003's snapshot into a path useful for safety scenarios.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-004-01 | 24 h polyline drawn oldest to newest |
| Parent FR or NFR | FR-004 | View 24-Hour Location Trail |
| Source BUC | BUC-002 | View Contact Location |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent Story | US-004 | View 24-Hour Location Trail |
| Stakeholder | SH-001 | Product Owner |

## 3. Type and Level (AI assignment)

- **Type:** Functional
- **Level:** Acceptance
- **Sub-type:** Behavioural (Given/When/Then)
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

Sole TC for FR-004. Should-Have priority — failure does not block release per default Test Concept Exit Criteria but Product Owner must document the exception. The 24-hour retention window referenced here is bounded above by NFR-003 (30-day deletion, exercised by TC-013).

## 5. Test Data

- A trusted contact who has been sharing location continuously for at least 1 hour, with a sequence of recorded position points spanning a recognisable path within the last 24 hours.

## 6. Preconditions

- **Given:** A contact has been sharing their location for at least 1 hour

## 7. Test Steps

1. The viewing user selects the contact and taps "Show Trail"

## 8. Expected Result

- **Then:** A polyline is drawn on the map connecting the contact's recorded positions for the previous 24 hours, from oldest to most recent

## 9. Test Environment

- Any functional test environment: staging or local, seeded with at least one contact's location history covering the previous 24 hours.

## 10. Pass / Fail Criteria

- **Pass:** A polyline is rendered on the map connecting the contact's recorded positions over the previous 24 h, in chronological order (oldest first, newest last).
- **Fail:** No polyline drawn, polyline ordering incorrect, polyline truncated to less than the available history, or polyline includes points older than 24 h.

Do not invent thresholds beyond what the parent AC states. The team may add team-specific tolerances during sprint planning.

## 11. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this TC) | — | — | — |

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** SRS Section 8 (AC-FR-004-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-004-01 |
