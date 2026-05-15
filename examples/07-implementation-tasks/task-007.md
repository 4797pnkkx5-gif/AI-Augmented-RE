---
artifact: implementation-task
project: PocketPing
task-id: TASK-007
parent-story: US-005
parent-acs: [AC-FR-005-02]
parent-fr: FR-005
parent-nfr: —
parent-epic: EP-002
parent-tcs: [TC-007]
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

# TASK-007: Implement Accept Invite — accepted invite adds contact to circle and enables sharing

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-005 | **Parent ACs:** AC-FR-005-02 | **Owner:** SH-001
> **Effort:** S (AI provisional) | **Cross-cutting:** No | **Priority:** Must Have

---

## 1. Intent

Deliver the behaviour by which a recipient who follows the invite link can accept the invitation, after which they are added to the inviter's trusted circle and the pair becomes eligible to start sharing sessions per FR-001. The token-validation strategy, the consent surface, and the circle-membership representation are the Dev-Team's choice; the contract is the post-acceptance state in which sharing is enabled.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-005 | Invite Contact to Trusted Circle |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-005-02 | Accepted invite adds contact and enables sharing |
| Parent FR or NFR | FR-005 | Invite Contact to Trusted Circle |
| Source BUC | BUC-002 | Build a trusted circle |
| Parent Epic | EP-002 | Manage Trusted Circle |
| Parent TCs | TC-007 | Test that accepted invite enables sharing |
| Stakeholder | SH-001 | Recipient and inviter |

## 3. Inputs

- The invite token (delivered to the recipient via TASK-006)
- The recipient's accept-or-decline decision

## 4. Outputs

- On accept: the recipient is added to the inviter's trusted circle; both parties are now eligible to initiate sharing per FR-001
- On decline: no circle change; the invite is closed

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) — the acceptance action must establish a session for the recipient if one does not already exist
- Bound by CON-002 (GDPR Applicability) — adding a contact to a circle is a personal-data action and creates retainable membership data

## 6. Definition of Done (per-Task)

- [ ] AC-FR-005-02 verified by TC-007 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-006 | Acceptance is meaningful only for an invite already delivered | parent Story US-005 |

## 8. Effort (AI provisional)

- **Effort:** S
- **Heuristic applied:** 1 AC, no per-Task NFR threshold.
- **Rationale:** Single observable outcome.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Closes the FR-005 invite/accept loop together with TASK-006.
- Verified by TC-007 at Acceptance level.

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
- **Source:** parent Story US-005; AC list AC-FR-005-02; TC list TC-007.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-005 / AC-FR-005-02 / TC-007 |
