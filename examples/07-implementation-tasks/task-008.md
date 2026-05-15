---
artifact: implementation-task
project: PocketPing
task-id: TASK-008
parent-story: US-006
parent-acs: [AC-FR-006-01]
parent-fr: FR-006
parent-nfr: —
parent-epic: EP-002
parent-tcs: [TC-008]
cross-cutting: No
created: 2026-05-15
last-updated: 2026-05-15
status: Pending
owner: SH-003
priority: Must Have
effort: M
reviewed-by: SH-003
approved-date: —
---

# TASK-008: Implement Revoke Contact Access — removing a contact terminates all active sharing immediately

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-006 | **Parent ACs:** AC-FR-006-01 | **Owner:** SH-003
> **Effort:** M (AI provisional) | **Cross-cutting:** No | **Priority:** Must Have

---

## 1. Intent

Deliver the behaviour by which a user can remove a contact from their trusted circle, after which all active sharing sessions between the two parties are terminated immediately and the revoked contact loses access to historical trail data. The revocation surface, the propagation mechanism for the termination signal, and the cleanup of cached state are the Dev-Team's choice; the contract is the immediacy of the termination and the irrevocability for the revoked contact.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-006 | Revoke Contact Access |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-006-01 | Revoke terminates active sharing and removes access |
| Parent FR or NFR | FR-006 | Revoke Contact Access |
| Source BUC | BUC-002 | Build a trusted circle |
| Parent Epic | EP-002 | Manage Trusted Circle |
| Parent TCs | TC-008 | Test that revocation terminates sharing immediately |
| Stakeholder | SH-003 | Privacy-conscious user revoking access |

## 3. Inputs

- The revoking user's identifier and an authenticated session
- The contact to be revoked

## 4. Outputs

- All active sharing sessions between the two parties are terminated immediately
- The revoked contact no longer has access to live location or historical trail data of the revoking user
- The contact is removed from the revoking user's trusted circle

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) — the revocation action requires an authenticated revoking-user session
- Cross-cutting NFR-003 (Data Retention Compliance) — revocation does not bypass retention policy; historical data still ages out per NFR-003
- Bound by CON-002 (GDPR Applicability) — revocation is a privacy-affecting action and must be auditable

## 6. Definition of Done (per-Task)

- [ ] AC-FR-006-01 verified by TC-008 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| — | — | — | — |

## 8. Effort (AI provisional)

- **Effort:** M
- **Heuristic applied:** 1 AC plus immediate-termination propagation across multiple session pairs — bumps from S to M.
- **Rationale:** Revocation must reach every active session synchronously; the propagation surface is more substantial than a single-session terminate.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Verified by TC-008 at Acceptance level.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none) | — | — | — |

## 11. Boundary Audit

- No codebase-specific assumptions detected by /create-tasks Step 6 validation.

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-003
- **Accepted By:** SH-003
- **Accepted Date:** —
- **Source:** parent Story US-006; AC list AC-FR-006-01; TC list TC-008.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-006 / AC-FR-006-01 / TC-008 |
