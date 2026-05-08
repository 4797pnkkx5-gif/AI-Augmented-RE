---
artifact: test-case
project: PocketPing
tc-id: TC-010
parent-ac: AC-FR-008-01
parent-fr: FR-008
parent-nfr: —
parent-epic: EP-003
parent-story: US-008
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

# TC-010: Test Geofence Notification — push received within 60 s of boundary crossing

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-008-01 | **Parent FR/NFR:** FR-008 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Should Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the central value-add behaviour of EP-003: when a trusted contact's location crosses a user-defined Place boundary (entering or exiting), the user receives a push notification within 60 seconds containing the contact's display name, the Place name, and whether they arrived or left. This Test Case exercises the cross-component path from the Location Service's geofence evaluation into the Notification Service and onward to APNs / FCM.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-008-01 | Push within 60 s of boundary crossing with name / place / direction |
| Parent FR or NFR | FR-008 | Geofence Notification |
| Source BUC | BUC-004 | Place Notifications |
| Parent Epic | EP-003 | Place Notifications |
| Parent Story | US-008 | Geofence Notification |
| Stakeholder | SH-001 | Product Owner |

## 3. Type and Level (AI assignment)

- **Type:** Functional
- **Level:** Acceptance
- **Sub-type:** Behavioural (Given/When/Then)
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

Sole TC for FR-008. Should-Have priority. The behaviour is also dependent on a working APNs / FCM integration (ASMP-002 — Validated). The 60-second window is the AC's commitment; per-update propagation latency is bounded separately by NFR-001 (TC-011) on the inbound location-update path.

## 5. Test Data

- A user account with a previously defined 300 m-radius Place (precondition supplied by running TC-009 with a 300 m radius, or by direct seeding).
- A trusted-contact account in an active sharing session whose simulated GPS feed crosses the 300 m boundary in either direction.
- Push notifications enabled on the user's device for the PocketPing app.

## 6. Preconditions

- **Given:** A user has defined a Place with a 300m radius, and a trusted contact has an active sharing session

## 7. Test Steps

1. The contact's location crosses the 300m boundary (entering or exiting)

## 8. Expected Result

- **Then:** The user receives a push notification within 60 seconds of the boundary crossing, containing the contact's display name, the Place name, and whether they arrived or left

## 9. Test Environment

- Any functional test environment: staging or local, integrated with the chosen test paths to APNs (iOS) and FCM (Android), and able to inject a GPS feed on the contact device that crosses the configured Place boundary.

## 10. Pass / Fail Criteria

- **Pass:** Push notification arrives on the user's device within 60 seconds of the boundary crossing AND its body contains the contact's display name, the Place name, AND a direction indicator (arrived / left).
- **Fail:** Notification does not arrive, arrives after 60 seconds, or is missing any of the three required content fields (contact name, Place name, direction).

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
- **Source:** SRS Section 8 (AC-FR-008-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-008-01 |
