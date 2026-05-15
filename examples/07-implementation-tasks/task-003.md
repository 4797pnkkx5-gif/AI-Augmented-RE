---
artifact: implementation-task
project: PocketPing
task-id: TASK-003
parent-story: US-002
parent-acs: [AC-FR-002-01]
parent-fr: FR-002
parent-nfr: —
parent-epic: EP-001
parent-tcs: [TC-003]
cross-cutting: No
created: 2026-05-15
last-updated: 2026-05-15
status: Pending
owner: SH-001
priority: Must Have
effort: S
reviewed-by: SH-001
approved-date: —
---

# TASK-003: Implement Stop Location Sharing — contact stops receiving updates and pin disappears within 3 s

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-002 | **Parent ACs:** AC-FR-002-01 | **Owner:** SH-001
> **Effort:** S (AI provisional) | **Cross-cutting:** No | **Priority:** Must Have

---

## 1. Intent

Deliver the behaviour by which the sharing user can terminate an active sharing session. After termination, the contact must stop receiving location updates and the sharing user's pin must be removed from the contact's view within three seconds. The user-side trigger surface, the broadcast mechanism for the termination signal, and the cleanup of cached state are all the Dev-Team's choice; the contract is the freshness budget and the observable disappearance of the pin.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-002 | Stop Location Sharing |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-002-01 | Contact stops receiving updates and pin disappears within 3 s |
| Parent FR or NFR | FR-002 | Stop Location Sharing |
| Source BUC | BUC-001 | Share live location with a trusted contact |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent TCs | TC-003 | Test stop within 3 s and pin removal |
| Stakeholder | SH-001 | Sharing user |

## 3. Inputs

- An active sharing session bound to the sharing user
- The sharing user's intent to terminate that session

## 4. Outputs

- The sharing session is terminated; subsequent location updates from the sharing user are no longer delivered to the contact
- The sharing user's pin is removed from the contact's view within three seconds of termination

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) — the termination action requires an authenticated sharing-user session
- Cross-cutting NFR-003 (Data Retention Compliance) — termination is the start of the retention countdown for the session's location records (verified separately by TASK-013)
- Touches the logical Location Service component per SRS §4

## 6. Definition of Done (per-Task)

- [ ] AC-FR-002-01 verified by TC-003 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-001 | Termination is only meaningful for a session that has been started | parent Story US-002 |

## 8. Effort (AI provisional)

- **Effort:** S
- **Heuristic applied:** 1 AC, no per-Task NFR threshold.
- **Rationale:** Single observable outcome with a tight freshness budget but no per-Task threshold attached directly.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Closes the FR-001/FR-002 lifecycle pair: TASK-001 starts a session, TASK-003 ends it.
- Verified by TC-003 at Acceptance level.

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
- **Source:** parent Story US-002; AC list AC-FR-002-01; TC list TC-003.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-002 / AC-FR-002-01 / TC-003 |
