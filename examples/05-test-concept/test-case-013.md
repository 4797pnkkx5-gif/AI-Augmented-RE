---
artifact: test-case
project: PocketPing
tc-id: TC-013
parent-ac: AC-NFR-003-01
parent-fr: —
parent-nfr: NFR-003
parent-epic: EP-001
parent-story: —
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-003
priority: Must Have
type: Compliance
level: System
reviewed-by: SH-003
approved-date: —
---

> **Calibration example — not a real project.** Produced by `/create-tests` from `examples/04-srs/srs.md`. **Status is `Pending`** — the human QA lead would Accept after review.

---

# TC-013: Test Data Retention Compliance — location records older than 30 days deleted within 24 h

> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Parent AC:** AC-NFR-003-01 | **Parent FR/NFR:** NFR-003 | **Owner:** SH-003
> **Type:** Compliance | **Level:** System | **Priority:** Must Have
>
> Test Cases verify Acceptance Criteria from the Approved Software Requirements Specification. Each TC corresponds to exactly one AC; Given/When/Then content is lifted verbatim from the parent AC.

---

## 1. Description

Verifies the system's GDPR Article 5(1)(e) (storage limitation) compliance commitment: any location record whose timestamp is older than 30 days from the current date must be automatically deleted from the system within 24 hours of crossing that threshold. This is the regulatory anchor for CON-002 in the location-data path; OQ-002 (Resolved) confirmed full deletion is required, not soft-hide.

## 2. Parent Traceability

| Link | ID | Title |
|------|-----|------|
| Parent AC | AC-NFR-003-01 | Records older than 30 days deleted within 24 h |
| Parent FR or NFR | NFR-003 | Data Retention Compliance |
| Source BUC | BUC-001 | Share Location |
| Parent Epic | EP-001 | Real-Time Location Sharing & Viewing |
| Parent Story | — | (NFR; no single Story — retention applies system-wide to BUC-001 data) |
| Stakeholder | SH-003 | Privacy & Compliance Officer |

## 3. Type and Level (AI assignment)

- **Type:** Compliance
- **Level:** System
- **Sub-type:** Audit
- **Heuristic applied:**
  - NFR AC, Category=Compliance → Compliance / System
- **Note:** **AI assignment — confirm with QA team.** Type and Level may be overridden during sprint planning if the team's pyramid or test stack differs from the heuristic's defaults.

## 4. Coverage Notes

System-level Compliance TC for NFR-003. Per Test Concept Section 4 (Risk-Based Prioritisation), Compliance TCs are executed in every release regardless of MoSCoW priority. The deletion is full physical deletion per OQ-002 resolution recorded in the elicit doc; soft-hide is non-compliant.

## 5. Test Data

- Synthetic Location DB rows with timestamps spanning < 30 days, exactly 30 days, and > 30 days, including some > 30 days but < 30 days + 24 h to verify the 24-hour deletion-grace window.
- Anonymised production-shape data per Test Concept Section 5 (Compliance test environment guidance).

## 6. Preconditions

- The system is deployed in its baseline state in the audit environment, with the data-retention job enabled on the same schedule used in production, and the seed data above present.

## 7. Test Steps

1. Run (or wait for) the data-retention job; verify by direct database query that all location records with a timestamp older than 30 days from the current date are absent from storage within 24 hours of reaching that threshold.

## 8. Expected Result

- **Then:** All location records with a timestamp older than 30 days from the current date must be automatically deleted within 24 hours of reaching that threshold.

## 9. Test Environment

- Audit environment per Test Concept Section 5: anonymised production-shape data, production-equivalent retention-job configuration, regulator-aligned audit logging enabled.

## 10. Pass / Fail Criteria

- **Pass:** Every location record whose timestamp is older than 30 days has been removed from storage within 24 hours of crossing the threshold.
- **Fail:** Any record older than 30 days + 24 hours remains in storage, or records are only soft-hidden / archived rather than fully deleted.

Do not invent thresholds beyond what the parent AC states. The team may add team-specific tolerances during sprint planning.

## 11. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this TC) | — | — | — |

## 12. Acceptance

- **Status:** Pending
- **Owner:** SH-003
- **Accepted By:** SH-003
- **Accepted Date:** —
- **Source:** SRS Section 8 (AC-NFR-003-01); cross-checked against elicit Section 6.

## 13. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-tests skill (initial run) | Initial TC minted from AC-NFR-003-01 |
