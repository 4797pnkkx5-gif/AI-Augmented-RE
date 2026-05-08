---
artifact: user-story
project: PocketPing
us-id: US-005
parent-epic: EP-002
parent-fr: FR-005
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Must Have
story-points: 8
reviewed-by: SH-001
approved-date: —
---

# US-005: Invite Contact to Trusted Circle

> **Calibration example — not a real project.** Produced by `/create-stories` from `examples/02-epics/` (with all three Epics in `Status: Accepted` for the example run) over `examples/01-elicitation/elicitation-document-example.md`. This Story is in `Status = Pending` — the human Product Owner would either Accept it as-is or provide corrections before sprint planning.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent Epic:** EP-002 | **Parent FR:** FR-005 | **Owner:** SH-001
> **Priority:** Must Have | **Story Points (AI estimate):** 8
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

**As a** Product Owner (acting on behalf of the End User),
**I want** to invite a new contact into my trusted circle by phone number or shareable link, with the invitee explicitly accepting before any data is shared,
**so that** I can grow my circle of contacts who may share or view location with me, with documented consent.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | EP-002 | Manage Trusted Circle |
| Parent FR | FR-005 | Invite Contact to Trusted Circle |
| Source Business Use Case | BUC-003 | Manage Trusted Circle |
| Stakeholder | SH-001 | Product Owner |

## 3. Description

A user invites a new contact to their trusted circle via either an SMS to a phone number or a shareable invite link. The invited contact receives the invite, opens it, and explicitly accepts before any location data is shared. Explicit consent is the regulatory and ethical hinge of the whole product (FR-005 Rationale; CON-002 GDPR Articles 6 and 7). The Story has two distinct AC paths because the FR was deliberately split into "send invite" and "accept invite" to comply with the single-outcome AC rule (elicit Section 6 note on FR-005).

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **AC-FR-005-01**
  - **Given:** A registered user is on the "Add Contact" screen
  - **When:** The user enters a phone number and taps "Send Invite"
  - **Then:** The target phone number receives an SMS containing a unique invite link and the inviting user's display name
  - **Status:** Accepted
  - **Accepted By:** SH-001
  - **Accepted Date:** 2026-04-12

- **AC-FR-005-02**
  - **Given:** An invited contact receives the invite link and taps "Accept"
  - **When:** The contact confirms acceptance in the app
  - **Then:** The inviting user's trusted circle is updated to include the new contact, and location sharing between the two users becomes possible
  - **Status:** Accepted
  - **Accepted By:** SH-001
  - **Accepted Date:** 2026-04-12

## 5. Definition of Done

- [ ] All Acceptance Criteria pass in automated tests
- [ ] Code reviewed and approved by at least one peer
- [ ] No regressions in tests for related Stories
- [ ] Documentation (user-facing or API) updated where the Story changes observable behaviour
- [ ] Deployed to a staging environment matching production configuration

## 6. Story Points (AI provisional)

- **Estimate:** 8
- **Heuristic applied:**
  - 1 — 1 AC, no Performance/Security NFR on the parent Epic
  - 2 — 2 ACs, no Performance/Security NFR
  - 3 — 3 ACs, no Performance/Security NFR
  - 5 — 1–3 ACs with Performance/Security NFR; OR 4–5 ACs without
  - 8 — 4+ ACs with Performance/Security NFR; OR Regulatory CON binding this FR
  - 13 — 6+ ACs, OR multi-NFR exposure with Regulatory CON (split flag — see Section 10 OQ)
- **Rationale:** 2 ACs and parent Epic EP-002 carries Security NFR-002, but the FR is also bound by a Regulatory CON: FR-005 Rationale explicitly invokes "regulatory and ethical requirement" for explicit consent, and CON-002 (GDPR) is In-Scope of EP-002 — promotes to 8 per the heuristic.
- **Note:** **AI estimate — confirm with team.** Sizing is not derivable from the Elicitation Document or parent Epic; the delivery team must calibrate before sprint commitment.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| — | — | No explicit dependency stated in the elicit doc or parent Epic. (US-001/US-003 implicitly assume an established trusted circle, but EP-002 explicitly notes the elicit doc does not state this; not invented here.) | — |

## 8. Implementation Notes

- NFR-002 (Security, cross-cutting) applies — both the "send invite" and "accept invite" endpoints MUST authenticate; the invite-link path requires careful handling so that the link itself is unguessable but the acceptance step still binds an authenticated user identity to the new circle membership.
- CON-002 (GDPR) binds: the explicit-acceptance requirement implements GDPR Article 6/7 lawful-basis-via-consent. The consent record (who accepted what, when) must be auditable.
- CON-003 (No Third-Party Analytics in Core Flow) applies — invite events MUST NOT emit phone numbers, contact IDs, or invite-link tokens to any analytics SDK.
- Affects components COMP-001 API Gateway and Location Service per elicit Section 4.0; an SMS gateway integration is implied by AC-FR-005-01 but not explicitly listed in the elicit architecture — flag for the delivery team.

## 9. Out-of-Scope (informational)

- Removing a contact from the trusted circle — see US-006 (FR-006).
- Inviting more than the explicitly defined circle — out of scope per elicit Section 1.3.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against US-005) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-005); parent epic-002.md (EP-002)

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-stories skill (initial run) | Initial Story minted from FR-005 in EP-002 |
