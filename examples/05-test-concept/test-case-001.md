---
artifact: test-case
project: PocketPing
tc-id: TC-001
parent-ac: AC-FR-001-01
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

# TC-001: Test Start Location Sharing Session — contact's app displays sharing user's pin within 5 s

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-001-01 | **Parent FR/NFR:** FR-001 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies that an authenticated user can initiate a real-time location sharing session by selecting one trusted contact and that the selected contact's device receives and displays the sharing user's GPS pin on the map within the 5-second start-up window mandated by FR-001. This Test Case is part of the Acceptance gate for US-001 and the Must-Have gate for FR-001 — without it the core value proposition of PocketPing (BUC-001) cannot be signed off.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-001-01 | Within 5 s, selected contact sees sharing user's pin |
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

This TC is one of two TCs covering FR-001 (the other is TC-002 for AC-FR-001-02 — movement-driven update). Together they form the Acceptance gate for US-001. Because FR-001 carries Priority = Must Have, a passing run of this TC is a release-blocker per Test Concept Section 8 (Exit Criteria).

## 5. Test Data

- A registered "sharing" user account with at least one accepted trusted-circle contact who has the app installed and is signed in on a separate test device.
- Both devices in a network condition representative of staging (for example, normal LTE / Wi-Fi without artificial throttling).

## 6. Preconditions

- **Given:** A registered user has at least one contact in their trusted circle with the app installed

## 7. Test Steps

1. The user taps "Share My Location" and selects one contact, then confirms

## 8. Expected Result

- **Then:** Within 5 seconds, the selected contact's app displays the sharing user's location pin on the map

## 9. Test Environment

- Any functional test environment: staging or local. NFR-001 (latency p95 < 5 s under 10,000 concurrent sessions) is verified separately by TC-011 in a load-test environment; this Acceptance TC asserts only the single-user flow timing of the FR.

## 10. Pass / Fail Criteria

- **Pass:** Within 5 seconds of the user confirming the share, the selected contact's app displays the sharing user's location pin on the map exactly as stated in the Then clause.
- **Fail:** Pin not displayed, displayed after more than 5 seconds, or displayed at the wrong coordinates.

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
- **Source:** SRS Section 8 (AC-FR-001-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-001-01 |
