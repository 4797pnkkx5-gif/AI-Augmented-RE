---
artifact: user-story
project: PocketPing
us-id: US-008
parent-epic: EP-003
parent-fr: FR-008
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Should Have
story-points: 1
reviewed-by: SH-001
approved-date: —
---

# US-008: Geofence Notification

> **Calibration example — not a real project.** Produced by `/create-stories` from `examples/02-epics/` (with all three Epics in `Status: Accepted` for the example run) over `examples/01-elicitation/elicitation-document-example.md`. This Story is in `Status = Pending` — the human Product Owner would either Accept it as-is or provide corrections before sprint planning.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent Epic:** EP-003 | **Parent FR:** FR-008 | **Owner:** SH-001
> **Priority:** Should Have | **Story Points (AI estimate):** 1
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

**As a** Product Owner (acting on behalf of the End User),
**I want** to receive a push notification within 60 seconds whenever a trusted contact with an active sharing session enters or exits a Place I have defined,
**so that** the system delivers arrive/leave alerts within 60 seconds of the boundary crossing.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | EP-003 | Place Notifications |
| Parent FR | FR-008 | Geofence Notification |
| Source Business Use Case | BUC-004 | Place Notifications |
| Stakeholder | SH-001 | Product Owner |

## 3. Description

When a tracked contact's location crosses a defined Place boundary (in either direction), the system pushes a notification to the user with the contact's display name, the Place name, and whether the contact arrived or left. The 60-second target comes from the FR Description and BUC-004 Expected Outcome.

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **AC-FR-008-01**
  - **Given:** A user has defined a Place with a 300m radius, and a trusted contact has an active sharing session
  - **When:** The contact's location crosses the 300m boundary (entering or exiting)
  - **Then:** The user receives a push notification within 60 seconds of the boundary crossing, containing the contact's display name, the Place name, and whether they arrived or left
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

- **Estimate:** 1
- **Heuristic applied:**
  - 1 — 1 AC, no Performance/Security NFR on the parent Epic
  - 2 — 2 ACs, no Performance/Security NFR
  - 3 — 3 ACs, no Performance/Security NFR
  - 5 — 1–3 ACs with Performance/Security NFR; OR 4–5 ACs without
  - 8 — 4+ ACs with Performance/Security NFR; OR Regulatory CON binding this FR
  - 13 — 6+ ACs, OR multi-NFR exposure with Regulatory CON (split flag — see Section 10 OQ)
- **Rationale:** 1 AC and parent Epic EP-003 has no In-Scope Performance/Security NFR (per EP-003 Section 4.2; OQ-006 already flags the missing success metric upstream) → 1 per the heuristic. Note: real implementation effort here is likely understated — geofence detection is non-trivial — but the heuristic is mechanical; team must calibrate.
- **Note:** **AI estimate — confirm with team.** Sizing is not derivable from the Elicitation Document or parent Epic; the delivery team must calibrate before sprint commitment.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | US-007 | FR-007 Rationale: "Places are the foundation for geofence notifications (BUC-004)." A geofence cannot fire without a stored Place. | elicit FR-007.Rationale |

## 8. Implementation Notes

- The notification flow is documented in SEQ-002 (elicit Section 4): Location Service evaluates geofences on location update, Notification Service resolves watchers and pushes to clients.
- ASMP-002 (push infrastructure stability) is a load-bearing assumption — APNs / FCM API contracts must remain stable; if either provider changes its contract during the delivery window, this Story will be impacted.
- CON-001 (Platform Scope) — push delivery must work on both iOS (APNs) and Android (FCM).
- CON-003 (No Third-Party Analytics) — notification events MUST NOT emit place names or contact IDs to analytics SDKs.
- EP-003 OQ-006 (High, Open) — the geofence feature has no Accepted NFR-style measurable success metric. The 60-second target sits in the FR Description but is not validated by an NFR in the elicit doc. Implementation may need that target promoted to an NFR for proper performance testing.

## 9. Out-of-Scope (informational)

- Defining the Place itself — see US-007 (FR-007).
- Live-pin viewing — see US-003 (FR-003).
- Trail rendering — see US-004 (FR-004).

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against US-008; pre-existing OQ-006 from /create-epics still applies, see Section 8) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-008); parent epic-003.md (EP-003)

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-stories skill (initial run) | Initial Story minted from FR-008 in EP-003 |
