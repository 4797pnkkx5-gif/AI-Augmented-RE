---
artifact: implementation-task
project: PocketPing
task-id: TASK-012
parent-story: US-001
parent-acs: [AC-NFR-002-01]
parent-fr: —
parent-nfr: NFR-002
parent-epic: EP-001
parent-tcs: [TC-012]
cross-cutting: Yes
created: 2026-05-15
last-updated: 2026-05-15
status: Pending
owner: SH-002
priority: Must Have
effort: L
reviewed-by: SH-002
approved-date: —
---

# TASK-012: Cross-cutting Session Authentication — every API surface rejects unauthenticated requests

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-001 (primary) — linked to US-002..US-008 | **Parent ACs:** AC-NFR-002-01 | **Owner:** SH-002
> **Effort:** L (AI provisional) | **Cross-cutting:** Yes | **Priority:** Must Have

---

## 1. Intent

Deliver the foundational authentication contract that every user-facing system surface honours: requests presented without a valid authenticated session are rejected. This Task is cross-cutting — every Story in the project (US-001 through US-008) inherits the contract, and every per-Story Task that exposes an action depends on this Task being in place. The session-establishment surface, the credential-validation strategy, and the rejection-response shape are the Dev-Team's choice; the contract is the unconditional rejection of unauthenticated requests on every action-bearing system surface.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-001 | Start Location Sharing Session (primary anchor) |
| Additional Stories (cross-cutting only) | US-002, US-003, US-004, US-005, US-006, US-007, US-008 | Every Story whose action-bearing surface inherits the authentication contract |
| Parent ACs | AC-NFR-002-01 | Every action-bearing surface rejects unauthenticated requests |
| Parent FR or NFR | NFR-002 | Session Authentication |
| Source BUC | BUC-001..BUC-003 | All BUCs are protected behind authenticated sessions |
| Parent Epic | EP-001 | Primary anchor; cross-cutting NFR-002 also applies to EP-002 and EP-003 |
| Parent TCs | TC-012 | System-level security test for unauthenticated rejection |
| Stakeholder | SH-002 | Security / Reliability owner |

## 3. Inputs

- A canonical list of action-bearing system surfaces across every Story
- A negative-case probe (a request with no session, an expired session, or a tampered session)

## 4. Outputs

- Every probed surface returns an explicit rejection signal indicating unauthenticated state
- No action is performed on any surface in response to an unauthenticated request
- The rejection is observable in audit/log output

## 5. Technical Context

- NFR-002 Measurable Target lifted from SRS §5: every action-bearing system surface rejects unauthenticated requests
- The list of in-scope surfaces is derived from every Story's parent FR action set; the cross-cutting Task does not enumerate them itself — it establishes the contract that every surface must honour
- Touches every logical component in SRS §4 that exposes an action surface
- Bound by CON-002 (GDPR Applicability) — authentication scope is a personal-data control

## 6. Definition of Done (per-Task)

- [ ] AC-NFR-002-01 verified by TC-012 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Blocks | TASK-001 | Every per-Story Task that exposes an action depends on the authentication contract being in place | cross-cutting NFR-002 |
| Blocks | TASK-002..TASK-011 | Same reason | cross-cutting NFR-002 |
| Blocks | TASK-013, TASK-014 | Same reason | cross-cutting NFR-002 |

## 8. Effort (AI provisional)

- **Effort:** L
- **Heuristic applied:** Cross-cutting NFR with multi-Story scope → L.
- **Rationale:** Establishing the contract across every action-bearing surface in eight Stories is broader than any single FR Task and must precede them.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- This Task is the foundational dependency for every other action-bearing Task in the set; satisfying it once verifies the contract for all eight Stories.
- Verified by TC-012 at System level. TC-012 carries OQ-011 (High, advisory) flagging that the canonical surface list for the assertion is not yet exhaustive in the SRS — see SRS OQ-009 / OQ-010.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| OQ-011 | The authoritative API surface for AC-NFR-002-01 is not fully captured in SRS — see SRS OQ-009 / OQ-010. The contract is clear in intent but the enumeration of surfaces TC-012 will assert against is incomplete. | High | Open | propagated from /create-tests OQ-011 |

## 11. Boundary Audit

- No codebase-specific assumptions detected by /create-tasks Step 6 validation.

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-002
- **Accepted By:** SH-002
- **Accepted Date:** —
- **Source:** parent Story US-001 (anchor) + Additional Stories US-002..US-008; AC list AC-NFR-002-01; TC list TC-012. Origin NFR-002 is cross-cutting per EP-001/EP-002/EP-003 Cross-cutting NFRs table.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Cross-cutting Task minted from NFR-002 / AC-NFR-002-01 / TC-012, linked to US-001..US-008 |
