---
artifact: implementation-task
project: PocketPing
task-id: TASK-013
parent-story: US-001
parent-acs: [AC-NFR-003-01]
parent-fr: —
parent-nfr: NFR-003
parent-epic: EP-001
parent-tcs: [TC-013]
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

# TASK-013: Verify NFR-003 — location records older than 30 days are deleted within 24 h

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-001 | **Parent ACs:** AC-NFR-003-01 | **Owner:** SH-003
> **Effort:** M (AI provisional) | **Cross-cutting:** No | **Priority:** Must Have

---

## 1. Intent

Deliver the data-lifecycle behaviour that enforces the retention policy: any location record older than thirty days is purged within twenty-four hours of crossing that age. The retention-scan cadence, the deletion strategy, and the audit-trail of deletions are the Dev-Team's choice; the contract is the observable absence of records older than the policy window and the timeliness of their removal.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-001 | Start Location Sharing Session (anchor — retention applies to all location records produced under FR-001..FR-004) |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-NFR-003-01 | Records older than 30 days deleted within 24 h |
| Parent FR or NFR | NFR-003 | Data Retention Compliance |
| Source BUC | BUC-001 | Share live location with a trusted contact |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent TCs | TC-013 | System-level compliance test for retention |
| Stakeholder | SH-003 | Privacy / Compliance owner |

## 3. Inputs

- A representative dataset of location records spanning more than thirty days
- The current date relative to those records

## 4. Outputs

- After the retention scan, no records exist that are older than thirty days
- The deletion of any qualifying record completed within twenty-four hours of its crossing the age threshold

## 5. Technical Context

- NFR-003 Measurable Target lifted from SRS §5: records older than 30 days deleted within 24 h
- Cross-cutting NFR-002 (Session Authentication) — retention runs as a system action; the audit surface still respects authentication for human review
- Bound by CON-002 (GDPR Applicability) — retention compliance is a Regulatory constraint

## 6. Definition of Done (per-Task)

- [ ] AC-NFR-003-01 verified by TC-013 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-001 | Retention behaviour is only meaningful for records produced by an active sharing flow | parent BUC-001 |

## 8. Effort (AI provisional)

- **Effort:** M
- **Heuristic applied:** 1 AC with a Compliance NFR threshold — bumps from S to M.
- **Rationale:** Retention enforcement requires a scheduled scan/cleanup surface beyond the per-FR action surfaces.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Bounds the data lifecycle that produces inputs for TASK-005 (24-hour trail) — retention determines what historical data is even available to render.
- Verified by TC-013 at System level.

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
- **Source:** parent Story US-001 (anchor); AC list AC-NFR-003-01; TC list TC-013.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | NFR-threshold Task minted from NFR-003 / AC-NFR-003-01 / TC-013 anchored to US-001 |
