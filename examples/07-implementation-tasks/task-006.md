---
artifact: implementation-task
project: PocketPing
task-id: TASK-006
parent-story: US-005
parent-acs: [AC-FR-005-01]
parent-fr: FR-005
parent-nfr: —
parent-epic: EP-002
parent-tcs: [TC-006]
cross-cutting: No
created: 2026-05-15
last-updated: 2026-05-15
status: Pending
owner: SH-001
priority: Must Have
effort: M
reviewed-by: SH-001
approved-date: —
---

# TASK-006: Implement Invite Contact — SMS delivered with invite link and inviter's name

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-005 | **Parent ACs:** AC-FR-005-01 | **Owner:** SH-001
> **Effort:** M (AI provisional) | **Cross-cutting:** No | **Priority:** Must Have

---

## 1. Intent

Deliver the behaviour by which the inviter sends an invitation to a chosen contact via SMS, after which the contact receives a message containing an invite link and the inviter's display name. The SMS provider integration, the link-token generation strategy, and the delivery-tracking surface are the Dev-Team's choice; the contract is the presence of the link and the inviter's name in the delivered message.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-005 | Invite Contact to Trusted Circle |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-005-01 | SMS delivered with invite link and inviter's name |
| Parent FR or NFR | FR-005 | Invite Contact to Trusted Circle |
| Source BUC | BUC-002 | Build a trusted circle |
| Parent Epic | EP-002 | Manage Trusted Circle |
| Parent TCs | TC-006 | Test SMS invite delivery |
| Stakeholder | SH-001 | Inviter |

## 3. Inputs

- The inviter's identifier and display name
- The recipient's phone number (provided by the inviter)

## 4. Outputs

- An SMS delivered to the recipient containing an invite link and the inviter's display name

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) — the invite action requires an authenticated inviter session
- Bound by CON-002 (GDPR Applicability) — the recipient's phone number is personal data; handling must respect retention limits

## 6. Definition of Done (per-Task)

- [ ] AC-FR-005-01 verified by TC-006 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| — | — | — | — |

## 8. Effort (AI provisional)

- **Effort:** M
- **Heuristic applied:** 1 AC plus external-channel integration (SMS delivery) implied by the AC text — bumps from S to M.
- **Rationale:** Outbound SMS integration adds a per-Task surface beyond a typical FR-internal behaviour.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Pairs with TASK-007 to cover both halves of FR-005 (invite delivery + invite acceptance).
- Verified by TC-006 at Acceptance level.

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
- **Source:** parent Story US-005; AC list AC-FR-005-01; TC list TC-006.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-005 / AC-FR-005-01 / TC-006 |
