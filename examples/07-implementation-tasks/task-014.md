---
artifact: implementation-task
project: PocketPing
task-id: TASK-014
parent-story: US-001
parent-acs: [AC-NFR-004-01]
parent-fr: —
parent-nfr: NFR-004
parent-epic: EP-001
parent-tcs: [TC-014]
cross-cutting: No
created: 2026-05-15
last-updated: 2026-05-15
status: Pending
owner: SH-004
priority: Should Have
effort: M
reviewed-by: SH-004
approved-date: —
---

# TASK-014: Verify NFR-004 — background polling consumes less than 5 % battery per hour while sharing

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-001 | **Parent ACs:** AC-NFR-004-01 | **Owner:** SH-004
> **Effort:** M (AI provisional) | **Cross-cutting:** No | **Priority:** Should Have

---

## 1. Intent

Deliver the measurement protocol and the supporting power-management strategy that demonstrates the background-polling behaviour during an active sharing session consumes less than five per cent of device battery per hour. The poll-frequency strategy, the motion-aware power management, and the measurement methodology are the Dev-Team's choice; the contract is the measured battery consumption per hour relative to the 5 % threshold.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-001 | Start Location Sharing Session (anchor — background polling is observable only during active sharing) |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-NFR-004-01 | Background polling consumes < 5 %/hr battery while sharing |
| Parent FR or NFR | NFR-004 | Battery Impact |
| Source BUC | BUC-001 | Share live location with a trusted contact |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent TCs | TC-014 | System-level usability test for battery consumption |
| Stakeholder | SH-004 | UX / Mobile platform owner |

## 3. Inputs

- A device in a baseline charge state running an active sharing session
- A measurement window of at least one hour

## 4. Outputs

- A measured battery-consumption rate for the sharing-active state, reported as percentage per hour
- A pass/fail comparison against the 5 % threshold

## 5. Technical Context

- NFR-004 Measurable Target lifted from SRS §5: < 5 %/hr battery while sharing
- Cross-cutting NFR-001 (Location Update Latency) — the 5-second freshness ceiling cannot be relaxed to meet the battery budget; both NFRs are in scope simultaneously
- Touches the logical Location Service component per SRS §4 (the background-polling surface that produces location updates)

## 6. Definition of Done (per-Task)

- [ ] AC-NFR-004-01 verified by TC-014 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-001 | Battery consumption is observable only during an active sharing session | parent BUC-001 |

## 8. Effort (AI provisional)

- **Effort:** M
- **Heuristic applied:** 1 AC with a Usability NFR threshold and a power-management surface — bumps from S to M.
- **Rationale:** Reconciling NFR-001 freshness with NFR-004 battery budget requires tuning beyond a base FR Task.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Bounds the polling-frequency choice that backs TASK-002 (movement-update behaviour) and TASK-001 (initial pin).
- Verified by TC-014 at System level.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none) | — | — | — |

## 11. Boundary Audit

- No codebase-specific assumptions detected by /create-tasks Step 6 validation.

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-004
- **Accepted By:** SH-004
- **Accepted Date:** —
- **Source:** parent Story US-001 (anchor); AC list AC-NFR-004-01; TC list TC-014.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | NFR-threshold Task minted from NFR-004 / AC-NFR-004-01 / TC-014 anchored to US-001 |
