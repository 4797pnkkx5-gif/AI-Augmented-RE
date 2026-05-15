---
artifact: implementation-task
project: PocketPing
task-id: TASK-010
parent-story: US-008
parent-acs: [AC-FR-008-01]
parent-fr: FR-008
parent-nfr: —
parent-epic: EP-003
parent-tcs: [TC-010]
cross-cutting: No
created: 2026-05-15
last-updated: 2026-05-15
status: Pending
owner: SH-001
priority: Should Have
effort: S
reviewed-by: SH-001
approved-date: —
---

# TASK-010: Implement Geofence Notification — push received within 60 s of boundary crossing

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-008 | **Parent ACs:** AC-FR-008-01 | **Owner:** SH-001
> **Effort:** S (AI provisional) | **Cross-cutting:** No | **Priority:** Should Have

---

## 1. Intent

Deliver the behaviour by which, when a sharing user crosses the boundary of any of their contact's defined Places (enters or leaves the 200-metre radius), the contact receives a push notification within sixty seconds describing the crossing event. The boundary-crossing detection cadence, the push surface, and the notification content layout are the Dev-Team's choice; the contract is the freshness budget and the directional content of the notification.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-008 | Geofence Notification |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-008-01 | Push received within 60 s of boundary crossing |
| Parent FR or NFR | FR-008 | Geofence Notification |
| Source BUC | BUC-003 | Receive arrival/departure notifications |
| Parent Epic | EP-003 | Place Notifications |
| Parent TCs | TC-010 | Test push within 60 s of crossing |
| Stakeholder | SH-001 | Contact receiving notifications |

## 3. Inputs

- An active sharing session between the sharing user and the receiving contact
- At least one Place defined by the receiving contact
- A boundary-crossing event by the sharing user with respect to one of those Places

## 4. Outputs

- A push notification delivered to the receiving contact within sixty seconds of the boundary-crossing event
- The notification content identifies the sharing user, the Place name, and the direction of crossing (enter or leave)

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) — notification delivery to the contact's device requires an authenticated contact session
- Cross-cutting NFR-001 (Location Update Latency) — boundary-crossing detection is downstream of location updates; the 5-second update budget is upstream of this Task's 60-second push budget
- Touches the logical Notification Service component per SRS §4

## 6. Definition of Done (per-Task)

- [ ] AC-FR-008-01 verified by TC-010 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-009 | A Place must exist before any geofence behaviour can be observed | parent Epic EP-003 Dependencies |
| Depends on | TASK-001 | Boundary detection requires an active sharing session producing location updates | parent BUC-003 Trigger |

## 8. Effort (AI provisional)

- **Effort:** S
- **Heuristic applied:** 1 AC, no per-Task NFR threshold.
- **Rationale:** Single observable outcome; dependencies are upstream Tasks rather than per-Task NFR work.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Verified by TC-010 at Acceptance level.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none) | — | — | — |

## 11. Boundary Audit

- No codebase-specific assumptions detected by /create-tasks Step 6 validation.

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** parent Story US-008; AC list AC-FR-008-01; TC list TC-010.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-008 / AC-FR-008-01 / TC-010 |
