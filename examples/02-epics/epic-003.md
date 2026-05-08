---
artifact: epic
project: PocketPing
epic-id: EP-003
created: 2026-05-08
last-updated: 2026-05-08
status: Pending
owner: SH-001
priority: Should Have
effort: S
reviewed-by: —
approved-date: —
---

# EP-003: Place Notifications

> **Calibration example — not a real project.** This Epic was produced by `/create-epics` from `examples/01-elicitation/elicitation-document-example.md`. It is in `Status = Pending` — the human reviewer would either Accept it as-is or use OQ-006 (Section 10) to specify a measurable success metric for the geofence notification feature.
>
> **Status:** Pending | **Created:** 2026-05-08 | **Last Updated:** 2026-05-08
> **Owner:** SH-001 | **Priority:** Should Have | **Effort (AI estimate):** S
>
> Epics organise Accepted requirements from the Elicitation Document into outcome-shaped delivery containers. Cross-cutting NFRs may appear in more than one Epic; FRs may not.

---

## 1. Description

This Epic lets a user define named geographic boundaries ("Places") and receive a push notification when a trusted contact with an active sharing session enters or exits one of those boundaries. It is the primary value-add feature beyond raw location sharing — turning continuous coordinates into actionable arrive/leave events.

## 2. Business Value

Place notifications convert PocketPing from a "look at the map when I worry" tool into a passive safety tool — a parent does not have to keep checking the map to know the child arrived home. The Owner SH-001 has flagged this as a Should-Have feature in v1; the underlying BUC-004 was accepted by SH-001 on 2026-04-10 specifically as the value-add beyond core sharing.

## 3. Primary Business Use Cases

- BUC-004 — Place Notifications

## 4. In-Scope Requirements

> Only requirements with `Status = Accepted` in the Elicitation Document are listed here. Pending FRs/NFRs appear in Section 5 as Candidates. Rejected FRs/NFRs appear in Section 6.

### 4.1 Functional Requirements

| ID | Title | Priority | Source BUC |
|----|-------|----------|------------|
| FR-007 | Define a Place | Should Have | BUC-004 |
| FR-008 | Geofence Notification | Should Have | BUC-004 |

### 4.2 Non-Functional Requirements

| ID | Title | Category | Measurable Target | Cross-cutting? |
|----|-------|----------|-------------------|----------------|
| — | (none) | — | No Accepted NFR in the elicit doc references BUC-004 in its Business Use Case field. | — |

### 4.3 Constraints

| ID | Title | Type |
|----|-------|------|
| CON-001 | Platform Scope | Organizational |
| CON-002 | GDPR Applicability | Regulatory |
| CON-003 | No Third-Party Analytics in Core Flow | Regulatory |

## 5. Candidate Requirements (Pending — informational)

| ID | Title | Status | Note |
|----|-------|--------|------|
| — | (none) | — | No Pending FR/NFR is currently linked to BUC-004. |

## 6. Out-of-Scope

- No FRs/NFRs linked to BUC-004 are in `Rejected` status in the elicit doc.

## 7. Dependencies

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| — | — | No explicit dependency stated in the elicit doc. (FR-008 implicitly relies on an active sharing session from EP-001, but the elicit doc does not state this in any FR.Rationale or BUC.Trigger field; not invented here.) | — |

## 8. Success Metrics

| Metric | Target | Source |
|--------|--------|--------|
| — | (none derivable — no In-Scope NFR carries a measurable target for this Epic; FR-008 alone states a 60-second notification window in its description, but that is an FR threshold, not an NFR success metric.) | — |

## 9. Effort Estimate (AI provisional)

- **T-shirt size:** S
- **Heuristic applied:**
  - S — ≤ 2 In-Scope FRs and no Performance/Security NFR
  - M — 3–5 In-Scope FRs
  - L — 6–7 In-Scope FRs, or contains a Performance/Security NFR
  - XL — > 7 In-Scope FRs, or contains a Regulatory CON
- **Rationale:** 2 In-Scope FRs and no In-Scope Performance/Security NFR → S. Note: the Epic does inherit regulatory CON-002 (GDPR) as a system-wide constraint, but the heuristic's XL trigger reads "contains a Regulatory CON" in the in-scope set; this CON binds the location-data flows in EP-001/EP-002 more directly. The team should reassess if BUC-004's geofence pipeline is found to materially process retained location data.
- **Note:** AI estimate — confirm with team. Sizing is not derivable from the elicit doc and must be calibrated by the delivery team before commitment.

## 10. Open Questions

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| OQ-006 | EP-003 (Place Notifications) has no measurable success metrics — no Accepted NFR in the elicit doc references BUC-004 in its Business Use Case field. FR-008 mentions "within 60 seconds" in its description but that is an FR threshold, not an NFR-style KPI. What measurable target defines success for the geofence notification feature (e.g., delivery latency p95, false-positive rate, geofence accuracy)? | High | Open | create-epics skill |

## 11. Acceptance

- **Status:** Pending
- **Owner:** SH-001
- **Accepted By:** SH-001
- **Accepted Date:** —
- **Source:** elicitation-document.md

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | 2026-05-08 | create-epics skill (initial run) | Initial seed from BUC-004; OQ-006 raised on missing success metrics |
