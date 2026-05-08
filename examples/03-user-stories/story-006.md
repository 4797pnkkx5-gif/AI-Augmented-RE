---
artifact: user-story
project: PocketPing
us-id: US-006
parent-epic: EP-002
parent-fr: FR-006
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-003
priority: Must Have
story-points: 8
reviewed-by: SH-003
approved-date: —
---

# US-006: Revoke Contact Access

> **Calibration example — not a real project.** Produced by `/create-stories` from `examples/02-epics/` (with all three Epics in `Status: Accepted` for the example run) over `examples/01-elicitation/elicitation-document-example.md`. This Story is in `Status = Pending` — the human Product Owner would either Accept it as-is or provide corrections before sprint planning.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent Epic:** EP-002 | **Parent FR:** FR-006 | **Owner:** SH-003
> **Priority:** Must Have | **Story Points (AI estimate):** 8
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

**As a** Privacy & Compliance Officer (representing the user's right to withdraw consent),
**I want** to remove any contact from a trusted circle at any time, immediately terminating any active sharing with that contact,
**so that** consent withdrawal is as easy as giving consent — as required by GDPR Article 7(3).

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | EP-002 | Manage Trusted Circle |
| Parent FR | FR-006 | Revoke Contact Access |
| Source Business Use Case | BUC-003 | Manage Trusted Circle |
| Stakeholder | SH-003 | Privacy & Compliance Officer |

## 3. Description

The user removes a contact from the trusted circle and the system tears down every active sharing session with that contact in the same action. After removal the ex-contact's app may no longer display the user's location. This is the strongest privacy lever in PocketPing — it implements GDPR Article 7(3) (FR-006 Rationale).

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **AC-FR-006-01**
  - **Given:** A user has a contact in their trusted circle with an active location sharing session
  - **When:** The user navigates to the contact's profile and taps "Remove from Circle", then confirms
  - **Then:** All active sharing sessions between the user and the removed contact are terminated immediately; the removed contact's app can no longer display the user's location
  - **Status:** Accepted
  - **Accepted By:** SH-003
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
- **Rationale:** 1 AC and parent Epic EP-002 carries Security NFR-002, but the FR is explicitly bound by Regulatory CON-002 (GDPR Article 7(3) named in the FR's own Rationale and the CON In-Scope of EP-002) → 8 per the heuristic.
- **Note:** **AI estimate — confirm with team.** Sizing is not derivable from the Elicitation Document or parent Epic; the delivery team must calibrate before sprint commitment.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| — | — | No explicit dependency stated in the elicit doc or parent Epic. | — |

## 8. Implementation Notes

- NFR-002 (Security, cross-cutting) applies — the revoke endpoint MUST authenticate the actor and prove ownership of the circle.
- CON-002 (GDPR Article 7(3)) directly binds — the AC's "immediately" requirement maps to the regulatory expectation that withdrawal of consent is as frictionless as the original grant. Audit logs SHOULD record the revocation event.
- NFR-003 (Compliance, retention) interacts: revoking access stops new flows but does not back-fill-delete location records that were lawfully shared during the session — those are governed by the 30-day rule in NFR-003. The product/legal team should confirm whether revocation should also force-delete prior trail data shared with the removed contact.
- Affects components COMP-001 API Gateway, Location Service, and Location DB.

## 9. Out-of-Scope (informational)

- Stopping all of one's own sharing sessions without removing contacts — see US-002 (FR-002).
- Preventing future invites from the removed party — not specified in FR-006; flag for product if needed.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against US-006) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-003
- **Accepted By:** SH-003
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-006); parent epic-002.md (EP-002)

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-stories skill (initial run) | Initial Story minted from FR-006 in EP-002 |
