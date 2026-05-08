---
artifact: user-story
project: PocketPing
us-id: US-004
parent-epic: EP-001
parent-fr: FR-004
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Should Have
story-points: 5
reviewed-by: SH-001
approved-date: —
---

# US-004: View 24-Hour Location Trail

> **Calibration example — not a real project.** Produced by `/create-stories` from `examples/02-epics/` (with all three Epics in `Status: Accepted` for the example run) over `examples/01-elicitation/elicitation-document-example.md`. This Story is in `Status = Pending` — the human Product Owner would either Accept it as-is or provide corrections before sprint planning.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent Epic:** EP-001 | **Parent FR:** FR-004 | **Owner:** SH-001
> **Priority:** Should Have | **Story Points (AI estimate):** 5
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

**As a** Product Owner (acting on behalf of the End User),
**I want** to see a 24-hour movement trail for a contact I am viewing, drawn as a polyline on the map,
**so that** I can understand the path the contact took, not just where they are right now.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent FR | FR-004 | View 24-Hour Location Trail |
| Source Business Use Case | BUC-002 | View Contact Location |
| Stakeholder | SH-001 | Product Owner |

## 3. Description

The Story adds historical context to the live pin from US-003 by drawing a polyline through the contact's recorded positions for the previous 24 hours. The Rationale ("did they arrive home?") sets the canonical safety scenario this Story enables.

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **AC-FR-004-01**
  - **Given:** A contact has been sharing their location for at least 1 hour
  - **When:** The viewing user selects the contact and taps "Show Trail"
  - **Then:** A polyline is drawn on the map connecting the contact's recorded positions for the previous 24 hours, from oldest to most recent
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

- NFR-002 (Security, cross-cutting) applies — the trail-fetch endpoint MUST authenticate and authorise (the viewer must be in the contact's trusted circle).
- NFR-003 (Compliance, retention) bounds the trail window: the 30-day auto-delete rule means trails older than 30 days will be physically absent; the AC's "previous 24 hours" window is well within retention.
- Affects components COMP-001 Mobile App, Location Service, Location DB per elicit Section 4.0.

## 9. Out-of-Scope (informational)

- Rendering the contact's current pin (without a trail) — see US-003 (FR-003).
- Trails older than 24 hours — explicitly out per FR-004 Description.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against US-004) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-004); parent epic-001.md (EP-001)

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-stories skill (initial run) | Initial Story minted from FR-004 in EP-001 |
