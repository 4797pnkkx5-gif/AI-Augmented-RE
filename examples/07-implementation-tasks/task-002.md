---
artifact: implementation-task
project: PocketPing
task-id: TASK-002
parent-story: US-001
parent-acs: [AC-FR-001-02]
parent-fr: FR-001
parent-nfr: —
parent-epic: EP-001
parent-tcs: [TC-002]
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

# TASK-002: Implement Start Location Sharing — pin updates after 50 m movement within 5 s

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-001 | **Parent ACs:** AC-FR-001-02 | **Owner:** SH-001
> **Effort:** S (AI provisional) | **Cross-cutting:** No | **Priority:** Must Have

---

## 1. Intent

Deliver the behaviour by which, during an active sharing session, the contact's pin updates within five seconds whenever the sharing user moves at least fifty metres. The motion-detection trigger and the update channel are the Dev-Team's choice; the contract is the freshness budget and the distance threshold.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-001 | Start Location Sharing Session |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-001-02 | Pin updates within 5 s of 50 m movement |
| Parent FR or NFR | FR-001 | Start Location Sharing Session |
| Source BUC | BUC-001 | Share live location with a trusted contact |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent TCs | TC-002 | Test that pin updates after 50 m movement |
| Stakeholder | SH-001 | Sharing user |

## 3. Inputs

- An active sharing session (already established per TASK-001)
- A movement event of at least 50 m relative to the last reported location

## 4. Outputs

- An updated pin on the contact's map at the sharing user's new location, observable within five seconds of the qualifying movement
- A new location entry in the session's update record

## 5. Technical Context

- Cross-cutting NFR-001 (Location Update Latency) — the 5-second budget is shared with TASK-001 and is the per-update freshness ceiling
- Touches the logical Location Service component per SRS §4
- Bound by NFR-004 (Battery Impact) — the motion-detection mechanism must respect the < 5 %/hr battery budget verified by TASK-014

## 6. Definition of Done (per-Task)

- [ ] AC-FR-001-02 verified by TC-002 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-001 | Continuous-update behaviour activates only after a session is established | parent Story US-001 |

## 8. Effort (AI provisional)

- **Effort:** S
- **Heuristic applied:** 1 AC, no per-Task NFR threshold attached.
- **Rationale:** Single observable outcome with a shared NFR-001 freshness budget already counted under TASK-011.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Pairs with TASK-001 to cover the full FR-001 behaviour (initial pin + continuous updates).
- Verified by TC-002 at Acceptance level.

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
- **Source:** parent Story US-001; AC list AC-FR-001-02; TC list TC-002.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-001 / AC-FR-001-02 / TC-002 |
