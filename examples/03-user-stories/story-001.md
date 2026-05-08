---
artifact: user-story
project: PocketPing
us-id: US-001
parent-epic: EP-001
parent-fr: FR-001
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Must Have
story-points: 5
reviewed-by: SH-001
approved-date: —
---

# US-001: Start Location Sharing Session

> **Calibration example — not a real project.** Produced by `/create-stories` from `examples/02-epics/` (with all three Epics in `Status: Accepted` for the example run) over `examples/01-elicitation/elicitation-document-example.md`. This Story is in `Status = Pending` — the human Product Owner would either Accept it as-is or provide corrections before sprint planning.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent Epic:** EP-001 | **Parent FR:** FR-001 | **Owner:** SH-001
> **Priority:** Must Have | **Story Points (AI estimate):** 5
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

**As a** Product Owner (acting on behalf of the End User),
**I want** to initiate a real-time location sharing session by selecting one or more contacts from my trusted circle,
**so that** selected contacts can see where I am on a live map pin that updates automatically.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent FR | FR-001 | Start Location Sharing Session |
| Source Business Use Case | BUC-001 | Share Location |
| Stakeholder | SH-001 | Product Owner |

## 3. Description

The user — already authenticated and with at least one contact in their trusted circle — taps "Share My Location", picks one or more contacts, and confirms. Within five seconds the backend opens a sharing session and begins broadcasting the user's GPS position to those contacts. This is the outbound half of PocketPing's core value proposition: "share with one tap" (Section 1.1). The Story does not cover the recipient view (US-003) or the act of stopping a session (US-002).

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **AC-FR-001-01**
  - **Given:** A registered user has at least one contact in their trusted circle with the app installed
  - **When:** The user taps "Share My Location" and selects one contact, then confirms
  - **Then:** Within 5 seconds, the selected contact's app displays the sharing user's location pin on the map
  - **Status:** Accepted
  - **Accepted By:** SH-001
  - **Accepted Date:** 2026-04-12

- **AC-FR-001-02**
  - **Given:** A registered user has initiated a sharing session with a contact
  - **When:** The sharing user's device moves 50 metres from the last recorded position
  - **Then:** The contact's app updates the location pin to the new position within 5 seconds
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
- **Rationale:** 2 ACs and parent Epic EP-001 carries Performance NFR-001 (latency) and Security NFR-002 (authentication) → 5 per the heuristic.
- **Note:** **AI estimate — confirm with team.** Sizing is not derivable from the Elicitation Document or parent Epic; the delivery team must calibrate before sprint commitment.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Blocks | US-003 | FR-003 Rationale: "Complementary to FR-001 — sharing is only useful if the recipient can see the location." | elicit FR-003.Rationale |

## 8. Implementation Notes

- NFR-001 (Performance) applies — the location update path from this Story's API must satisfy the < 5 s p95 latency target under 10,000 concurrent sessions (elicit Section 5.2).
- NFR-002 (Security, cross-cutting) applies — every endpoint introduced by this Story MUST authenticate; unauthenticated requests MUST return HTTP 401.
- NFR-003 (Compliance, retention) applies — sharing-session location records created by this Story are subject to the 30-day retention rule (auto-delete within 24 hours of threshold).
- NFR-004 (Usability, battery) applies — background location polling on the sharing device must stay below 5% battery per hour on iPhone 14 / Samsung Galaxy S23.
- Affects components COMP-001 API Gateway, Location Service, and Location DB per elicit Section 4.0; the start-of-session and per-update flows are described in SEQ-001 (`POST /sharing/start`, `PUT /location` every 10 s).
- CON-002 (GDPR) binds the consent prerequisite — a sharing session may only target contacts who have already accepted the trusted-circle invite (FR-005).

## 9. Out-of-Scope (informational)

- Stopping a sharing session — see US-002 (FR-002).
- Rendering the contact's pin on the recipient's device — see US-003 (FR-003).
- Multi-recipient broadcast beyond the explicitly invited contacts — see EP-001 Out-of-Scope and elicit Section 1.3.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against US-001) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-001); parent epic-001.md (EP-001)

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-stories skill (initial run) | Initial Story minted from FR-001 in EP-001 |
