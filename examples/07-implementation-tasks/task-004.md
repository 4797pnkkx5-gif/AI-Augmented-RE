---
artifact: implementation-task
project: PocketPing
task-id: TASK-004
parent-story: US-003
parent-acs: [AC-FR-003-01]
parent-fr: FR-003
parent-nfr: —
parent-epic: EP-001
parent-tcs: [TC-004]
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

# TASK-004: Implement View Contact Live Location — map shows current pin plus last-updated timestamp

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-003 | **Parent ACs:** AC-FR-003-01 | **Owner:** SH-001
> **Effort:** S (AI provisional) | **Cross-cutting:** No | **Priority:** Must Have

---

## 1. Intent

Deliver the contact-side view that renders the current location of every user who is actively sharing with this contact, together with the timestamp of the most recent update. The map surface, the rendering primitives, and the staleness indicators are the Dev-Team's choice; the contract is the simultaneous presence of pin and timestamp.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-003 | View Contact Live Location |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-003-01 | Map shows pin and last-updated timestamp |
| Parent FR or NFR | FR-003 | View Contact Live Location |
| Source BUC | BUC-001 | Share live location with a trusted contact |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent TCs | TC-004 | Test live pin + timestamp |
| Stakeholder | SH-001 | Contact (viewing user) |

## 3. Inputs

- At least one active sharing session in which the viewing user is the contact
- The most recent location reported by each such sharing user, with its timestamp

## 4. Outputs

- A map view that shows a pin for each active sharing user
- For each pin, a clearly displayed timestamp of the most recent location update

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) — viewing requires an authenticated contact session
- Cross-cutting NFR-001 (Location Update Latency) — the viewer must reflect updates within the 5-second budget
- Touches the logical Location Service component per SRS §4

## 6. Definition of Done (per-Task)

- [ ] AC-FR-003-01 verified by TC-004 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-001 | A viewable session must exist for a viewer to see anything | parent BUC-001 Trigger |

## 8. Effort (AI provisional)

- **Effort:** S
- **Heuristic applied:** 1 AC, no per-Task NFR threshold.
- **Rationale:** Single observable outcome.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Verified by TC-004 at Acceptance level.

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
- **Source:** parent Story US-003; AC list AC-FR-003-01; TC list TC-004.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-003 / AC-FR-003-01 / TC-004 |
