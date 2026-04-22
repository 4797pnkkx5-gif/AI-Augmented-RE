# Audit Protocol: Elicitation Quality (AI-Agent Readable)

Protocol-ID: AP-ELIC-001
Version: 1.0.0
Date: 2026-04-22
Status: Active
Scope-Type: Framework Quality Audit
Target-Capability: Creation of high-quality elicitation documents
Execution-Mode: Read-only assessment of framework assets
Repository-Change-Rule: This protocol itself may be created; no other project files are modified by this implementation step.

## 1. Purpose

This protocol defines a deterministic, repeatable quality audit for the AI-Augmented-RE framework, focused only on elicitation-document creation quality.

Primary question:
Can this framework produce a high-quality elicitation document consistently across teams and runs?

## 2. Normative Language

The terms MUST, MUST NOT, SHOULD, SHOULD NOT, and MAY are normative.

## 3. Audit Scope

Included:
- Elicitation skill behavior
- Elicitation template completeness
- Governance instructions that shape elicitation quality
- Setup and sync behavior that affects quality-control propagation
- Practitioner guidance needed for repeatable elicitation quality

Excluded:
- Downstream skills (/create-epics, /create-stories, /create-srs, /create-tests, /trace), except where elicitation readiness directly affects traceability continuity.

## 4. Mandatory Evidence Set

The auditing agent MUST read all files below before issuing any control result.

- skills/elicit/skill.md
- skills/elicit/templates/elicitation-document.md
- AGENTS.md
- setup/AGENTS.md.template
- setup/CLAUDE.md.template
- setup.sh
- sync-framework.sh
- inputs/README.md
- docs/Learning/AIRE-Learning-Path.md
- artifacts/01-elicitation/.gitkeep

If any mandatory evidence file is unreadable or missing, mark protocol execution as Incomplete and stop before verdict generation.

## 5. Execution Workflow

1. Load evidence
- Read each mandatory file completely.
- Record evidence snippets for each control.

2. Evaluate controls
- Evaluate controls C-001 through C-012.
- Allowed status values: Pass, Partial, Fail.

3. Assign severity
- Use control baseline severity.
- Escalate one level if failure can invalidate approval integrity or traceability integrity.

4. Compute readiness score
- Map status to numeric value: Pass = 1.0, Partial = 0.5, Fail = 0.0.
- Compute weighted readiness:

  readiness = (sum(weight_i * score_i) / sum(weight_i)) * 100

5. Determine capability verdict
- Apply rules in Section 8 exactly.

6. Produce remediation roadmap
- For every Partial or Fail, produce at least one file-targeted, actionable remediation.

7. Produce final audit report
- Use the exact report structure in Section 9.

## 6. Control Catalogue

### Critical Controls

C-001: Assumptions Governance
- Weight: 10
- Baseline Severity: Critical
- Pass if:
  - Template contains explicit assumptions section with stable IDs and accountability fields.
  - Skill includes extraction/update/review handling for assumptions.
- Partial if:
  - Assumptions are mentioned but not managed as first-class entities.
- Fail if:
  - No explicit assumptions governance exists.

C-002: Risk Governance
- Weight: 10
- Baseline Severity: Critical
- Pass if:
  - Template contains explicit risk section with at least likelihood, impact, owner, mitigation.
  - Skill includes risk extraction/update/review behavior.
- Partial if:
  - Risks are implied but not operationally governed.
- Fail if:
  - No explicit risk governance exists.

C-003: NFR Measurability Enforcement
- Weight: 9
- Baseline Severity: Critical
- Pass if:
  - NFR measurable-target rule is explicit and enforceable.
  - Review gate explicitly flags unmeasurable NFRs.
- Partial if:
  - Template hints at metrics but no clear enforcement exists.
- Fail if:
  - NFRs can be accepted without measurable targets.

C-004: Acceptance-Criteria Completeness
- Weight: 9
- Baseline Severity: Critical
- Pass if:
  - AC coverage is required for all FR/NFR entries.
  - Skill performs pre-approval completeness checks.
- Partial if:
  - AC generation applies only to newly added requirements.
- Fail if:
  - No AC completeness governance exists.

### High Controls

C-005: AC Independent Testability
- Weight: 8
- Baseline Severity: High
- Pass if:
  - Rules require independently verifiable AC statements.
  - Review gate checks multi-condition and non-verifiable AC defects.
- Partial if:
  - Review mentions testability but lacks explicit criteria.
- Fail if:
  - No independent-testability control exists.

C-006: Structural Trace Linkage
- Weight: 8
- Baseline Severity: High
- Pass if:
  - Skill validates FR/NFR to BUC linkage.
  - Skill validates responsible stakeholder linkage.
  - Orphans are surfaced before approval.
- Partial if:
  - Linkage is present in schema but no validation step exists.
- Fail if:
  - Orphaned structures are not detectable by process.

C-007: Contradiction Detection Procedure
- Weight: 7
- Baseline Severity: High
- Pass if:
  - Review process includes explicit contradiction-detection method.
- Partial if:
  - Contradictions are listed as concern without method.
- Fail if:
  - Contradiction handling is absent.

C-008: Accepted-Element Immutability Enforcement
- Weight: 7
- Baseline Severity: High
- Pass if:
  - Immutability rule is present in framework governance and project-facing templates.
- Partial if:
  - Rule exists in only one layer.
- Fail if:
  - Rule is absent.

C-009: Governance Propagation Integrity
- Weight: 7
- Baseline Severity: High
- Pass if:
  - Setup and sync processes preserve quality-governance consistency, or provide controlled governance-update mechanism.
- Partial if:
  - Governance drift is possible but partially mitigated.
- Fail if:
  - Governance drift is likely and unmanaged.

### Medium Controls

C-010: Open-Question Governance Rigor
- Weight: 5
- Baseline Severity: Medium
- Pass if:
  - Policy distinguishes warning-only vs blocking unresolved OQs.
- Partial if:
  - OQ policy exists but lacks severity or escalation logic.
- Fail if:
  - OQ process is undefined.

C-011: Onboarding Sufficiency
- Weight: 5
- Baseline Severity: Medium
- Pass if:
  - Learning path references are complete and actionable.
- Partial if:
  - Learning path exists but has missing required material.
- Fail if:
  - No onboarding guidance exists.

C-012: Benchmark Artifact Availability
- Weight: 5
- Baseline Severity: Medium
- Pass if:
  - Repository contains at least one representative elicitation example artifact.
- Partial if:
  - Partial examples exist but not end-to-end calibrated.
- Fail if:
  - No benchmark elicitation artifact exists.

## 7. Evidence Recording Rules

For each control, auditor MUST record:
- Control-ID
- Status (Pass, Partial, Fail)
- Evidence references (file path + concise quote or fact)
- Impact statement (1-3 lines)
- Severity (baseline or escalated)
- Recommended remediation (file-targeted)
- Effort estimate (Low, Medium, High)

No control may be marked Pass without at least one direct evidence reference.

## 8. Capability Verdict Rules

Verdict classes:
- Not-Capable
- Conditionally-Capable
- Capable
- Strongly-Capable

Decision logic:

1) Not-Capable if:
- any Critical control is Fail, or
- readiness < 70

2) Conditionally-Capable if:
- no Critical Fail, and
- 70 <= readiness < 85

3) Capable if:
- no Critical Fail, and
- 85 <= readiness < 92, and
- High Fail count <= 1

4) Strongly-Capable if:
- no Critical Fail, and
- readiness >= 92, and
- High Fail count = 0

## 9. Required Report Structure

The audit report MUST follow this exact section order.

1. Audit Verdict
- Include readiness score and verdict class.

2. Control Results Table
- One row per control C-001..C-012.
- Columns: Control-ID | Status | Severity | Evidence | Impact | Remediation | Effort

3. Findings by Severity
- Ordered: Critical, High, Medium, Low
- Each finding includes clear rationale and affected files.

4. Capability Statement
- Explicitly answer:
  - Is high-quality elicitation creation possible now?
  - Is it expert-dependent or process-repeatable?

5. Remediation Roadmap
- Priority tiers:
  - P0: Critical
  - P1: High
  - P2: Medium/Low
- Include sequence and rationale.

6. Re-Audit Checklist
- Concrete pass/fail checks to validate remediation effectiveness.

## 10. Machine-Readable Summary Block

Auditing agent SHOULD append a JSON block using this schema.

{
  "protocol_id": "AP-ELIC-001",
  "readiness_score": 0,
  "verdict": "Not-Capable|Conditionally-Capable|Capable|Strongly-Capable",
  "controls": [
    {
      "id": "C-001",
      "status": "Pass|Partial|Fail",
      "severity": "Critical|High|Medium|Low",
      "evidence": ["path: fact"],
      "impact": "string",
      "remediation": "string",
      "effort": "Low|Medium|High"
    }
  ],
  "critical_fail_count": 0,
  "high_fail_count": 0,
  "incomplete": false
}

## 11. Precision Constraints

Auditing agent MUST NOT:
- infer compliance from intent statements without operational mechanism
- mark Pass when evidence is indirect or ambiguous
- merge multiple controls into one result
- omit remediation for Partial or Fail outcomes

Auditing agent MUST:
- keep evidence traceable to repository files
- preserve deterministic scoring and verdict logic
- distinguish framework capability from reliance on human expert skill

## 12. Completion Criteria

Protocol execution is complete only when all conditions are true:
- All 12 controls evaluated
- Readiness score computed
- Verdict assigned via Section 8 rules
- Findings ordered by severity
- Remediation roadmap produced with file-level targeting
- Re-audit checklist provided

If any condition is not met, mark output as Incomplete.
