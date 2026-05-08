---
artifact: user-story
project: PocketPing
us-id: US-003
parent-epic: EP-001
parent-fr: FR-003
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Must Have
story-points: 5
reviewed-by: SH-001
approved-date: —
---

# US-003: View Contact Live Location

> **Calibration example — not a real project.** Produced by `/create-stories` from `examples/02-epics/` (with all three Epics in `Status: Accepted` for the example run) over `examples/01-elicitation/elicitation-document-example.md`. This Story is in `Status = Pending` — the human Product Owner would either Accept it as-is or provide corrections before sprint planning.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent Epic:** EP-001 | **Parent FR:** FR-003 | **Owner:** SH-001
> **Priority:** Must Have | **Story Points (AI estimate):** 5
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

**As a** Product Owner (acting on behalf of the End User),
**I want** to see the current GPS position of any trusted contact who is sharing their location, on a map with a last-updated timestamp,
**so that** I can tell where they are and how recent the information is.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent FR | FR-003 | View Contact Live Location |
| Source Business Use Case | BUC-002 | View Contact Location |
| Stakeholder | SH-001 | Product Owner |

## 3. Description

When a contact is actively sharing, the viewing user opens that contact's profile and sees a map with a single pin at the contact's current position plus a "last updated" timestamp. This Story is the recipient half of US-001: sharing has no value unless the recipient can see the location (FR-003 Rationale).

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **AC-FR-003-01**
  - **Given:** A contact has an active sharing session with the viewing user
  - **When:** The viewing user opens the contact's profile in the app
  - **Then:** A map is displayed showing the contact's current location pin and a timestamp indicating when the location was last updated
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
| Depends on | US-001 | FR-003 Rationale: "Complementary to FR-001 — sharing is only useful if the recipient can see the location." Without an active session created by US-001 there is no live position to render. | elicit FR-003.Rationale |

## 8. Implementation Notes

- NFR-001 (Performance) applies — the freshness of the displayed pin is bounded by the < 5 s p95 end-to-end latency target.
- NFR-002 (Security, cross-cutting) applies — read endpoints serving the contact's coordinates MUST authenticate and authorise the viewer (only members of the trusted circle with an active session may read).
- Affects components COMP-001 Mobile App and Location Service per elicit Section 4.0.

## 9. Out-of-Scope (informational)

- Rendering the 24-hour movement trail — see US-004 (FR-004).
- Geofence arrive/leave notifications — see US-008 (FR-008).

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against US-003) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-003); parent epic-001.md (EP-001)

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-stories skill (initial run) | Initial Story minted from FR-003 in EP-001 |
