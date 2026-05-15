---
artifact: implementation-task
project: PocketPing
task-id: TASK-001
parent-story: US-001
parent-acs: [AC-FR-001-01]
parent-fr: FR-001
parent-nfr: —
parent-epic: EP-001
parent-tcs: [TC-001]
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

# TASK-001: Implement Start Location Sharing — initial pin appears in contact's view within 5 s

> **Status:** Pending | **Created:** 2026-05-15 | **Last Updated:** 2026-05-15
> **Parent Story:** US-001 | **Parent ACs:** AC-FR-001-01 | **Owner:** SH-001
> **Effort:** S (AI provisional) | **Cross-cutting:** No | **Priority:** Must Have
>
> Implementation Tasks are codebase-agnostic handoff artefacts. They describe intent + contract — Inputs, Outputs, Definition of Done — that the Dev-Team's coding agent consumes. They never reference source files, class names, framework choices, or library versions.

---

## 1. Intent

Deliver the behaviour by which the sharing user initiates a location-sharing session with a specific trusted contact, after which that contact's view shows the sharing user's current pin on a map. The pin must become visible to the contact within five seconds of the sharing user starting the session. The Dev-Team's coding agent owns the mapping from this intent to the concrete location-update channel, push-notification surface, and map-rendering subsystem appropriate to the chosen stack.

## 2. Parent Traceability

| Link | ID(s) | Title / Notes |
|------|-------|--------------|
| Parent Story | US-001 | Start Location Sharing Session |
| Additional Stories (cross-cutting only) | — | — |
| Parent ACs | AC-FR-001-01 | Initial pin visible to contact within 5 s of session start |
| Parent FR or NFR | FR-001 | Start Location Sharing Session |
| Source BUC | BUC-001 | Share live location with a trusted contact |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent TCs | TC-001 | Test that initial pin displays within 5 s |
| Stakeholder | SH-001 | Sharing user (primary actor) |

## 3. Inputs

- The sharing user's identifier (uniquely identifies the actor initiating the session)
- The intended contact's identifier (already a member of the user's trusted circle per FR-005)
- The sharing user's current location at the moment the session is started (latitude, longitude, timestamp)

## 4. Outputs

- A new live-sharing session bound to the (sharing-user, contact) pair, observable by the contact within five seconds
- A pin rendered on the contact's map at the sharing user's reported location
- A session record retained by the system for the duration of the active sharing window

## 5. Technical Context

- Cross-cutting NFR-002 (Session Authentication) applies — the action requires an authenticated sharing-user session
- Cross-cutting NFR-001 (Location Update Latency) applies — the 5-second budget for initial pin appearance is a hard ceiling, not an aspiration
- Touches the logical Location Service component per SRS §4 (the canonical channel for location updates between users)
- Bound by CON-002 (GDPR Applicability) — initiating a sharing session is a personal-data action; the system must respect retention limits established by NFR-003

## 6. Definition of Done (per-Task)

- [ ] AC-FR-001-01 verified by TC-001 (TC result: pass)
- [ ] No regression in tests for related Stories
- [ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target

<!-- TEAM-ADDITIONS-BELOW: items added by the delivery team during sprint planning go here. The skill does not touch this region on re-run. -->

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | TASK-012 | Cross-cutting authentication must be in place before the sharing endpoint can be invoked under NFR-002 | NFR-002 cross-cutting NFR on EP-001 |

## 8. Effort (AI provisional)

- **Effort:** S
- **Heuristic applied:** 1 AC, no direct Performance/Security/Reliability NFR threshold on this Task (the cross-cutting NFR-002 attaches via dependency rather than per-Task threshold). Base Task with a single observable outcome.
- **Rationale:** Single AC, single observable outcome, no per-Task NFR threshold attached directly.
- **Note:** **AI estimate — confirm with team.**

## 9. Coverage Notes

- Covers the happy-path AC for FR-001 (initial pin). The movement-update AC for the same FR (AC-FR-001-02) is covered by TASK-002.
- Verified by TC-001 at Acceptance level. The Performance threshold (NFR-001 p95 < 5 s under 10 000 sessions) is covered by TASK-011.

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
- **Source:** parent Story US-001; AC list AC-FR-001-01; TC list TC-001.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-001 / AC-FR-001-01 / TC-001 |
