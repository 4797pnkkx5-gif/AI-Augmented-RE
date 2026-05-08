---
artifact: user-story
project: PocketPing
us-id: US-002
parent-epic: EP-001
parent-fr: FR-002
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Must Have
story-points: 5
reviewed-by: SH-001
approved-date: —
---

# US-002: Stop Location Sharing

> **Calibration example — not a real project.** Produced by `/create-stories` from `examples/02-epics/` (with all three Epics in `Status: Accepted` for the example run) over `examples/01-elicitation/elicitation-document-example.md`. This Story is in `Status = Pending` — the human Product Owner would either Accept it as-is or provide corrections before sprint planning.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent Epic:** EP-001 | **Parent FR:** FR-002 | **Owner:** SH-001
> **Priority:** Must Have | **Story Points (AI estimate):** 5
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

**As a** Product Owner (acting on behalf of the End User),
**I want** to stop all of my active location sharing sessions at any time,
**so that** I can revoke sharing instantly and contacts can no longer see where I am.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent FR | FR-002 | Stop Location Sharing |
| Source Business Use Case | BUC-001 | Share Location |
| Stakeholder | SH-001 | Product Owner |

## 3. Description

The user can terminate every active sharing session in one action. Within three seconds of the stop action no further location update reaches any contact, and the user's pin disappears from each contact's map. This is the privacy-control counterweight to US-001: sharing must be revocable as easily as it is granted (FR-002 Rationale and CON-002 GDPR Art 7(3)).

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **AC-FR-002-01**
  - **Given:** A user has an active location sharing session with at least one contact
  - **When:** The user taps "Stop Sharing"
  - **Then:** Within 3 seconds, the contact's app stops receiving location updates and the sharing user's pin is removed from the contact's map view
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

- **Estimate:** 5
- **Heuristic applied:**
  - 1 — 1 AC, no Performance/Security NFR on the parent Epic
  - 2 — 2 ACs, no Performance/Security NFR
  - 3 — 3 ACs, no Performance/Security NFR
  - 5 — 1–3 ACs with Performance/Security NFR; OR 4–5 ACs without
  - 8 — 4+ ACs with Performance/Security NFR; OR Regulatory CON binding this FR
  - 13 — 6+ ACs, OR multi-NFR exposure with Regulatory CON (split flag — see Section 10 OQ)
- **Rationale:** 1 AC and parent Epic EP-001 carries Performance NFR-001 and Security NFR-002 → 5 per the heuristic.
- **Note:** **AI estimate — confirm with team.** Sizing is not derivable from the Elicitation Document or parent Epic; the delivery team must calibrate before sprint commitment.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| — | — | No explicit dependency stated in the elicit doc or parent Epic. | — |

## 8. Implementation Notes

- NFR-002 (Security, cross-cutting) applies — the stop endpoint MUST authenticate and reject unauthenticated requests with HTTP 401.
- NFR-003 (Compliance, retention) applies — terminated sessions still hold historical location records subject to the 30-day auto-delete rule.
- The 3-second propagation requirement (FR-002 Description) is tighter than NFR-001's 5-second p95 — implementations need a server-side push or session-invalidation mechanism rather than relying on the next polling cycle.
- Affects components COMP-001 API Gateway, Location Service, and Location DB (terminate the `sharing_session` row from SEQ-001).
- CON-002 (GDPR Art 7(3)) binds — withdrawal of consent must be as easy as giving it (FR-002 Rationale).

## 9. Out-of-Scope (informational)

- Removing a contact from the trusted circle entirely — see US-006 (FR-006).
- Selective stop of a single session while keeping others active — FR-002 explicitly covers "all active sessions"; finer-grained control is not in scope for v1.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against US-002) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-002); parent epic-001.md (EP-001)

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-stories skill (initial run) | Initial Story minted from FR-002 in EP-001 |
