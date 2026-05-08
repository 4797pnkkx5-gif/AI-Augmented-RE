---
artifact: epic
project: PocketPing
epic-id: EP-002
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Must Have
effort: L
reviewed-by: —
approved-date: —
---

# EP-002: Manage Trusted Circle

> **Calibration example — not a real project.** This Epic was produced by `/create-epics` from `examples/01-elicitation/elicitation-document-example.md`. It is in `Status = Pending` — the human reviewer would either Accept it as-is or provide corrections.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Owner:** SH-001 | **Priority:** Must Have | **Effort (AI estimate):** L
>
> Epics organise Accepted requirements from the Elicitation Document into outcome-shaped delivery containers. Cross-cutting NFRs may appear in more than one Epic; FRs may not.

---

## 1. Description

This Epic gives a user the ability to invite contacts into their trusted circle (with explicit acceptance by the invited party) and to remove contacts from the circle at any time, immediately terminating any active sharing sessions with the removed contact. It enforces the consent surface that gates all location-sharing flows in the rest of the product.

## 2. Business Value

The trusted circle is the consent boundary for every location-sharing interaction in PocketPing. GDPR Article 7(3) requires that withdrawal of consent be as easy as giving it, which is implemented by the invite/revoke pair (FR-005, FR-006). Owner SH-001 cares about UX quality and feature scope; co-stakeholder SH-003 (Privacy & Compliance Officer) — whose primary concerns are GDPR compliance, data minimisation, and consent flows — explicitly accepted FR-006 (revoke). Without this Epic the product cannot lawfully operate in the EU per CON-002.

## 3. Primary Business Use Cases

- BUC-003 — Manage Trusted Circle

## 4. In-Scope Requirements

> Only requirements with `Status = Accepted` in the Elicitation Document are listed here. Pending FRs/NFRs appear in Section 5 as Candidates. Rejected FRs/NFRs appear in Section 6.

### 4.1 Functional Requirements

| ID | Title | Priority | Source BUC |
|----|-------|----------|------------|
| FR-005 | Invite Contact to Trusted Circle | Must Have | BUC-003 |
| FR-006 | Revoke Contact Access | Must Have | BUC-003 |

### 4.2 Non-Functional Requirements

| ID | Title | Category | Measurable Target | Cross-cutting? |
|----|-------|----------|-------------------|----------------|
| NFR-002 | Session Authentication | Security | 100% of API endpoints return HTTP 401 for requests with no valid session token. Zero endpoints accessible without authentication in penetration test. | Yes |

### 4.3 Constraints

| ID | Title | Type |
|----|-------|------|
| CON-001 | Platform Scope | Organizational |
| CON-002 | GDPR Applicability | Regulatory |
| CON-003 | No Third-Party Analytics in Core Flow | Regulatory |

## 5. Candidate Requirements (Pending — informational)

| ID | Title | Status | Note |
|----|-------|--------|------|
| — | (none) | — | No Pending FR/NFR is currently linked to BUC-003. |

## 6. Out-of-Scope

- No FRs/NFRs linked to BUC-003 are in `Rejected` status in the elicit doc.
- Inherited from elicit Section 1.3: location sharing with more than the explicitly invited contacts; social features beyond the trusted circle.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| — | — | No explicit dependency stated in the elicit doc. (FR-001 and FR-003 implicitly assume an established trusted circle, but the elicit doc does not declare this dependency in any FR.Rationale or BUC.Trigger field; not invented here.) | — |

## 8. Success Metrics

| Metric | Target | Source |
|--------|--------|--------|
| API authentication coverage | 100% of API endpoints return HTTP 401 for requests with no valid session token. Zero endpoints accessible without authentication in penetration test. | NFR-002 |

## 9. Effort Estimate (AI provisional)

- **T-shirt size:** L
- **Heuristic applied:**
  - S — ≤ 2 In-Scope FRs and no Performance/Security NFR
  - M — 3–5 In-Scope FRs
  - L — 6–7 In-Scope FRs, or contains a Performance/Security NFR
  - XL — > 7 In-Scope FRs, or contains a Regulatory CON
- **Rationale:** Only 2 In-Scope FRs (would qualify for S on count alone) but the Epic contains a Security NFR (NFR-002, cross-cutting), promoting it to L per the heuristic. Additional regulatory weight from CON-002 (GDPR) reinforces this sizing.
- **Note:** AI estimate — confirm with team. Sizing is not derivable from the elicit doc and must be calibrated by the delivery team before commitment.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| — | (none raised by this skill against EP-002) | — | — | — |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-epics skill (initial run) | Initial seed from BUC-003 |
