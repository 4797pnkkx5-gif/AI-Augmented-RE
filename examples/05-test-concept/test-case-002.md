---
artifact: test-case
project: PocketPing
tc-id: TC-002
parent-ac: AC-FR-001-02
parent-fr: FR-001
parent-nfr: —
parent-epic: EP-001
parent-story: US-001
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

# TC-002: Test Start Location Sharing Session — pin updates within 5 s after 50 m movement

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-001-02 | **Parent FR/NFR:** FR-001 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies that once a sharing session is active, the contact's app updates the displayed location pin to the sharing user's new position within 5 seconds whenever the sharing user's device moves at least 50 m. This is the "live" half of FR-001's commitment: the session is not just initiated, it stays current. Together with TC-001 (initial pin display), this TC closes out the Acceptance gate for US-001.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-001-02 | Pin updates within 5 s after 50 m movement |
| Parent FR or NFR | FR-001 | Start Location Sharing Session |
| Source BUC | BUC-001 | Share Location |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent Story | US-001 | Start Location Sharing Session |
| Stakeholder | SH-001 | Product Owner |

## 3. Type and Level (AI assignment)

- **Type:** Functional
- **Level:** Acceptance
- **Sub-type:** Behavioural (Given/When/Then)
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

Second of two TCs covering FR-001. The 5-second update window stated here is a per-update FR commitment under normal conditions; the system-level latency target (p95 < 5 s under 10,000 concurrent sessions, NFR-001) is exercised separately by TC-011.

## 5. Test Data

- A sharing session already active between a sharing user and at least one viewing contact (precondition supplied by running TC-001 first or by direct database seeding).
- A reproducible 50-metre geographic displacement on the sharing device (real or simulated GPS feed).

## 6. Preconditions

- **Given:** A registered user has initiated a sharing session with a contact

## 7. Test Steps

1. The sharing user's device moves 50 metres from the last recorded position

## 8. Expected Result

- **Then:** The contact's app updates the location pin to the new position within 5 seconds

## 9. Test Environment

- Any functional test environment: staging or local, with a way to inject GPS positions on the sharing device (developer GPX feed on iOS, mock-location provider on Android, or equivalent).

## 10. Pass / Fail Criteria

- **Pass:** Within 5 seconds of the 50 m displacement, the contact's app shows the pin at the new position.
- **Fail:** Pin not updated, updated after more than 5 seconds, or updated to a position that does not reflect the new device location.

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
- **Source:** SRS Section 8 (AC-FR-001-02); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-001-02 |
