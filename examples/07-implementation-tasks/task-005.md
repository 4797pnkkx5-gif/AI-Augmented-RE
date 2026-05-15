---
artifact: implementation-task
project: PocketPing
task-id: TASK-005
parent-story: US-004
parent-acs: [AC-FR-004-01]
parent-fr: FR-004
parent-nfr: —
parent-epic: EP-001
parent-tcs: [TC-005]
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

# TASK-005: Implement 24-Hour Location Trail — polyline drawn from oldest to most recent point

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-004 | **Parent ACs:** AC-FR-004-01 | **Owner:** SH-001
> **Effort:** S (AI provisional) | **Cross-cutting:** No | **Priority:** Should Have

---

## 1. Intent

Deliver the contact-side view that renders the trailing twenty-four hours of a sharing user's location history as an ordered polyline from oldest to most recent point. The interpolation strategy, the polyline-styling primitives, and the data-aggregation cadence are the Dev-Team's choice; the contract is the time window and the ordering.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-004 | View 24-Hour Location Trail |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-004-01 | Polyline ordered oldest → newest, last 24 h |
| Parent FR or NFR | FR-004 | View 24-Hour Location Trail |
| Source BUC | BUC-001 | Share live location with a trusted contact |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent TCs | TC-005 | Test ordered polyline within 24 h window |
| Stakeholder | SH-001 | Contact (viewing user) |

## 3. Inputs

- Historical location points from a sharing user covering the trailing 24-hour window
- Identification of the contact requesting the trail view

## 4. Outputs

- A polyline rendered on the contact's view connecting every retained location point in chronological order
- The polyline is bounded to the trailing 24-hour window — older points are not displayed

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) — viewing requires an authenticated contact session
- Cross-cutting NFR-003 (Data Retention Compliance) — the 24-hour window must respect the retention policy verified by TASK-013
- Touches the logical Location Service component per SRS §4

## 6. Definition of Done (per-Task)

- [ ] AC-FR-004-01 verified by TC-005 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-001 | Trail rendering requires the location history produced by an active session | parent BUC-001 |

## 8. Effort (AI provisional)

- **Effort:** S
- **Heuristic applied:** 1 AC, no per-Task NFR threshold.
- **Rationale:** Single observable outcome.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Verified by TC-005 at Acceptance level. The retention policy that bounds this Task's data input is verified by TASK-013.

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
- **Source:** parent Story US-004; AC list AC-FR-004-01; TC list TC-005.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-004 / AC-FR-004-01 / TC-005 |
