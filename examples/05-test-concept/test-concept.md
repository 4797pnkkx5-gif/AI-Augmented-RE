---
artifact: test-concept
project: PocketPing
version: 1.0
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
reviewed-by: SH-001 (Alex Chen, Product Owner) — QA lead role to be confirmed
approved-date: —
based-on:
  srs-version: v1.0 (Approved 2026-05-08)
  ac-count: 14
  tc-count: 14
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# Test Concept — PocketPing

> **Status:** Pending | **Version:** 1.0 | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
>
> Test strategy document derived from the Accepted Software Requirements Specification. This document does **not** contain individual test cases — those live in `test-case-NNN.md` files in the same folder, with the `index.md` aggregator providing the AC coverage matrix. This document contains the team-facing strategy: levels, types, environments, coverage targets, entry/exit criteria, roles, and reporting.

---

## 1. Purpose

This Test Concept covers the system specified in the Software Requirements Specification version v1.0 (Approved 2026-05-08). It defines the test strategy for verifying that the system meets the 14 Acceptance Criteria in SRS Section 8 — 10 FR ACs and 4 NFR ACs across the three Accepted Epics (EP-001 Real-Time Location Sharing & Viewing, EP-002 Manage Trusted Circle, EP-003 Place Notifications).

The Test Concept is reviewed and accepted by the QA lead before test execution begins. Individual Test Cases are reviewed independently — see `index.md` for the per-TC acceptance status.

## 2. Test Strategy

### 2.1 Test Levels

The framework recognises four test levels:

- **Acceptance** — verifies an FR AC end-to-end from the user's perspective. All 10 FR ACs in PocketPing v1 are at this level (TC-001 through TC-010).
- **System** — verifies an NFR AC under defined operating conditions. The four NFRs (latency, authentication, retention, battery) are tested here (TC-011 through TC-014).
- **Integration** — verifies interactions between components. Used when an AC implicitly requires multi-component coordination (for example, the Notification Service consuming Location Service events for FR-008); the team identifies these during sprint planning.
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

The heuristic is published, not authoritative — the QA lead may override Type or Level on a per-TC basis during sprint planning if the team's test stack or pyramid demands it. For PocketPing the assignment yields: 10 Functional / Acceptance, 1 Performance / System (NFR-001), 1 Security / System (NFR-002), 1 Compliance / System (NFR-003), and 1 Usability / System (NFR-004).

## 3. Coverage Targets

The Test Concept commits to the following coverage targets:

- **Every AC in SRS Section 8 has at least one TC.** Orphan ACs (AC in SRS without a TC) are blocking defects. Status for this run: 14 ACs, 14 TCs, 0 orphans.
- **Every Must-Have FR has at least one Acceptance-level TC.** This is the Acceptance gate that signs off the Story. Must-Have FRs in this run: FR-001 (TC-001, TC-002), FR-002 (TC-003), FR-003 (TC-004), FR-005 (TC-006, TC-007), FR-006 (TC-008) — all covered.
- **Every Performance / Security / Reliability NFR has at least one System-level TC** at the NFR's stated Measurable Target. Status: NFR-001 → TC-011 (Performance / System); NFR-002 → TC-012 (Security / System). No Reliability NFR in scope.
- **Every Compliance NFR has at least one Compliance / Audit TC** linked to the regulatory citation in the NFR. Status: NFR-003 → TC-013 (Compliance / System), citing GDPR Article 5(1)(e).

Coverage statistics for this run are in `index.md` Sections 4 and 5.

## 4. Risk-Based Prioritisation

Test Case Priority is **inherited** from the parent FR/NFR Priority (MoSCoW). Execution order:

1. **Must Have TCs** — execute first; failures block release. PocketPing Must-Have set: TC-001, TC-002, TC-003, TC-004, TC-006, TC-007, TC-008, TC-011, TC-012, TC-013 (10 TCs).
2. **Should Have TCs** — execute second; failures block release unless documented. PocketPing Should-Have set: TC-005 (FR-004 trail), TC-009 (FR-007 Place), TC-010 (FR-008 geofence), TC-014 (NFR-004 battery).
3. **Could Have TCs** — execute if time permits; failures are tracked but do not block release. (none in this iteration.)
4. **Won't Have (this iteration) TCs** — not executed; documented for future cycles. (none in this iteration.)

Compliance and Security TCs are executed in every release regardless of MoSCoW priority — regulatory exposure is independent of feature priority. For PocketPing: TC-012 (Security) and TC-013 (Compliance) run on every release candidate.

## 5. Test Environments

Test environments are driven by the parent NFR's Measurable Target. Indicative mapping:

- **Functional / Acceptance TCs (TC-001 .. TC-010)** — staging environment matching production configuration. Local execution acceptable for individual-developer validation. SMS-receiving fixtures required for TC-006; APNs / FCM test path required for TC-010; address-search backend required for TC-009.
- **Performance TC (TC-011)** — load-test environment matching the NFR's stated conditions: 10 000 concurrent sharing sessions sustained long enough to gather a statistically significant p95 latency distribution.
- **Security TC (TC-012)** — penetration-test environment: staging with security tooling enabled (OWASP ZAP, dependency scanners, etc.).
- **Compliance TC (TC-013)** — audit environment: anonymised production-shape data, production-equivalent retention-job configuration, regulator-aligned audit logging enabled.
- **Usability TC (TC-014)** — battery-measurement lab on iPhone 14 and Samsung Galaxy S23 under standard lab conditions.

The team confirms specifics during sprint planning. The Test Concept is not authoritative on infrastructure.

## 6. Tools and Frameworks

*The team to define during sprint planning.* Common starting points:

- **Acceptance / Functional:** Cypress, Playwright, or framework-specific equivalents (mobile: Detox, Maestro, XCUITest, Espresso).
- **Performance:** k6, JMeter, Locust.
- **Security:** OWASP ZAP, Burp Suite, dependency-vulnerability scanners.
- **Compliance:** custom audit scripts plus regulatory checklists (GDPR Article 5(1)(e) verification).

Whatever the team picks, the TC files in this folder are tool-agnostic — they document Given/When/Then and pass criteria. The team's test framework imports them or maps them at execution time.

## 7. Entry Criteria

Before test execution begins:

- The SRS at `artifacts/04-srs/srs.md` must be `status: Accepted`. Confirmed: SRS v1.0 Accepted 2026-05-08.
- The Test Concept (this document) must be `status: Accepted` by the QA lead.
- Every TC under test must be `status: Accepted` (per-TC review).
- The system under test is deployed to the appropriate environment for the TC's Level / Type.

## 8. Exit Criteria

A test cycle is complete when:

- **Critical AC coverage:** every Must-Have AC has a passing TC run on the current build (10 TCs in PocketPing v1).
- **High AC coverage:** every Should-Have AC has a passing TC run, with documented exceptions for any failures the Product Owner accepts (4 TCs in PocketPing v1).
- **Could-Have AC coverage:** documented (passing or known-failing) — not blocking. (None in this iteration.)
- **Compliance / Security TCs:** all passing on the current build, regardless of MoSCoW priority (TC-012 Security, TC-013 Compliance).
- **No Critical OQ Open** in any artefact across the pipeline.

## 9. Roles & Responsibilities

- **TC Owner (per-TC):** the parent FR/NFR Stakeholder, inherited automatically. Distribution for PocketPing v1: SH-001 owns 10 TCs (FR-001..FR-005, FR-007, FR-008), SH-002 owns TC-011 + TC-012, SH-003 owns TC-008 + TC-013, SH-004 owns TC-014.
- **QA Lead:** reviews and accepts the Test Concept (this document) and the TC set as a whole; coordinates execution.
- **Delivery Team:** executes TCs against the system under test; reports pass/fail and defects.
- **Product Owner (SH-001):** signs off on documented Should-Have / Could-Have failures; final go/no-go on release.

## 10. Reporting

Pass / fail per TC is tracked at execution time in the team's CI/CD or test-management tool. Aggregate reports surface:

- TC pass-rate per FR / NFR
- TC pass-rate per Epic (rolled up from FR/NFR rates) — three Epics in this run
- Compliance / Security TC pass status (always 100% required)
- Open defects linked to specific TC IDs

The framework's `/trace` skill (Phase 6) generates the cross-pipeline traceability matrix that links TC IDs back through US → EP → FR → BUC → SH for impact analysis.

## 11. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial) | Initial Test Concept compiled from SRS v1.0 (Approved 2026-05-08). 14 ACs → 14 TCs (10 Functional / Acceptance, 1 Performance / System, 1 Security / System, 1 Compliance / System, 1 Usability / System). 0 drift OQs raised; 0 orphan ACs; 1 Open OQ (OQ-011) flagging the API surface gap inherited from SRS OQ-009 / OQ-010 that affects TC-012's enumeration completeness. |
