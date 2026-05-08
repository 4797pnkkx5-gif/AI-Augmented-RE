---
artifact: test-case
project: PocketPing
tc-id: TC-007
parent-ac: AC-FR-005-02
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

# TC-007: Test Invite Contact to Trusted Circle — accepted invite adds contact and enables sharing

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-FR-005-02 | **Parent FR/NFR:** FR-005 | **Owner:** SH-001
> **Type:** Functional | **Level:** Acceptance | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the inbound half of the consent-by-invite flow: when an invited contact taps "Accept" on the invite link and confirms acceptance in the app, the inviting user's trusted circle must be updated to include the new contact, and from that point on, location sharing between the two users must be possible. This is the moment where GDPR-significant consent is recorded for the relationship.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-FR-005-02 | Accepted invite enables sharing between users |
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

Second of two TCs covering FR-005. Together with TC-006, this completes the Acceptance gate for US-005. Note that the "sharing between the two users becomes possible" assertion is a state-level claim — observation that the trusted circle now includes the contact and that a subsequent FR-001 sharing request to that contact succeeds is the natural verification.

## 5. Test Data

- A pending invite already issued by an "inviter" account to a target phone number (precondition supplied by running TC-006 first or by direct seeding).
- The "invitee" account installed on a separate device, holding the invite link.

## 6. Preconditions

- **Given:** An invited contact receives the invite link and taps "Accept"

## 7. Test Steps

1. The contact confirms acceptance in the app

## 8. Expected Result

- **Then:** The inviting user's trusted circle is updated to include the new contact, and location sharing between the two users becomes possible

## 9. Test Environment

- Any functional test environment: staging or local. Two devices (or two app instances) — one inviter, one invitee.

## 10. Pass / Fail Criteria

- **Pass:** The inviter's trusted circle now lists the invited contact AND the inviter can subsequently start a location sharing session with that contact via the FR-001 flow.
- **Fail:** Trusted circle not updated, contact appears in a non-accepted state, or starting a sharing session with the new contact is not permitted.

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
- **Source:** SRS Section 8 (AC-FR-005-02); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-FR-005-02 |
