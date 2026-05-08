---
artifact: epic
project: <!-- PROJECT_NAME -->
epic-id: <!-- EP-### -->
created: <!-- CREATION_DATE -->
last-updated: <!-- LAST_UPDATED_DATE -->
status: Pending
owner: <!-- SH-### -->
priority: <!-- Must Have / Should Have / Could Have / Won't Have -->
effort: <!-- S / M / L / XL (AI estimate) -->
reviewed-by: <!-- SH-### -->
approved-date: —
---

# <!-- EP-### -->: <!-- Epic Title -->

> **Status:** Pending | **Created:** <!-- CREATION_DATE --> | **Last Updated:** <!-- LAST_UPDATED_DATE -->
> **Owner:** <!-- SH-### --> | **Priority:** <!-- MoSCoW --> | **Effort (AI estimate):** <!-- S/M/L/XL -->
>
> Epics organise Accepted requirements from the Elicitation Document into outcome-shaped delivery containers. Cross-cutting NFRs may appear in more than one Epic; FRs may not.

---

## 1. Description

<!-- One paragraph in business terms: what outcome does this Epic deliver, for which stakeholder, under what conditions. Synthesised from the Primary BUC's description and the In-Scope FR titles. Do not duplicate FR-level detail. -->

## 2. Business Value

<!-- Why this Epic matters. Synthesised from the Primary BUC's Expected Outcome and the Owner stakeholder's Primary Concerns. If the elicit doc is thin here, an OQ (Severity=High) is logged in Section 10 — do not invent value statements. -->

## 3. Primary Business Use Cases

<!-- BUC-### links — one or more. If the Epic resulted from a merge, list every contributing BUC. -->

- BUC-### — <!-- Title -->

## 4. In-Scope Requirements

> Only requirements with `Status = Accepted` in the Elicitation Document are listed here. Pending FRs/NFRs appear in Section 5 as Candidates. Rejected FRs/NFRs appear in Section 6.

### 4.1 Functional Requirements

<!-- One row per Accepted FR linked to a Primary BUC of this Epic. FRs may not appear in more than one Epic. -->

| ID | Title | Priority | Source BUC |
|----|-------|----------|------------|
| FR-### | <!-- Title --> | <!-- MoSCoW --> | BUC-### |

### 4.2 Non-Functional Requirements

<!-- One row per Accepted NFR. Cross-cutting = Yes when this NFR is also In-Scope of another Epic (Business Use Case field references multiple BUCs, or "General"). -->

| ID | Title | Category | Measurable Target | Cross-cutting? |
|----|-------|----------|-------------------|----------------|
| NFR-### | <!-- Title --> | <!-- Performance / Security / Usability / Reliability / Scalability / Maintainability / Compliance --> | <!-- e.g. "p99 < 200 ms under 500 concurrent users" --> | Yes / No |

### 4.3 Constraints

<!-- One row per Accepted CON that binds any In-Scope FR/NFR of this Epic, or any system-wide CON (Type = Regulatory or Organizational). -->

| ID | Title | Type |
|----|-------|------|
| CON-### | <!-- Title --> | <!-- Technology / Regulatory / Budget / Timeline / Organizational --> |

## 5. Candidate Requirements (Pending — informational)

<!-- Pending FRs/NFRs linked to this Epic's Primary BUC(s). Listed for visibility; not yet In-Scope. They become In-Scope automatically on the next /create-epics run after the elicit doc accepts them. -->

| ID | Title | Status | Note |
|----|-------|--------|------|
| FR-### | <!-- Title --> | Pending | Promotes to In-Scope when Accepted in elicit doc |

## 6. Out-of-Scope

<!-- Explicit Rejected FRs/NFRs from the elicit doc (cited with reason), plus any "out of scope" items captured in elicit Section 1.3 that bind this Epic. -->

- FR-### — <!-- Title -->. Status = Rejected per elicit doc; reason: <!-- short reason -->.
- <!-- Other out-of-scope items inherited from elicit Section 1.3 -->

## 7. Dependencies

<!-- Only populate when the elicit doc explicitly states a dependency: e.g., FR.Rationale references another FR's BUC, or BUC.Trigger references another BUC's Expected Outcome. Do not invent dependencies. Cycles are flagged as Critical OQs. -->

| Type | Target | Reason | Source |
|------|--------|--------|--------|
| Depends on | EP-### | <!-- Specific reason from elicit doc --> | <!-- elicit element ID --> |
| Blocks | EP-### | <!-- ... --> | <!-- ... --> |

## 8. Success Metrics

<!-- Copy each measurable target VERBATIM from the In-Scope NFRs of this Epic. Do not paraphrase. If no In-Scope NFR carries a measurable target and the Epic Priority is Must Have: an OQ (Severity=High) is logged in Section 10 — do not invent metrics. -->

| Metric | Target | Source |
|--------|--------|--------|
| <!-- Quality attribute name --> | <!-- Exact threshold from NFR.Measurable Target --> | NFR-### |

## 9. Effort Estimate (AI provisional)

- **T-shirt size:** <!-- S / M / L / XL -->
- **Heuristic applied:**
  - S — ≤ 2 In-Scope FRs and no Performance/Security NFR
  - M — 3–5 In-Scope FRs
  - L — 6–7 In-Scope FRs, or contains a Performance/Security NFR
  - XL — > 7 In-Scope FRs, or contains a Regulatory CON
- **Rationale:** <!-- One sentence: which factor drove the size -->
- **Note:** AI estimate — confirm with team. Sizing is not derivable from the elicit doc and must be calibrated by the delivery team before commitment.

## 10. Open Questions

<!-- OQs raised by /create-epics that affect THIS Epic. The shared OQ-### namespace continues from the highest OQ-### in the elicit doc and across all other Epic files — IDs are never reused. The index.md aggregates all open OQs across all Epics. -->

| ID | Question | Severity | Status | Source |
|----|----------|----------|--------|--------|
| OQ-### | <!-- Question text --> | <!-- Critical / High / Medium / Low --> | Open | create-epics skill |

## 11. Acceptance

- **Status:** Pending
- **Owner:** <!-- SH-### -->
- **Accepted By:** <!-- SH-### (default: same as Owner) -->
- **Accepted Date:** —
- **Source:** elicitation-document.md
  <!-- If this Epic resulted from a merge or split in Step 4, add a line like:
       merged-from: BUC-001, BUC-002
       split-from: BUC-007 -->

## 12. Revision History

| Version | Date | Changed By | Changes |
|---------|------|-----------|---------|
| 1.0 | <!-- CREATION_DATE --> | create-epics skill (initial run) | Initial seed |
