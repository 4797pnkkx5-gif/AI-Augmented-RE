---
artifact: epic
project: PocketPing
epic-id: EP-001
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Must Have
effort: L
reviewed-by: —
approved-date: —
---

# EP-001: Real-Time Location Sharing & Viewing

> **Calibration example — not a real project.** This Epic was produced by `/create-epics` from `examples/01-elicitation/elicitation-document-example.md`. It is in `Status = Pending` — the human reviewer would either Accept it as-is or use OQ-005 (Section 10) to reject the merge and instruct the skill to produce two separate Epics for BUC-001 and BUC-002 on the next run.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Owner:** SH-001 | **Priority:** Must Have | **Effort (AI estimate):** L
>
> Epics organise Accepted requirements from the Elicitation Document into outcome-shaped delivery containers. Cross-cutting NFRs may appear in more than one Epic; FRs may not.

---

## 1. Description

This Epic delivers PocketPing's core value proposition: a registered user can start and stop a real-time location sharing session with one or more contacts from their trusted circle, and any contact with an active session can view the sharing user's current position on a map together with a 24-hour movement trail. It bundles the outbound side (start, stop) with the inbound side (live pin, trail) because the two BUCs are operated by the same primary actor (SH-001) and share the same end-to-end performance and authentication NFRs — splitting them would scatter coupled behaviour across Epics.

## 2. Business Value

PocketPing exists so users in personal-safety scenarios can let trusted people see where they are without broadcasting publicly or relying on manual SMS / voice check-ins (Problem Statement, Section 1.2). Without this Epic the product has no function: BUC-001 delivers the "share with one tap" promise and BUC-002 delivers the recipient half of that promise. Owner SH-001 (Product Owner) has flagged feature scope, UX quality, and timeline as primary concerns — this Epic is the Must-Have core that anchors all of them.

## 3. Primary Business Use Cases

- BUC-001 — Share Location
- BUC-002 — View Contact Location

## 4. In-Scope Requirements

> Only requirements with `Status = Accepted` in the Elicitation Document are listed here. Pending FRs/NFRs appear in Section 5 as Candidates. Rejected FRs/NFRs appear in Section 6.

### 4.1 Functional Requirements

| ID | Title | Priority | Source BUC |
|----|-------|----------|------------|
| FR-001 | Start Location Sharing Session | Must Have | BUC-001 |
| FR-002 | Stop Location Sharing | Must Have | BUC-001 |
| FR-003 | View Contact Live Location | Must Have | BUC-002 |
| FR-004 | View 24-Hour Location Trail | Should Have | BUC-002 |

### 4.2 Non-Functional Requirements

| ID | Title | Category | Measurable Target | Cross-cutting? |
|----|-------|----------|-------------------|----------------|
| NFR-001 | Location Update Latency | Performance | End-to-end location update latency must be < 5 seconds at p95 under 10,000 concurrent sharing sessions. | No |
| NFR-002 | Session Authentication | Security | 100% of API endpoints return HTTP 401 for requests with no valid session token. Zero endpoints accessible without authentication in penetration test. | Yes |
| NFR-003 | Data Retention Compliance | Compliance | All location records with a timestamp older than 30 days from the current date must be automatically deleted within 24 hours of reaching that threshold. | No |
| NFR-004 | Battery Impact | Usability | Background location polling must consume < 5% of device battery per hour when actively sharing, measured on iPhone 14 and Samsung Galaxy S23 under standard lab conditions. | No |

### 4.3 Constraints

| ID | Title | Type |
|----|-------|------|
| CON-001 | Platform Scope | Organizational |
| CON-002 | GDPR Applicability | Regulatory |
| CON-003 | No Third-Party Analytics in Core Flow | Regulatory |

## 5. Candidate Requirements (Pending — informational)

| ID | Title | Status | Note |
|----|-------|--------|------|
| — | (none) | — | No Pending FR/NFR is currently linked to BUC-001 or BUC-002. |

## 6. Out-of-Scope

- No FRs/NFRs linked to BUC-001 or BUC-002 are in `Rejected` status in the elicit doc.
- Inherited from elicit Section 1.3: web client, public location feeds, advertising features, social features beyond the trusted circle, third-party data sharing, location sharing with more than the explicitly invited contacts.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| — | — | No explicit dependency stated in the elicit doc. | — |

## 8. Success Metrics

| Metric | Target | Source |
|--------|--------|--------|
| Location update latency | End-to-end location update latency must be < 5 seconds at p95 under 10,000 concurrent sharing sessions. | NFR-001 |
| API authentication coverage | 100% of API endpoints return HTTP 401 for requests with no valid session token. Zero endpoints accessible without authentication in penetration test. | NFR-002 |
| Data retention | All location records with a timestamp older than 30 days from the current date must be automatically deleted within 24 hours of reaching that threshold. | NFR-003 |
| Battery impact | Background location polling must consume < 5% of device battery per hour when actively sharing, measured on iPhone 14 and Samsung Galaxy S23 under standard lab conditions. | NFR-004 |

## 9. Effort Estimate (AI provisional)

- **T-shirt size:** L
- **Heuristic applied:**
  - S — ≤ 2 In-Scope FRs and no Performance/Security NFR
  - M — 3–5 In-Scope FRs
  - L — 6–7 In-Scope FRs, or contains a Performance/Security NFR
  - XL — > 7 In-Scope FRs, or contains a Regulatory CON
- **Rationale:** 4 In-Scope FRs (would qualify for M on count alone) but the Epic contains a Performance NFR (NFR-001) and a Security NFR (NFR-002), promoting it to L per the heuristic.
- **Note:** AI estimate — confirm with team. Sizing is not derivable from the elicit doc and must be calibrated by the delivery team before commitment.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| OQ-005 | EP-001 was seeded by merging BUC-001 (Share Location) and BUC-002 (View Contact Location). Signal: shared cross-cutting NFRs NFR-001 and NFR-002 (2 of 2 in BUC-002's NFR set; same Primary Actor SH-001). Confirm the merger, or instruct to keep them as separate Epics. | High | Open | create-epics skill |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md
  merged-from: BUC-001, BUC-002

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-epics skill (initial run) | Initial seed — merged BUC-001 + BUC-002; OQ-005 raised to confirm merge |
