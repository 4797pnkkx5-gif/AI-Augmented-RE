---
artifact: user-story
project: PocketPing
us-id: US-007
parent-epic: EP-003
parent-fr: FR-007
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Should Have
story-points: 1
reviewed-by: SH-001
approved-date: —
---

# US-007: Define a Place

> **Calibration example — not a real project.** Produced by `/create-stories` from `examples/02-epics/` (with all three Epics in `Status: Accepted` for the example run) over `examples/01-elicitation/elicitation-document-example.md`. This Story is in `Status = Pending` — the human Product Owner would either Accept it as-is or provide corrections before sprint planning.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent Epic:** EP-003 | **Parent FR:** FR-007 | **Owner:** SH-001
> **Priority:** Should Have | **Story Points (AI estimate):** 1
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

**As a** Product Owner (acting on behalf of the End User),
**I want** to create a named geographic boundary ("Place") by searching for an address or dropping a pin and adjusting a radius (50 m – 5 km),
**so that** the system has a stored boundary it can later use to send arrive/leave notifications.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | EP-003 | Place Notifications |
| Parent FR | FR-007 | Define a Place |
| Source Business Use Case | BUC-004 | Place Notifications |
| Stakeholder | SH-001 | Product Owner |

## 3. Description

The user opens "Add Place", picks a location either by searching an address or dropping a pin, sets a radius between 50 m and 5 km, names the Place, and saves it. Places are the foundation for every geofence notification (FR-007 Rationale): without stored Places, US-008 has nothing to evaluate against.

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **AC-FR-007-01**
  - **Given:** A user is on the "Add Place" screen
  - **When:** The user searches for an address, drops a pin on the result, sets a radius of 200m, enters the name "Home", and taps "Save"
  - **Then:** A Place named "Home" with a 200m radius centred on the selected address is stored in the user's account and appears in their Places list
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
- **Rationale:** 1 AC and parent Epic EP-003 has no In-Scope Performance/Security NFR (no NFR references BUC-004) and no Regulatory CON directly binding this FR → 1 per the heuristic.
- **Note:** **AI estimate — confirm with team.** Sizing is not derivable from the Elicitation Document or parent Epic; the delivery team must calibrate before sprint commitment.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Blocks | US-008 | FR-007 Rationale: "Places are the foundation for geofence notifications (BUC-004)." A geofence notification cannot fire against a Place that does not exist. | elicit FR-007.Rationale |

## 8. Implementation Notes

- CON-001 (Platform Scope) applies — the Place creation UI must work on iOS and Android touch interfaces; no web client is in scope for v1.
- EP-003 has no In-Scope NFR for performance/security/compliance on this Epic specifically (see EP-003 Section 4.2). Cross-cutting NFR-002 still applies as a system-wide rule on any new endpoints introduced by the implementation.
- CON-003 (No Third-Party Analytics) applies — Place names and coordinates MUST NOT be sent to analytics SDKs.

## 9. Out-of-Scope (informational)

- Editing or deleting a Place after creation — not stated as an AC for FR-007; flag for product if required.
- Geofence enter/exit notifications themselves — see US-008 (FR-008).

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against US-007) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-007); parent epic-003.md (EP-003)

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-stories skill (initial run) | Initial Story minted from FR-007 in EP-003 |
