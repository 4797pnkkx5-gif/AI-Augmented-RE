---
artifact: implementation-task
project: PocketPing
task-id: TASK-009
parent-story: US-007
parent-acs: [AC-FR-007-01]
parent-fr: FR-007
parent-nfr: —
parent-epic: EP-003
parent-tcs: [TC-009]
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

# TASK-009: Implement Define a Place — saved Place appears with correct name and 200 m radius

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-007 | **Parent ACs:** AC-FR-007-01 | **Owner:** SH-001
> **Effort:** S (AI provisional) | **Cross-cutting:** No | **Priority:** Should Have

---

## 1. Intent

Deliver the behaviour by which a user can define a named Place — a circular region centred on a chosen location with a 200-metre radius — after which the saved Place appears in the user's list of Places with the chosen name. The Place-naming surface, the location-picker, and the Place-listing presentation are the Dev-Team's choice; the contract is the saved Place's name and radius.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-007 | Define a Place |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-007-01 | Saved Place appears with correct name and 200 m radius |
| Parent FR or NFR | FR-007 | Define a Place |
| Source BUC | BUC-003 | Receive arrival/departure notifications |
| Parent Epic | EP-003 | Place Notifications |
| Parent TCs | TC-009 | Test that defined Place is saved with correct attributes |
| Stakeholder | SH-001 | User defining Places |

## 3. Inputs

- The user's identifier and an authenticated session
- A chosen Place name
- A chosen centre location (latitude, longitude)

## 4. Outputs

- A new Place is persisted, associated with the user, named as chosen, with a 200-metre radius around the chosen centre
- The new Place appears in the user's list of defined Places

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) — defining a Place requires an authenticated user session
- Bound by CON-002 (GDPR Applicability) — Place data is personal data; retention applies per NFR-003

## 6. Definition of Done (per-Task)

- [ ] AC-FR-007-01 verified by TC-009 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Blocks | TASK-010 | A Place must exist before any geofence behaviour can be observed against it | parent Epic EP-003 Dependencies |

## 8. Effort (AI provisional)

- **Effort:** S
- **Heuristic applied:** 1 AC, no per-Task NFR threshold.
- **Rationale:** Single observable outcome.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Verified by TC-009 at Acceptance level.

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
- **Source:** parent Story US-007; AC list AC-FR-007-01; TC list TC-009.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-007 / AC-FR-007-01 / TC-009 |
