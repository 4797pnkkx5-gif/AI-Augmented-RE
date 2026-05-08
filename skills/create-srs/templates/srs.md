---
artifact: software-requirements-specification
project: <!-- PROJECT_NAME -->
version: 1.0
created: <!-- CREATION_DATE -->
last-updated: <!-- LAST_UPDATED_DATE -->
status: Pending
reviewed-by: <!-- SH-### (typically the project lead or product owner) -->
approved-date: —
based-on:
  elicitation: <!-- elicit doc version + approved date -->
  accepted-epics: <!-- list of EP-### in scope -->
  accepted-stories: <!-- count of Stories in scope -->
---

# Software Requirements Specification — <!-- PROJECT_NAME -->

> **Status:** Pending | **Version:** 1.0 | **Created:** <!-- CREATION_DATE --> | **Last Updated:** <!-- LAST_UPDATED_DATE -->
>
> Compiled by `/create-srs` from the Approved Elicitation Document, the Accepted Epic set, and every Accepted Story under those Epics. Lifts FRs, NFRs, CONs, ACs, and Stories verbatim from upstream — Sections 1, 2, and 9 are skill-generated. The SRS is **partial-by-Epic**: it covers exactly the Accepted Epic set; Stakeholders, BUCs, FRs and ACs whose parent Epic is Pending or Rejected are listed as `Deferred` in Section 9 rather than absent.
>
> Modelled on IEEE 29148:2018 *Systems and software engineering — Life cycle processes — Requirements engineering*.

---

## 1. Introduction

### 1.1 Purpose

<!-- One paragraph synthesised from elicit Section 1.1 (Background) and 1.2 (Problem Statement). State who this SRS is for and what it documents. -->

### 1.2 Scope

**In scope:** <!-- lifted from elicit Section 1.3 -->
**Out of scope:** <!-- lifted from elicit Section 1.3 -->

This SRS covers the following Accepted Epics: <!-- EP-001, EP-002, ... -->. Stakeholders, BUCs, and Functional Requirements whose parent Epic is currently Pending or Rejected are listed in Section 9 as `Deferred` and will be added to a future revision after Epic acceptance.

### 1.3 Definitions and Acronyms

<!-- Sorted alphabetically. Build by scanning every upstream artefact for abbreviations (any all-caps token of length 2–6). For each: use the upstream definition if it is defined inline; use the standard expansion for framework abbreviations (BUC, FR, NFR, etc.); generate OQ Severity=Medium if a domain abbreviation appears more than once but is not defined upstream. -->

| Term | Definition | Source |
|------|------------|--------|
| AC | Acceptance Criterion | Framework |
| BUC | Business Use Case | Framework |
| CON | Constraint | Framework |
| EP | Epic | Framework |
| FR | Functional Requirement | Framework |
| NFR | Non-Functional Requirement | Framework |
| RFC 2119 | Internet standard for requirement-level keywords (SHALL / SHOULD / MAY) | https://www.rfc-editor.org/rfc/rfc2119 |
| SH | Stakeholder | Framework |
| SRS | Software Requirements Specification | Framework |
| US | User Story | Framework |
| <!-- domain term --> | <!-- definition --> | <!-- elicit doc / external --> |

### 1.4 References

<!-- Numbered list of every input document that contributed: the elicit doc, every row of inputs/manifest.md, every Accepted Epic file, every Accepted Story file, plus normative external references (RFC 2119, IEEE 29148:2018, any standards cited in NFRs). -->

1. <!-- Elicitation Document path + version + Approved date -->
2. <!-- Each input from manifest.md -->
3. <!-- Each Accepted Epic file -->
4. <!-- Each Accepted Story file -->
N. RFC 2119 — Bradner, S. *Key words for use in RFCs to Indicate Requirement Levels*. IETF, March 1997. https://www.rfc-editor.org/rfc/rfc2119
N+1. IEEE 29148:2018 — *Systems and software engineering — Life cycle processes — Requirements engineering*. ISO/IEC/IEEE.

### 1.5 Overview

This document is structured as follows:

- **Section 2 (Overall Description)** sets out the product's perspective, user classes, operating environment, design constraints, assumptions, and risks.
- **Section 3 (System Features)** lists each Accepted Epic with its constituent User Stories.
- **Section 4 (Functional Requirements)** specifies every Accepted FR in scope, grouped by Priority.
- **Section 5 (Non-Functional Requirements)** specifies every Accepted NFR in scope, including cross-cutting NFRs.
- **Section 6 (Constraints)** lists every Accepted Constraint binding the system.
- **Section 7 (External Interfaces)** describes every API the system exposes or consumes, derived from `inputs/APIs/`.
- **Section 8 (Acceptance Criteria)** lists every AC for FRs and NFRs in scope.
- **Section 9 (Traceability Matrix)** provides forward and backward traceability across the full chain Stakeholder → BUC → FR → NFR → CON → Epic → Story → AC → Test Case.
- **Section 10 (Revision History)** records changes to the SRS itself.

---

## 2. Overall Description

### 2.1 Product Perspective

<!-- One paragraph. If elicit Section 4 has a Component Overview (COMP-001), summarise the diagram in prose plus insert the Mermaid diagram inline. If not, state that the product is self-contained per the BUCs in Section 3. -->

```mermaid
%%{init: {'theme': 'neutral'}}%%
flowchart LR
    <!-- Insert Component Overview from elicit Section 4.0 if present -->
```

### 2.2 User Classes

<!-- Group elicit Section 2 (Stakeholders) by Role. Each user class has: class name, SH-IDs, Primary Concerns (union), BUCs they engage with. -->

#### <!-- Class Name (e.g., "End User") -->

- **Stakeholder IDs:** <!-- SH-001, SH-002 -->
- **Primary Concerns:** <!-- aggregated -->
- **BUCs engaged:** <!-- BUC-001, BUC-002 -->

### 2.3 Operating Environment

<!-- Lift CONs of Type = Technology or Type = Platform from elicit Section 5.3. State each in plain prose. -->

- <!-- e.g., "The system shall run on iOS 16+ and Android 13+ devices (CON-001)." -->

### 2.4 Design and Implementation Constraints

<!-- Lift CONs of Type = Regulatory or Type = Organizational. State each constraint and its origin. -->

- <!-- e.g., "The system shall comply with the General Data Protection Regulation (CON-002, Regulatory). All FRs in Section 4 inherit this constraint." -->

### 2.5 Assumptions and Dependencies

<!-- Lift elicit Section 5.4 (Assumptions) verbatim. -->

| ID | Description | Owner | Status | Impact if Wrong |
|----|-------------|-------|--------|-----------------|
| ASMP-### | <!-- lifted --> | <!-- SH-### --> | <!-- Pending / Validated / Invalidated --> | <!-- lifted --> |

### 2.6 Risks

<!-- Lift elicit Section 5.5 (Risks) verbatim. -->

| ID | Description | Likelihood | Impact | Owner | Mitigation | Status |
|----|-------------|-----------|--------|-------|-----------|--------|
| RSK-### | <!-- lifted --> | <!-- H/M/L --> | <!-- H/M/L --> | <!-- SH-### --> | <!-- lifted --> | <!-- Pending / Mitigated / Accepted / Closed --> |

---

## 3. System Features

<!-- One sub-section per Accepted Epic, in EP-### order. Each sub-section lists the Epic's Stories with narratives and parent FRs. -->

### EP-### — <!-- Epic Title -->

<!-- One paragraph: Epic Description + Business Value (lifted from epic-NNN.md Sections 1 and 2). -->

**Stories under this Epic:**

- **US-### — <!-- Title -->** (<!-- N --> pts<!-- ; depends on US-### -->)
  - *As a <!-- role -->, I want <!-- action -->, so that <!-- outcome -->.*
  - Parent FR: FR-### | Owner: SH-###

---

## 4. Functional Requirements

> Lifted verbatim from `artifacts/01-elicitation/elicitation-document.md` Section 5.1. Every FR with `Status = Accepted` linked to a BUC in an Accepted Epic is included; FRs whose parent Epic is currently Pending or Rejected are listed in Section 9 as Deferred.

### 4.1 Must Have

#### FR-### — <!-- Title -->

- **Description:** <!-- The system SHALL ... — verbatim from elicit doc, RFC 2119 -->
- **Business Use Case:** BUC-### — <!-- Title -->
- **Stakeholder:** SH-### — <!-- Role -->
- **Source:** <!-- input filename + section -->
- **Rationale:** <!-- lifted -->
- **Acceptance Criteria:** See Section 8 — AC-FR-###-01, AC-FR-###-02
- **Status:** Accepted | **Accepted By:** SH-### | **Accepted Date:** <!-- YYYY-MM-DD -->

### 4.2 Should Have

<!-- Same format -->

### 4.3 Could Have / Won't Have (in scope, deferred priority)

<!-- Same format -->

---

## 5. Non-Functional Requirements

> Lifted verbatim from elicit doc Section 5.2. Cross-cutting NFRs (those whose Business Use Case field references multiple BUCs) are listed once with the full BUC scope and Cross-cutting flag.

### NFR-### — <!-- Title -->

- **Description:** <!-- The system SHALL ... — verbatim, RFC 2119 -->
- **Category:** <!-- Performance / Security / Usability / Reliability / Scalability / Maintainability / Compliance -->
- **Priority:** <!-- MoSCoW -->
- **Measurable Target:** <!-- exact threshold from elicit doc — verbatim -->
- **Business Use Case scope:** <!-- BUC-001, BUC-002, ... -->
- **Cross-cutting?** Yes / No
- **Acceptance Criteria:** See Section 8 — AC-NFR-###-01
- **Status:** Accepted | **Accepted By:** SH-### | **Accepted Date:** <!-- YYYY-MM-DD -->

---

## 6. Constraints

> Lifted verbatim from elicit doc Section 5.3.

### CON-### — <!-- Title -->

- **Description:** <!-- the constraint and its origin -->
- **Type:** <!-- Technology / Regulatory / Budget / Timeline / Organizational -->
- **Impact:** <!-- design decisions this forces or excludes -->
- **Source:** <!-- input filename / "stated by SH-###" -->
- **Status:** Accepted | **Accepted By:** SH-###

---

## 7. External Interfaces

> Derived from OpenAPI 3.x YAML files in `inputs/APIs/`. Each service is summarised; full schemas remain in the YAML files referenced.

### <!-- Service Name (from info.title) -->

- **Base URL:** <!-- servers[0].url -->
- **Source YAML:** `inputs/APIs/<filename>.yaml`

| Method | Path | operationId | Summary |
|--------|------|-------------|---------|
| GET | /v1/example | getExample | <!-- summary --> |

**Key schemas:** <!-- comma-separated names from components/schemas -->

<!-- If inputs/APIs/ is empty or absent: replace this whole section with the placeholder paragraph below. -->

> **No external interfaces are defined for this system.** If the system integrates with external services, add OpenAPI YAML files to `inputs/APIs/` and re-run `/elicit` followed by `/create-srs` to refresh this section.

---

## 8. Acceptance Criteria

> Lifted verbatim from elicit doc Section 6. AC IDs and acceptance fields belong to the elicit doc; the SRS inherits them for traceability.

### FR-### Acceptance Criteria

- **AC-FR-###-01**
  - **Given:** <!-- preserved from elicit doc -->
  - **When:** <!-- preserved -->
  - **Then:** <!-- preserved -->
  - **Status:** <!-- inherited --> | **Accepted By:** <!-- inherited --> | **Accepted Date:** <!-- inherited -->

### NFR-### Acceptance Criteria

- **AC-NFR-###-01**
  - **Criterion:** <!-- preserved verbatim from elicit doc; matches the parent NFR's Measurable Target -->
  - **Status:** <!-- inherited --> | **Accepted By:** <!-- inherited --> | **Accepted Date:** <!-- inherited -->

---

## 9. Traceability Matrix

> Auto-generated by `/create-srs` on every run. Always rebuilt from current upstream state — do not edit manually.

| Stakeholder | BUC | FR | NFR | CON | Epic | Story | AC | Test Case |
|-------------|-----|-----|-----|-----|------|-------|-----|----------|
| SH-001 | BUC-001 | FR-001 | NFR-001 | CON-002 | EP-001 | US-001 | AC-FR-001-01 | — |

> Test Case column is reserved for `/create-tests` (Phase 5) and remains `—` until that skill has run.

### 9.1 Coverage Statistics

| Element | In this SRS | Deferred (parent Epic Pending/Rejected) |
|---------|-------------|----------------------------------------|
| Stakeholders | <!-- N --> | <!-- D --> |
| Business Use Cases | <!-- N --> | <!-- D --> |
| Functional Requirements | <!-- N --> | <!-- D --> |
| Non-Functional Requirements | <!-- N --> | <!-- D --> |
| Constraints | <!-- N --> | 0 |
| Epics | <!-- N --> | <!-- D --> |
| Stories | <!-- N --> | <!-- D --> |
| Acceptance Criteria | <!-- N --> | <!-- D --> |

### 9.2 Orphan Checks

<!-- Each Yes-row indicates a structural defect that generated an OQ Severity=High during the run. -->

| Check | Result |
|-------|--------|
| Every eligible FR has at least one AC | <!-- Yes / No (list orphans) --> |
| Every eligible NFR has at least one AC | <!-- Yes / No --> |
| Every Story has a parent FR in scope | <!-- Yes / No --> |
| Every Epic has at least one Story | <!-- Yes / No --> |
| Every Stakeholder owns at least one BUC | <!-- Yes / No --> |

---

## 10. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | <!-- CREATION_DATE --> | create-srs skill (initial) | Initial SRS — N FRs, M NFRs, K CONs, J Stories across I Epics |
