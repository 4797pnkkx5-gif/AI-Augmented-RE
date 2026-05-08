---
artifact: test-case
project: PocketPing
tc-id: TC-014
parent-ac: AC-NFR-004-01
parent-fr: —
parent-nfr: NFR-004
parent-epic: EP-001
parent-story: —
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-004
priority: Should Have
type: Usability
level: System
reviewed-by: SH-004
approved-date: —
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# TC-014: Test Battery Impact — background polling consumes < 5 % battery per hour while sharing

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-NFR-004-01 | **Parent FR/NFR:** NFR-004 | **Owner:** SH-004
> **Type:** Usability | **Level:** System | **Priority:** Should Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the device-side usability commitment that supports ASMP-003 (users tolerate continuous polling): when the app is actively sharing in the background, location-polling-induced battery drain must remain below 5 % per hour on the two reference devices (iPhone 14 and Samsung Galaxy S23) under standard lab conditions. Excess drain would directly drive uninstalls per the elicit Section 5.5 risk discussion.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-NFR-004-01 | Background polling < 5 % battery / hour on iPhone 14 + Galaxy S23 |
| Parent FR or NFR | NFR-004 | Battery Impact |
| Source BUC | BUC-001 | Share Location |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent Story | — | (NFR; no single Story — battery applies system-wide to BUC-001) |
| Stakeholder | SH-004 | User Research Rep (External) |

## 3. Type and Level (AI assignment)

- **Type:** Usability
- **Level:** System
- **Sub-type:** Threshold-based
- **Heuristic applied:**
  - NFR AC, Category=Usability → Usability / System
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

System-level Usability TC for NFR-004. Should-Have priority — the QA lead should still execute it on every release candidate because battery drain is a primary uninstall driver per elicit Section 5.5 / RSK / ASMP-003. Note that this TC is NOT covered by the Test Concept's "Performance/Security NFRs require System-level TC" coverage target, but the framework's broader "every NFR has at least one TC" target is satisfied.

## 5. Test Data

- Two reference devices in standard lab conditions: an iPhone 14 and a Samsung Galaxy S23, each with a fully charged battery, screen-off, app actively sharing in the background.
- A controlled measurement window of at least one hour per device.

## 6. Preconditions

- The system is in its baseline state with active location sharing running on the test device; both reference devices have been charged to 100 % and screen activity / background app activity matches the lab protocol the team uses for battery measurement.

## 7. Test Steps

1. Run the active sharing scenario with location polling in the background for the lab measurement window on the iPhone 14 and on the Samsung Galaxy S23, recording battery percentage at start and end of the window and computing per-hour drain.

## 8. Expected Result

- **Then:** Background location polling must consume < 5% of device battery per hour when actively sharing, measured on iPhone 14 and Samsung Galaxy S23 under standard lab conditions.

## 9. Test Environment

- Standard lab conditions on iPhone 14 and Samsung Galaxy S23 — temperature, screen brightness, network conditions, and concurrent background apps as defined by the team's battery-test protocol.

## 10. Pass / Fail Criteria

- **Pass:** Per-hour battery drain attributable to background location polling is strictly less than 5 % on BOTH reference devices.
- **Fail:** Per-hour drain is >= 5 % on either device.

Do not invent thresholds beyond what the parent AC states. The team may add team-specific tolerances during sprint planning.

## 11. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this TC) | — | — | — |

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-004
- **Accepted By:** SH-004
- **Accepted Date:** —
- **Source:** SRS Section 8 (AC-NFR-004-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-NFR-004-01 |
