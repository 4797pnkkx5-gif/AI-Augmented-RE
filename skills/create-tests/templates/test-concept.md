---
artifact: test-concept
project: <!-- PROJECT_NAME -->
version: 1.0
created: <!-- CREATION_DATE -->
last-updated: <!-- LAST_UPDATED_DATE -->
status: Pending
reviewed-by: <!-- SH-### (typically the QA lead) -->
approved-date: —
based-on:
  srs-version: <!-- SRS version + Approved date -->
  ac-count: <!-- count of ACs in SRS canonical list -->
  tc-count: <!-- count of TCs minted -->
---

# Test Concept — <!-- PROJECT_NAME -->

> **Status:** Pending | **Version:** 1.0 | **Created:** <!-- CREATION_DATE --> | **Last Updated:** <!-- LAST_UPDATED_DATE -->
>
> Test strategy document derived from the Accepted Software Requirements Specification. This document does **not** contain individual test cases — those live in `test-case-NNN.md` files in the same folder, with the `index.md` aggregator providing the AC coverage matrix. This document contains the team-facing strategy: levels, types, environments, coverage targets, entry/exit criteria, roles, and reporting.

---

## 1. Purpose

This Test Concept covers the system specified in the Software Requirements Specification version <!-- SRS version --> (Approved <!-- SRS Approved date -->). It defines the test strategy for verifying that the system meets the Acceptance Criteria in SRS Section 8.

The Test Concept is reviewed and accepted by the QA lead before test execution begins. Individual Test Cases are reviewed independently — see `index.md` for the per-TC acceptance status.

## 2. Test Strategy

### 2.1 Test Levels

The framework recognises four test levels:

- **Acceptance** — verifies an FR AC end-to-end from the user's perspective. Most FR ACs in this project are at this level.
- **System** — verifies an NFR AC under defined operating conditions. Performance, Security, Reliability, and Compliance NFRs are tested here.
- **Integration** — verifies interactions between components. Used when an AC implicitly requires multi-component coordination; the team identifies these during sprint planning.
- **Unit** — verifies a single function or class in isolation. Below the AC level; not directly mapped to ACs in this project's TC set.

### 2.2 Test Types

The framework's `/create-tests` skill auto-assigns Type per AC using a deterministic heuristic:

| AC source | Type | Level |
|-----------|------|-------|
| FR AC | Functional | Acceptance |
| NFR AC, Category = Performance | Performance | System |
| NFR AC, Category = Security | Security | System |
| NFR AC, Category = Usability | Usability | System |
| NFR AC, Category = Reliability | Reliability | System |
| NFR AC, Category = Scalability | Scalability | System |
| NFR AC, Category = Maintainability | Maintainability | System |
| NFR AC, Category = Compliance | Compliance | System |

The heuristic is published, not authoritative — the QA lead may override Type or Level on a per-TC basis during sprint planning if the team's test stack or pyramid demands it.

## 3. Coverage Targets

The Test Concept commits to the following coverage targets:

- **Every AC in SRS Section 8 has at least one TC.** Orphan ACs (AC in SRS without a TC) are blocking defects.
- **Every Must-Have FR has at least one Acceptance-level TC.** This is the Acceptance gate that signs off the Story.
- **Every Performance / Security / Reliability NFR has at least one System-level TC** at the NFR's stated Measurable Target.
- **Every Compliance NFR has at least one Compliance / Audit TC** linked to the regulatory citation in the NFR.

Coverage statistics for this run are in `index.md` Sections 4 and 5.

## 4. Risk-Based Prioritisation

Test Case Priority is **inherited** from the parent FR/NFR Priority (MoSCoW). Execution order:

1. **Must Have TCs** — execute first; failures block release.
2. **Should Have TCs** — execute second; failures block release unless documented.
3. **Could Have TCs** — execute if time permits; failures are tracked but do not block release.
4. **Won't Have (this iteration) TCs** — not executed; documented for future cycles.

Compliance and Security TCs are executed in every release regardless of MoSCoW priority — regulatory exposure is independent of feature priority.

## 5. Test Environments

Test environments are driven by the parent NFR's Measurable Target. Indicative mapping:

- **Functional / Acceptance TCs** — staging environment matching production configuration. Local execution acceptable for individual-developer validation.
- **Performance TCs** — load-test environment matching the NFR's stated conditions (concurrent users, request rate, data volume).
- **Security TCs** — penetration-test environment; staging with security tooling enabled (OWASP ZAP, dependency scanners, etc.).
- **Compliance TCs** — audit environment; the regulator's requirements determine the configuration (e.g., GDPR data-handling tests run with anonymised production-shape data).

The team confirms specifics during sprint planning. The Test Concept is not authoritative on infrastructure.

## 6. Tools and Frameworks

*The team to define during sprint planning.* Common starting points:

- **Acceptance / Functional:** Cypress, Playwright, or framework-specific equivalents.
- **Performance:** k6, JMeter, Locust.
- **Security:** OWASP ZAP, Burp Suite, dependency-vulnerability scanners.
- **Compliance:** custom audit scripts plus regulatory checklists.

Whatever the team picks, the TC files in this folder are tool-agnostic — they document Given/When/Then and pass criteria. The team's test framework imports them or maps them at execution time.

## 7. Entry Criteria

Before test execution begins:

- The SRS at `artifacts/04-srs/srs.md` must be `status: Accepted`.
- The Test Concept (this document) must be `status: Accepted` by the QA lead.
- Every TC under test must be `status: Accepted` (per-TC review).
- The system under test is deployed to the appropriate environment for the TC's Level / Type.

## 8. Exit Criteria

A test cycle is complete when:

- **Critical AC coverage:** every Must-Have AC has a passing TC run on the current build.
- **High AC coverage:** every Should-Have AC has a passing TC run, with documented exceptions for any failures the Product Owner accepts.
- **Could-Have AC coverage:** documented (passing or known-failing) — not blocking.
- **Compliance / Security TCs:** all passing on the current build, regardless of MoSCoW priority.
- **No Critical OQ Open** in any artefact across the pipeline.

## 9. Roles & Responsibilities

- **TC Owner (per-TC):** the parent FR/NFR Stakeholder, inherited automatically. Responsible for accepting the TC content and verifying execution outcomes for their requirements.
- **QA Lead:** reviews and accepts the Test Concept (this document) and the TC set as a whole; coordinates execution.
- **Delivery Team:** executes TCs against the system under test; reports pass/fail and defects.
- **Product Owner:** signs off on documented Should-Have / Could-Have failures; final go/no-go on release.

## 10. Reporting

Pass / fail per TC is tracked at execution time in the team's CI/CD or test-management tool. Aggregate reports surface:

- TC pass-rate per FR / NFR
- TC pass-rate per Epic (rolled up from FR/NFR rates)
- Compliance / Security TC pass status (always 100% required)
- Open defects linked to specific TC IDs

The framework's `/trace` skill (Phase 6) generates the cross-pipeline traceability matrix that links TC IDs back through US → EP → FR → BUC → SH for impact analysis.

## 11. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | <!-- CREATION_DATE --> | create-tests skill (initial) | Initial Test Concept compiled from SRS version <!-- N --> |
