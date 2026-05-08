---
artifact: test-case
project: PocketPing
tc-id: TC-009
parent-ac: AC-FR-007-01
parent-fr: FR-007
parent-nfr: —
parent-epic: EP-003
parent-story: US-007
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

# TC-009: Test Define a Place — saved Place appears with correct name and 200 m radius

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-007-01 | **Parent FR/NFR:** FR-007 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Should Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the Place-creation primitive on which the geofence-notification feature (FR-008) depends: searching an address, dropping a pin, setting a 200 m radius, naming the boundary "Home", and saving must result in a stored, named Place that appears in the user's Places list. Without a working FR-007 there is nothing for FR-008 to fire against.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-007-01 | Saved Place appears with correct name and 200 m radius |
| Parent FR or NFR | FR-007 | Define a Place |
| Source BUC | BUC-004 | Place Notifications |
| Parent Epic | EP-003 | Place Notifications |
| Parent Story | US-007 | Define a Place |
| Stakeholder | SH-001 | Product Owner |

## 3. Type and Level (AI assignment)

- **Type:** Functional
- **Level:** Acceptance
- **Sub-type:** Behavioural (Given/When/Then)
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

Sole TC for FR-007. Should-Have priority. The radius range (50 m – 5 km) supported by the FR is exercised here only at the AC's stated 200 m mid-band value; team may add boundary-value sub-tests at 50 m and 5 km during sprint planning if they choose to expand coverage beyond the AC.

## 5. Test Data

- A registered user with map / address-search permissions enabled.
- A real or fixture address that resolves through the address-search backend.
- The label "Home" and a radius value of 200 m as stated in the AC.

## 6. Preconditions

- **Given:** A user is on the "Add Place" screen

## 7. Test Steps

1. The user searches for an address, drops a pin on the result, sets a radius of 200m, enters the name "Home", and taps "Save"

## 8. Expected Result

- **Then:** A Place named "Home" with a 200m radius centred on the selected address is stored in the user's account and appears in their Places list

## 9. Test Environment

- Any functional test environment: staging or local, with the address-search backend reachable.

## 10. Pass / Fail Criteria

- **Pass:** A Place record exists on the user's account named "Home" with a 200 m radius centred on the selected address AND it is visible in the user's Places list in the UI.
- **Fail:** Save operation returns an error, the Place is stored with wrong name / radius / centre, or the Places list does not display the new Place.

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
- **Source:** SRS Section 8 (AC-FR-007-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-007-01 |
