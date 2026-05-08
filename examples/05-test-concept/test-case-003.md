---
artifact: test-case
project: PocketPing
tc-id: TC-003
parent-ac: AC-FR-002-01
parent-fr: FR-002
parent-nfr: —
parent-epic: EP-001
parent-story: US-002
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Must Have
type: Functional
level: Acceptance
reviewed-by: SH-001
approved-date: —
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# TC-003: Test Stop Location Sharing — contact stops receiving updates within 3 s and pin is removed

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-002-01 | **Parent FR/NFR:** FR-002 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the privacy-revoke half of the sharing flow: when the sharing user taps "Stop Sharing", every active session terminates within 3 seconds and the contact's view ceases to receive further location updates and removes the sharing user's pin. FR-002 is the user-facing primitive that backs GDPR Article 7(3) (withdrawal of consent must be as easy as giving it) at the per-session level.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-002-01 | Within 3 s, stop terminates contact's view |
| Parent FR or NFR | FR-002 | Stop Location Sharing |
| Source BUC | BUC-001 | Share Location |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent Story | US-002 | Stop Location Sharing |
| Stakeholder | SH-001 | Product Owner |

## 3. Type and Level (AI assignment)

- **Type:** Functional
- **Level:** Acceptance
- **Sub-type:** Behavioural (Given/When/Then)
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

Sole TC for FR-002. Must-Have, so a passing run is a release-blocker per Test Concept Section 8. Note that the equivalent "all sessions terminate" behaviour at consent-withdrawal time (revoking a contact, not stopping a session) is covered by TC-008 (FR-006).

## 5. Test Data

- An active sharing session with at least one contact viewing the sharing user's pin (precondition supplied by TC-001 or by direct seeding).

## 6. Preconditions

- **Given:** A user has an active location sharing session with at least one contact

## 7. Test Steps

1. The user taps "Stop Sharing"

## 8. Expected Result

- **Then:** Within 3 seconds, the contact's app stops receiving location updates and the sharing user's pin is removed from the contact's map view

## 9. Test Environment

- Any functional test environment: staging or local. Two devices (or two app instances) — one sharing, one viewing — to observe both sides of the termination.

## 10. Pass / Fail Criteria

- **Pass:** Within 3 seconds of the stop action, the contact's app stops receiving location updates AND the sharing user's pin disappears from the contact's map view.
- **Fail:** Updates continue to arrive after 3 seconds, the pin remains on the map, or only one of the two outcomes occurs.

Do not invent thresholds beyond what the parent AC states. The team may add team-specific tolerances during sprint planning.

## 11. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this TC) | — | — | — |

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** SRS Section 8 (AC-FR-002-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-002-01 |
