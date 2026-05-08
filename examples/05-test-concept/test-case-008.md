---
artifact: test-case
project: PocketPing
tc-id: TC-008
parent-ac: AC-FR-006-01
parent-fr: FR-006
parent-nfr: —
parent-epic: EP-002
parent-story: US-006
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-003
priority: Must Have
type: Functional
level: Acceptance
reviewed-by: SH-003
approved-date: —
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# TC-008: Test Revoke Contact Access — removing contact terminates all active sharing immediately

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-006-01 | **Parent FR/NFR:** FR-006 | **Owner:** SH-003
> **Type:** Functional | **Level:** Acceptance | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the contact-level consent-withdrawal primitive that backs CON-002 (GDPR Article 7(3)): when a user removes a contact from their trusted circle, every active sharing session with that removed contact must terminate immediately, and the removed contact's app must no longer be able to display the user's location. This Test Case is part of the Acceptance gate for US-006 and one of the regulator-visible flows for v1.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-006-01 | Removing contact terminates all active sharing immediately |
| Parent FR or NFR | FR-006 | Revoke Contact Access |
| Source BUC | BUC-003 | Manage Trusted Circle |
| Parent Epic | EP-002 | Manage Trusted Circle |
| Parent Story | US-006 | Revoke Contact Access |
| Stakeholder | SH-003 | Privacy & Compliance Officer |

## 3. Type and Level (AI assignment)

- **Type:** Functional
- **Level:** Acceptance
- **Sub-type:** Behavioural (Given/When/Then)
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

Sole TC for FR-006, owned by SH-003 (Privacy & Compliance) — distinct from the FR-002 stop-sharing flow (TC-003) because the consent boundary changes here, not just the session state. This is one of the regulator-visible TCs that the QA lead must execute before every release per Test Concept Section 4 (Compliance / Security TCs are executed in every release regardless of MoSCoW priority).

## 5. Test Data

- A user with at least one trusted-circle contact who currently has an active sharing session with that user.

## 6. Preconditions

- **Given:** A user has a contact in their trusted circle with an active location sharing session

## 7. Test Steps

1. The user navigates to the contact's profile and taps "Remove from Circle", then confirms

## 8. Expected Result

- **Then:** All active sharing sessions between the user and the removed contact are terminated immediately; the removed contact's app can no longer display the user's location

## 9. Test Environment

- Any functional test environment: staging or local. Two devices (or two app instances) — one user, one contact about to be removed.

## 10. Pass / Fail Criteria

- **Pass:** Immediately on confirmation, every active sharing session between the user and the removed contact is terminated AND the removed contact's app can no longer display the user's location (no pin, no further updates, view downgrades to non-sharing state).
- **Fail:** Sessions persist after removal, removed contact continues to see updates, or removal completes silently without terminating sessions.

Do not invent thresholds beyond what the parent AC states. The team may add team-specific tolerances during sprint planning.

## 11. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this TC) | — | — | — |

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-003
- **Accepted By:** SH-003
- **Accepted Date:** —
- **Source:** SRS Section 8 (AC-FR-006-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-006-01 |
