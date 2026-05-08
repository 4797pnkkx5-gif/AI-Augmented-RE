---
artifact: test-case
project: PocketPing
tc-id: TC-011
parent-ac: AC-NFR-001-01
parent-fr: —
parent-nfr: NFR-001
parent-epic: EP-001
parent-story: —
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-002
priority: Must Have
type: Performance
level: System
reviewed-by: SH-002
approved-date: —
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# TC-011: Test Location Update Latency — p95 < 5 s under 10 000 concurrent sharing sessions

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-NFR-001-01 | **Parent FR/NFR:** NFR-001 | **Owner:** SH-002
> **Type:** Performance | **Level:** System | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the system-wide latency budget binding the BUC-001 / BUC-002 sharing path: under a sustained load of 10 000 concurrent sharing sessions, the end-to-end time from a sharing user's location update to its appearance on a viewing contact's device must remain below 5 seconds at the 95th percentile. This NFR is the load-time analogue of FR-001 / FR-003's per-flow timing and is the headline performance commitment for the real-time experience.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-NFR-001-01 | p95 location-update latency < 5 s at 10 000 sessions |
| Parent FR or NFR | NFR-001 | Location Update Latency |
| Source BUC | BUC-001, BUC-002 | Share / View Contact Location |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent Story | — | (NFR cross-cutting; no single Story) |
| Stakeholder | SH-002 | Lead Mobile Engineer |

## 3. Type and Level (AI assignment)

- **Type:** Performance
- **Level:** System
- **Sub-type:** Threshold-based
- **Heuristic applied:**
  - NFR AC, Category=Performance → Performance / System
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

This TC validates the Performance NFR threshold. Per Test Concept Section 8 (Exit Criteria), Performance / System TCs at the NFR's stated Measurable Target are required for release sign-off independently of single-flow Acceptance TCs. Recommended load-test framework: k6, JMeter, or Locust (Test Concept Section 6).

## 5. Test Data

- 10 000 simulated concurrent sharing-session users, each producing a steady location-update stream representative of the production traffic profile (the team confirms the per-session update rate during sprint planning; the elicit doc indicates ASMP-003 budgets a 10-second polling cadence).
- Reference target devices for client-side measurement aligned with NFR-004 baseline (iPhone 14, Samsung Galaxy S23) or equivalent simulators.

## 6. Preconditions

- The system is deployed in its baseline (production-equivalent) state in the load-test environment, and is not under any concurrent test load before the run starts.

## 7. Test Steps

1. Ramp up to 10 000 concurrent sharing sessions and sustain that level long enough to gather a statistically significant latency distribution; measure the end-to-end time from each location update generated on a sharing client to the moment that update is rendered on the viewing client.

## 8. Expected Result

- **Then:** End-to-end location update latency must be < 5 seconds at p95 under 10,000 concurrent sharing sessions.

## 9. Test Environment

- Load-test environment matching production configuration: at least one full instance of API Gateway, Location Service, Location DB, and Notification Service per the elicit Section 4 architecture, with capacity sized for 10 000 concurrent sessions plus headroom.

## 10. Pass / Fail Criteria

- **Pass:** Under sustained 10 000 concurrent sharing sessions, the 95th-percentile end-to-end location-update latency is strictly less than 5 seconds.
- **Fail:** p95 latency >= 5 seconds, or the system fails to sustain 10 000 concurrent sessions without errors.

Do not invent thresholds beyond what the parent AC states. The team may add team-specific tolerances during sprint planning.

## 11. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this TC) | — | — | — |

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-002
- **Accepted By:** SH-002
- **Accepted Date:** —
- **Source:** SRS Section 8 (AC-NFR-001-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-NFR-001-01 |
