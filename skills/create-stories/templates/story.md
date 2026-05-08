---
artifact: user-story
project: <!-- PROJECT_NAME -->
us-id: <!-- US-### -->
parent-epic: <!-- EP-### -->
parent-fr: <!-- FR-### -->
created: <!-- CREATION_DATE -->
last-updated: <!-- LAST_UPDATED_DATE -->
status: Pending
owner: <!-- SH-### -->
priority: <!-- Must Have / Should Have / Could Have / Won't Have -->
story-points: <!-- 1 / 2 / 3 / 5 / 8 / 13 (AI estimate) -->
reviewed-by: <!-- SH-### -->
approved-date: —
---

# <!-- US-### -->: <!-- Story Title (verbatim from parent FR) -->

> **Status:** Pending | **Created:** <!-- CREATION_DATE --> | **Last Updated:** <!-- LAST_UPDATED_DATE -->
> **Parent Epic:** <!-- EP-### --> | **Parent FR:** <!-- FR-### --> | **Owner:** <!-- SH-### -->
> **Priority:** <!-- MoSCoW --> | **Story Points (AI estimate):** <!-- 1/2/3/5/8/13 -->
>
> User Stories decompose Accepted Epics into sprint-sized units of work. Each Story corresponds to exactly one Accepted Functional Requirement and inherits its Acceptance Criteria verbatim from the Elicitation Document.

---

## 1. Narrative

<!-- Connextra format: "As a <role>, I want <action>, so that <outcome>"
     - <role>: parent FR's Stakeholder, expressed as the SH-###'s Role field
     - <action>: parent FR's Description, stripped to its core verb-object phrase (drop "The system SHALL..." prefix and rephrase as a first-person user goal)
     - <outcome>: parent BUC's Expected Outcome, expressed as a user-facing benefit
     If any component is unclear: write best-effort phrasing AND log OQ Severity=Medium in Section 10. Do not pad with placeholder text. -->

**As a** <!-- SH-###'s Role -->,
**I want** <!-- core verb-object phrase from FR Description -->,
**so that** <!-- BUC Expected Outcome as user-facing benefit -->.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent Epic | <!-- EP-### --> | <!-- Epic Title --> |
| Parent FR | <!-- FR-### --> | <!-- FR Title (verbatim) --> |
| Source Business Use Case | <!-- BUC-### --> | <!-- BUC Title --> |
| Stakeholder | <!-- SH-### --> | <!-- Stakeholder Role --> |

## 3. Description

<!-- One paragraph in business terms: what behaviour this Story delivers from the user's point of view. Synthesised from the parent FR's Description and Rationale. Do not duplicate AC-level detail. -->

## 4. Acceptance Criteria

> Lifted **verbatim** from `artifacts/01-elicitation/elicitation-document.md` Section 6.
> AC IDs and acceptance fields (Status, Accepted By, Accepted Date) belong to the Elicitation Document — they are inherited here for traceability and must not be re-set to `Pending` if the upstream AC has already been Accepted.

- **<!-- AC-FR-###-01 -->**
  - **Given:** <!-- preserved from elicit doc -->
  - **When:** <!-- preserved from elicit doc -->
  - **Then:** <!-- preserved from elicit doc -->
  - **Status:** <!-- inherited from elicit doc -->
  - **Accepted By:** <!-- inherited -->
  - **Accepted Date:** <!-- inherited -->

<!-- Repeat for AC-FR-###-02, -03, ... as present in elicit doc Section 6 -->

## 5. Definition of Done

- [ ] All Acceptance Criteria pass in automated tests
- [ ] Code reviewed and approved by at least one peer
- [ ] No regressions in tests for related Stories
- [ ] Documentation (user-facing or API) updated where the Story changes observable behaviour
- [ ] Deployed to a staging environment matching production configuration

<!-- The team may add or remove items per their delivery context. The skill seeds a sane default — it is not authoritative on team practice. Items added by the team should be added below this comment. -->

## 6. Story Points (AI provisional)

- **Estimate:** <!-- 1 / 2 / 3 / 5 / 8 / 13 -->
- **Heuristic applied:**
  - 1 — 1 AC, no Performance/Security NFR on the parent Epic
  - 2 — 2 ACs, no Performance/Security NFR
  - 3 — 3 ACs, no Performance/Security NFR
  - 5 — 1–3 ACs with Performance/Security NFR; OR 4–5 ACs without
  - 8 — 4+ ACs with Performance/Security NFR; OR Regulatory CON binding this FR
  - 13 — 6+ ACs, OR multi-NFR exposure with Regulatory CON (split flag — see Section 10 OQ)
- **Rationale:** <!-- One sentence: which factor drove the estimate -->
- **Note:** **AI estimate — confirm with team.** Sizing is not derivable from the Elicitation Document or parent Epic; the delivery team must calibrate before sprint commitment.

## 7. Dependencies

<!-- Populate ONLY when the elicit doc or parent Epic explicitly states a dependency:
     - parent FR's Rationale references another FR's outcome
     - parent BUC's Trigger names another BUC's Expected Outcome
     - parent Epic's Dependencies section lists an EP-level dependency
     Do NOT invent dependencies. Cycles between Pending Stories generate OQ Severity=Critical. -->

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | <!-- US-### --> | <!-- Specific reason from elicit / epic --> | <!-- elicit element ID or EP-### --> |
| Blocks | <!-- US-### --> | <!-- ... --> | <!-- ... --> |

## 8. Implementation Notes

<!-- Capture only NON-TRIVIAL technical context derivable from upstream artefacts:
     - Cross-cutting NFRs from the parent Epic that constrain this Story
     - Component diagram references (elicit doc Section 4.0) when the Story affects a specific component
     - Regulatory CONs that bind the implementation
     If no constraints are derivable: write "(none — this Story is unconstrained beyond the project-wide CONs)".
     Do not pad with generic engineering advice. -->

- <!-- e.g., "NFR-002 Session Authentication applies — endpoints touched by this Story MUST return HTTP 401 for unauthenticated requests" -->
- <!-- e.g., "Affects component COMP-002 (Location Service) per elicit Section 4.0" -->
- <!-- e.g., "CON-002 (GDPR Applicability) binds: any retention behaviour must satisfy NFR-003" -->

## 9. Out-of-Scope (informational)

<!-- Items the human reviewer might assume are part of this Story but are not.
     Do not duplicate the parent Epic's Out-of-Scope here unless directly relevant. -->

- <!-- e.g., "Multi-recipient broadcast — see EP-001 Out-of-Scope" -->

## 10. Open Questions

<!-- OQs raised by /create-stories that affect THIS Story. The shared OQ-### namespace continues from the highest OQ-### across the elicit doc and all Epic and Story files — IDs are never reused. The index.md aggregates all open OQs across all Stories. -->

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| <!-- OQ-### --> | <!-- Question text --> | <!-- Critical / High / Medium / Low --> | Open | create-stories skill |

## 11. Acceptance

- **Status:** Pending
- **Owner:** <!-- SH-### -->
- **Accepted By:** <!-- SH-### (default: same as Owner) -->
- **Accepted Date:** —
- **Source:** elicitation-document.md (FR-###); parent epic-NNN.md (EP-###)

## 12. Revision History

<!-- AUTO-APPEND BEHAVIOUR: /create-stories appends one row to this table every time the Story
     is created or refined. For Pending Stories this is the running history of what the skill
     has done. For Accepted Stories this is the only section the skill ever writes to — content
     in Sections 1–11 is immutable; new information that could affect the Story appears here as
     a review note like:
       Note 2026-05-10: re-run on /create-epics update — human review of this Story recommended.
     The same rule applies to Rejected Stories. -->

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | <!-- CREATION_DATE --> | create-stories skill (initial run) | Initial Story minted from FR-### in EP-### |
