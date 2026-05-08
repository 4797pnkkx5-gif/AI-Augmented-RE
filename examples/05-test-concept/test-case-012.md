---
artifact: test-case
project: PocketPing
tc-id: TC-012
parent-ac: AC-NFR-002-01
parent-fr: —
parent-nfr: NFR-002
parent-epic: EP-001
parent-story: —
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-002
priority: Must Have
type: Security
level: System
reviewed-by: SH-002
approved-date: —
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# TC-012: Test Session Authentication — every API endpoint rejects unauthenticated requests with HTTP 401

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-NFR-002-01 | **Parent FR/NFR:** NFR-002 | **Owner:** SH-002
> **Type:** Security | **Level:** System | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the system-wide authentication invariant binding every API surface in EP-001 and EP-002 (and by extension EP-003, since the Notification Service consumes the same gateway): without a valid session token, every endpoint must return HTTP 401, and a penetration test must find zero endpoints reachable without authentication. This is the foundation for every privacy and consent guarantee in the product.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-NFR-002-01 | Every API endpoint returns 401 to unauthenticated requests |
| Parent FR or NFR | NFR-002 | Session Authentication |
| Source BUC | BUC-001, BUC-002, BUC-003 | (cross-cutting) |
| Parent Epic | EP-001, EP-002 | (cross-cutting) |
| Parent Story | — | (NFR cross-cutting; no single Story) |
| Stakeholder | SH-002 | Lead Mobile Engineer |

## 3. Type and Level (AI assignment)

- **Type:** Security
- **Level:** System
- **Sub-type:** Threshold-based
- **Heuristic applied:**
  - NFR AC, Category=Security → Security / System
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

System-level Security TC for NFR-002. Per Test Concept Section 4 (Risk-Based Prioritisation), Security TCs are executed in every release regardless of MoSCoW priority — this run is mandatory for every release candidate. Recommended tooling: OWASP ZAP, Burp Suite, plus a scripted endpoint enumerator to assert 401 from every exposed route.

## 5. Test Data

- A complete list of API endpoints exposed by the API Gateway (derived from the OpenAPI spec at `inputs/APIs/location-service.yaml` plus any additional service surfaces referenced in elicit Section 4). Note that OQ-009 / OQ-010 in the SRS flag that the OpenAPI surface is currently incomplete; the team enumerates the running service to make sure no endpoint is missed at test time.
- An unauthenticated client (no session token, expired token, malformed token) for each test request.

## 6. Preconditions

- The system is deployed in its baseline state in the test environment, with the same authentication configuration used in production, and the authoritative endpoint list has been enumerated.

## 7. Test Steps

1. Issue a request without a valid session token to every exposed API endpoint and record each response code; complement with a penetration-test pass to discover any endpoint reachable without authentication.

## 8. Expected Result

- **Then:** 100% of API endpoints return HTTP 401 for requests with no valid session token. Zero endpoints accessible without authentication in penetration test.

## 9. Test Environment

- Penetration-test environment: staging with security tooling enabled (OWASP ZAP, dependency scanners), matching production authentication configuration. Network ingress matches production (no internal-only bypass routes available to the test client).

## 10. Pass / Fail Criteria

- **Pass:** 100% of enumerated API endpoints respond with HTTP 401 to unauthenticated requests AND the penetration-test pass discovers zero endpoints reachable without authentication.
- **Fail:** Any endpoint returns a status other than 401 to an unauthenticated request, or any endpoint is reachable without authentication during the penetration-test pass.

Do not invent thresholds beyond what the parent AC states. The team may add team-specific tolerances during sprint planning.

## 11. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| OQ-011 | The authoritative API surface for the AC-NFR-002-01 enumeration is not fully captured by `inputs/APIs/location-service.yaml` — SRS OQ-009 / OQ-010 flag empty schemas and missing endpoints for FR-004..FR-008. Confirm the canonical endpoint list TC-012 will assert 401 against (e.g., extend the OpenAPI specs, or document the full Notification Service / Trusted-Circle Service surfaces) before TC-012 can be considered an exhaustive system-level test. | High | Open | create-tests skill |

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-002
- **Accepted By:** SH-002
- **Accepted Date:** —
- **Source:** SRS Section 8 (AC-NFR-002-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-NFR-002-01 |
