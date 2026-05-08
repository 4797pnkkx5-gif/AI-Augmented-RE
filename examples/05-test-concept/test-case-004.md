---
artifact: test-case
project: PocketPing
tc-id: TC-004
parent-ac: AC-FR-003-01
parent-fr: FR-003
parent-nfr: —
parent-epic: EP-001
parent-story: US-003
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Must Have
type: Functional
level: Acceptance
reviewed-by: SH-001
approved-date: —
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# TC-004: Test View Contact Live Location — map shows current pin and last-updated timestamp

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-003-01 | **Parent FR/NFR:** FR-003 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the recipient half of real-time sharing: when a viewing user opens the profile of a contact who currently has an active sharing session, the app must render a map with the contact's current position pin and a visible last-updated timestamp. Without this TC passing, sharing produces no observable value to the recipient — this is the consumer of FR-001's broadcast.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-003-01 | Map with contact's pin and last-updated timestamp |
| Parent FR or NFR | FR-003 | View Contact Live Location |
| Source BUC | BUC-002 | View Contact Location |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent Story | US-003 | View Contact Live Location |
| Stakeholder | SH-001 | Product Owner |

## 3. Type and Level (AI assignment)

- **Type:** Functional
- **Level:** Acceptance
- **Sub-type:** Behavioural (Given/When/Then)
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

Sole TC for FR-003. Must-Have. The freshness of the displayed timestamp is bounded system-wide by NFR-001 (see TC-011); this Acceptance TC asserts only the presence of the UI elements (pin + timestamp), not the system-level latency distribution.

## 5. Test Data

- A trusted contact (separate user account) currently in an active sharing session with the viewing user.
- The contact's recent GPS position recorded in the system (so a pin coordinate exists to render).

## 6. Preconditions

- **Given:** A contact has an active sharing session with the viewing user

## 7. Test Steps

1. The viewing user opens the contact's profile in the app

## 8. Expected Result

- **Then:** A map is displayed showing the contact's current location pin and a timestamp indicating when the location was last updated

## 9. Test Environment

- Any functional test environment: staging or local.

## 10. Pass / Fail Criteria

- **Pass:** Map view renders with the contact's current location pin AND a visible last-updated timestamp matching the most recent recorded position.
- **Fail:** Map fails to render, pin missing, timestamp missing, or timestamp does not correspond to the latest recorded position.

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
- **Source:** SRS Section 8 (AC-FR-003-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-003-01 |
