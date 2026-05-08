---
artifact: test-case
project: PocketPing
tc-id: TC-006
parent-ac: AC-FR-005-01
parent-fr: FR-005
parent-nfr: —
parent-epic: EP-002
parent-story: US-005
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

# TC-006: Test Invite Contact to Trusted Circle — SMS delivered with invite link and inviter's name

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-005-01 | **Parent FR/NFR:** FR-005 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the outbound half of the consent-by-invite flow: entering a phone number on "Add Contact" and tapping "Send Invite" must result in an SMS to the target number that contains a unique invite link and the inviting user's display name. This is the first of two Acceptance gates for FR-005, the GDPR-mandated explicit-consent step that gates every later location-sharing interaction in EP-002.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-005-01 | SMS sent with unique invite link and inviter's name |
| Parent FR or NFR | FR-005 | Invite Contact to Trusted Circle |
| Source BUC | BUC-003 | Manage Trusted Circle |
| Parent Epic | EP-002 | Manage Trusted Circle |
| Parent Story | US-005 | Invite Contact to Trusted Circle |
| Stakeholder | SH-001 | Product Owner |

## 3. Type and Level (AI assignment)

- **Type:** Functional
- **Level:** Acceptance
- **Sub-type:** Behavioural (Given/When/Then)
- **Heuristic applied:**
  - FR AC → Functional / Acceptance
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

First of two TCs covering FR-005 (the second is TC-007 for the acceptance side AC-FR-005-02). Together they form the Acceptance gate for US-005. The SMS delivery channel is an external dependency — the team will need a reliable test number or SMS-receiving fixture in the chosen environment.

## 5. Test Data

- A registered "inviter" account already on the "Add Contact" screen.
- A test phone number that the test environment can observe SMS arrivals on (real test SIM, virtual SMS service, or equivalent fixture).
- The inviter's display name set on their account, so it can be matched in the SMS body.

## 6. Preconditions

- **Given:** A registered user is on the "Add Contact" screen

## 7. Test Steps

1. The user enters a phone number and taps "Send Invite"

## 8. Expected Result

- **Then:** The target phone number receives an SMS containing a unique invite link and the inviting user's display name

## 9. Test Environment

- Any functional test environment: staging or local, integrated with the SMS delivery provider used for invites and a test number whose inbox the test can read.

## 10. Pass / Fail Criteria

- **Pass:** Target number receives an SMS whose body contains a non-reused invite link AND the inviting user's display name as set on the inviter's account.
- **Fail:** No SMS arrives, link is missing or duplicated from a previous invite, or display name is missing or wrong.

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
- **Source:** SRS Section 8 (AC-FR-005-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-005-01 |
