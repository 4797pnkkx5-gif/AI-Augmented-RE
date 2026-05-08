# Skill: create-srs

**Purpose:** Compile a single Software Requirements Specification (`artifacts/04-srs/srs.md`) modelled on IEEE 29148:2018 from the Elicitation Document, the Accepted Epic set, and every Accepted Story under those Epics. The SRS lifts FRs / NFRs / CONs / ACs / Stories verbatim from upstream artefacts and adds three skill-generated sections: Introduction (purpose, scope, glossary, references), Overall Description (product perspective, user classes, assumptions, risks), and a comprehensive Traceability Matrix. Re-runs are idempotent: Pending SRS sections are refined in place, an Accepted SRS is immutable (only review notes appended), and the skill never invents functional content.

**Invocation:**
- Claude Code: `/create-srs`
- GitHub Copilot: "Run the create-srs skill" or "Follow `skills/create-srs/skill.md`"

**Inputs:**
- `artifacts/01-elicitation/elicitation-document.md` (`status: Approved`) — FRs, NFRs, CONs, ACs, ASMP, RSK, Stakeholders, BUCs, optional Section 4 architecture
- `artifacts/02-epics/epic-*.md` — Accepted Epics drive scope; Pending and Rejected Epics are not in the SRS
- `artifacts/03-user-stories/story-*.md` — Every Story whose `parent-epic` is an Accepted Epic must have `status: Accepted` for the gate to pass
- `inputs/APIs/*.yaml` (optional) — drives Section 7 (External Interfaces)
- `inputs/manifest.md` (if present) — drives Section 1.4 (References)
- `artifacts/04-srs/srs.md` (existing, if any) — read for re-run semantics

**Outputs:**
- `artifacts/04-srs/srs.md` — single consolidated document

---

## Step 0 — Approval gate (strict per Accepted Epic)

The SRS is a **settled, formal artefact**. It runs only when every Story belonging to an Accepted Epic has been Accepted by the human Product Owner. The reasoning: the SRS becomes the contract that downstream phases (`/create-tests`) depend on — including a Pending Story in the SRS would force a re-publish on every Story Acceptance, defeating the purpose of a "specification".

Read `artifacts/02-epics/epic-*.md` and `artifacts/03-user-stories/story-*.md`.

- If `artifacts/02-epics/` is missing or contains no Epics: stop. "Run `/create-epics` first."
- If no Epic has `status: Accepted`: stop. "No Accepted Epics — run `/create-epics` and have the Product Owner accept at least one Epic before invoking `/create-srs`."
- For every Story whose `parent-epic` references an Accepted Epic: verify `status: Accepted`. If any such Story is `Pending` or `Rejected`: stop. List the offending US-### IDs and their parent Epics. Tell the user:
  > Some Stories under Accepted Epics are not yet Accepted: `<list>`. The SRS is a settled artefact — every Story under an Accepted Epic must be Accepted before the SRS can be compiled. Have the Product Owner accept (or reject) the listed Stories in `/create-stories`, then re-run.

Defensive checks (the gate has held upstream but the skill still verifies):

- Elicitation Document at `artifacts/01-elicitation/elicitation-document.md` exists with `status: Approved`.
- No Critical OQ from any earlier phase is `Open` in any artefact.

Stories whose `parent-epic` is `Pending` or `Rejected` are not in scope. They are listed in Section 9 (Traceability Matrix) of the SRS as `Deferred` rather than blocking the gate. Likewise, FRs whose parent BUC is in a non-Accepted Epic are deferred. The SRS is **partial-by-Epic** by design: it covers exactly the Accepted Epic set, not the full elicit doc.

---

## Step 1 — Read every upstream artefact

| Source | What to extract |
|--------|-----------------|
| Elicitation Document | Project name + version, Section 1 (Background, Problem Statement, Scope), Stakeholders (SH-### with Role + Primary Concerns), BUCs (Description, Primary Actor, Trigger, Expected Outcome), FRs / NFRs / CONs (every field), Section 4 Component / Sequence diagrams, Section 5.4 Assumptions, Section 5.5 Risks, Section 6 Acceptance Criteria, OQs (open + resolved) |
| Accepted Epic files | EP-### → Title, Description, Business Value, In-Scope FRs / NFRs / CONs, Cross-cutting NFR set, Source field (merged-from / split-from notes), Owner |
| Accepted Story files (under Accepted Epics) | US-### → Title, Connextra narrative, Parent FR, Parent Epic, Owner, Story Points, Dependencies, Implementation Notes |
| `inputs/APIs/*.yaml` | Service name, base URL, endpoints, schemas — for Section 7 |
| `inputs/manifest.md` | List of every input document processed by `/elicit` — for Section 1.4 References |

Compute the **eligible scope**:

- **Eligible FRs:** FRs with `Status = Accepted` in elicit doc AND linked (via `Business Use Case`) to a BUC that is the Primary BUC of an Accepted Epic.
- **Eligible NFRs:** NFRs with `Status = Accepted` AND whose `Business Use Case` field includes at least one BUC of an Accepted Epic. Cross-cutting NFRs spanning multiple Accepted Epics are listed once in Section 5 with the cross-cutting flag.
- **Eligible CONs:** every Accepted CON. Constraints are inherently system-wide.
- **Eligible ACs:** every AC whose parent FR/NFR is eligible.
- **Eligible Stories:** Accepted Stories under Accepted Epics (already verified in Step 0).
- **Deferred elements:** Stakeholders, BUCs, FRs, NFRs, ACs that are not eligible (their parent Epic is Pending/Rejected, or their Status is not Accepted). Listed in Section 9 with explicit `Deferred` status — not in Sections 3–8.

---

## Step 2 — Read existing `srs.md`

If `artifacts/04-srs/srs.md` exists:

- Parse its YAML frontmatter. Capture `status`, `version`, `last-updated`, and the existing OQ-### counter.
- If `status: Accepted`: the document is **immutable**. Do not regenerate Sections 1–8 or any acceptance fields. Compute the latest Traceability Matrix (Section 9) — that section is informational and may be refreshed even on Accepted SRS — and append a review note to Section 10 (Revision History): `Note YYYY-MM-DD: re-run on upstream update — human review of this SRS recommended.` No further changes.
- If `status: Pending` (or absent — first run): regenerate Sections 1–9 from scratch using current upstream state. Increment the version (1.0 → 1.1 → ...). Append a Revision History row.

Note the highest existing OQ-### across the elicit doc, every Epic file, every Story file, and the existing SRS. New OQs created by `/create-srs` continue from `max + 1`.

---

## Step 3 — Generate Section 1 (Introduction)

Net-new content — the elicit doc does not provide this section directly. Synthesise from upstream sources but **never invent**.

### 1.1 Purpose

One paragraph synthesised from elicit Section 1.1 (Background) and 1.2 (Problem Statement). State who this SRS is for (the project's delivery team and stakeholders) and what it documents (the requirements that must be met for the project to be considered complete).

### 1.2 Scope

Lift elicit Section 1.3 (In scope / Out of scope) verbatim. Add a closing sentence noting which Accepted Epics this SRS covers (by EP-ID) — this signals SRS-as-partial-by-Epic.

### 1.3 Definitions and Acronyms

Glossary table. Build by scanning every upstream artefact for abbreviations (any all-caps token of length 2–6, e.g., `BUC`, `SRS`, `RFC 2119`, `GDPR`, `OWASP`). For each abbreviation found:

- If it is defined inline anywhere in the elicit doc (e.g., "Transport Layer Security (TLS)"): use the upstream definition.
- If it is a framework abbreviation (BUC, FR, NFR, CON, ASMP, RSK, AC, OQ, EP, US, SH, COMP, SEQ): use the standard expansion.
- If it is a domain abbreviation that is NOT defined upstream: generate `OQ Severity=Medium`: `"<acronym> appears in the upstream artefacts but is not defined. Add a definition to the elicit doc Section 1 or to Section 1.3 of this SRS."`

Sort alphabetically.

### 1.4 References

Numbered list of every input document that contributed to the upstream artefacts:

1. The Elicitation Document itself (path + version + approved date)
2. Every row from `inputs/manifest.md` (filename + first-processed date)
3. Every Accepted Epic file
4. Every Accepted Story file
5. Normative external references: RFC 2119 (key words), IEEE 29148:2018 (this SRS structure), and any standards cited in NFRs (e.g., "OWASP ASVS Level 2", "Signal Protocol v3", "WCAG 2.1 AA")

### 1.5 Overview

One sentence per remaining section (2 through 9). Tells the reader what to expect.

---

## Step 4 — Generate Section 2 (Overall Description)

Net-new section. Synthesises the project's high-level shape from upstream sources.

### 2.1 Product Perspective

One paragraph. If elicit Section 4 has a Component Overview (COMP-001): summarise the diagram in prose ("the system comprises a `<list of components>` deployed as `<deployment shape if stated>`"). If absent: write "The product is a self-contained system described by the BUCs in Section 3 of this SRS." Insert the Mermaid diagram from elicit Section 4.0 inline if present.

### 2.2 User Classes

Group elicit Section 2 (Stakeholders) by Role similarity. Each user class has:

- Class name (the Role)
- Stakeholder IDs in this class (SH-### list)
- Primary Concerns (union of the SHs' Primary Concerns)
- BUCs they engage with (from each BUC's `Primary Actor` or `Stakeholders` field)

### 2.3 Operating Environment

Lift CONs of Type = Technology or Type = Platform from elicit Section 5.3. State each in plain prose ("The system shall run on `<platform>`").

### 2.4 Design and Implementation Constraints

Lift CONs of Type = Regulatory or Type = Organizational. State each constraint and its origin. (System-wide implication of these CONs — e.g. GDPR — is that they bind every FR in Section 4.)

### 2.5 Assumptions and Dependencies

Lift elicit Section 5.4 (Assumptions) verbatim. Each ASMP is listed with: Description, Owner, Status, Impact if Wrong.

### 2.6 Risks

Lift elicit Section 5.5 (Risks) verbatim. Each RSK is listed with: Description, Likelihood/Impact, Owner, Mitigation, Status.

---

## Step 5 — Generate Sections 3–8 (consolidation)

These sections **lift content verbatim** from upstream. The skill is a curator, not an author.

### Section 3 — System Features (Epics + Stories)

For each Accepted Epic, in EP-### order:

- Sub-heading: `EP-### — <Title>`
- One paragraph: Epic Description + Business Value (lifted)
- Sub-list of Stories under this Epic: each US-### with its narrative ("As a / I want / so that") and parent FR. Story Points and dependencies are summarised ("US-001 (5 pts, depends on US-003)").

### Section 4 — Functional Requirements

Lift every eligible FR verbatim from elicit Section 5.1. Each FR row includes ID, Title, Description (RFC 2119), Priority, Source BUC, Stakeholder, Source, Acceptance Criteria reference, Status. Group by Priority (Must Have first, then Should, Could, Won't) for readability.

### Section 5 — Non-Functional Requirements

Lift every eligible NFR verbatim from elicit Section 5.2. Each NFR row includes ID, Title, Description, Category, Priority, Measurable Target, Business Use Case scope, Cross-cutting? flag, Status. Cross-cutting NFRs are listed once with the full BUC scope shown.

### Section 6 — Constraints

Lift every Accepted CON verbatim from elicit Section 5.3. Each CON row includes ID, Description, Type, Impact, Source.

### Section 7 — External Interfaces

Driven by `inputs/APIs/*.yaml`. For each YAML file:

- Sub-heading: service name (from `info.title`)
- Base URL (from `servers[0].url`)
- Endpoints table: HTTP method, path, `operationId`, summary
- Key schema names from `components/schemas`

If `inputs/APIs/` is empty or absent: write "No external interfaces are defined for this system. If the system integrates with external services, add OpenAPI YAML files to `inputs/APIs/` and re-run `/elicit` followed by `/create-srs`."

### Section 8 — Acceptance Criteria

Lift every eligible AC verbatim from elicit Section 6 (Given / When / Then for FR ACs; Criterion for NFR ACs). Group by parent FR / NFR. Preserve AC IDs and acceptance fields (Status, Accepted By, Accepted Date) — these belong to the elicit doc, not the SRS.

---

## Step 6 — Generate Section 9 (Traceability Matrix)

Net-new section, always rebuilt every run. Covers the full forward and backward chain:

| Stakeholder | BUC | FR | NFR | Constraint | Epic | Story | AC | Test Case |
|-------------|-----|-----|-----|-----------|------|-------|-----|----------|
| SH-001 | BUC-001 | FR-001 | NFR-001 | CON-001 | EP-001 | US-001 | AC-FR-001-01 | — |

One row per leaf path from the SH → ... → AC chain. The Test Case column is reserved for `/create-tests` (Phase 5) and remains `—` until that skill has run.

Below the matrix:

- **Coverage stats:** Stakeholders / BUCs / FRs / NFRs / CONs / Epics / Stories / ACs counts, separated into "in this SRS" and "Deferred" (Pending / Rejected upstream).
- **Orphan checks:** every eligible FR has at least one AC; every eligible NFR has at least one AC; every Story has a parent FR; every Epic has at least one Story; every Stakeholder owns at least one BUC. Each orphan generates `OQ Severity=High`.

---

## Step 7 — Validation

Run every check; add OQs at the indicated severity.

1. **FR coverage:** every Accepted FR linked to an Accepted Epic appears in Section 4. Missing → `Critical`.
2. **NFR coverage:** every Accepted NFR with a BUC in any Accepted Epic appears in Section 5. Missing → `Critical`.
3. **CON coverage:** every Accepted CON appears in Section 2.4 or Section 6 (depending on Type). Missing → `Critical`.
4. **Story coverage:** every Accepted Story (under an Accepted Epic) appears in Section 3 under its parent Epic. Missing → `Critical`.
5. **AC coverage:** every eligible AC appears in Section 8. Missing → `Critical`.
6. **Glossary completeness:** every abbreviation that appears more than once in upstream artefacts is defined in Section 1.3. Missing → `Medium` (informational; doesn't block APPROVED).
7. **External Interface coverage:** if `inputs/APIs/` contains YAML files, Section 7 lists each one. Missing → `High`.
8. **Orphan checks** (per Step 6): Each → `High`.

Add a one-line summary to Section 10 (Revision History): `"Validation: [N] OQs added across coverage / glossary / orphan checks."`

---

## Step 8 — Write outputs and present the review gate

1. Write `artifacts/04-srs/srs.md` from `skills/create-srs/templates/srs.md`. If existing srs.md is `Pending`: rewrite. If `Accepted`: rewrite only Section 9 (Traceability Matrix) and Section 10 (Revision History); leave Sections 1–8 untouched.
2. Update frontmatter `last-updated` to today and `version` to next minor (1.0 → 1.1 → ...).
3. Append a Revision History row.

Present to the user:

> **Changes in this run:**
> - **REGENERATED:** [Sections 1–9 if this was a fresh build OR a Pending-state refresh]
> - **APPENDED:** [review note + traceability matrix refresh if previous SRS was Accepted]
> - **COVERAGE:** N FRs / M NFRs / K CONs / J Stories / I ACs in scope; D items deferred (parent Epic Pending or Rejected)
> - **EXTERNAL INTERFACES:** [N OpenAPI YAMLs processed; OR "no APIs/ folder content"]
> - **GLOSSARY:** N entries; missing definitions: [list any acronyms still without entries]

If any OQs remain Open:
> **Warning — Unresolved Open Questions:** [table of open OQs with Severity column]

Then give your **Professional Assessment** — cite specific element IDs:

**Blocking — APPROVED is invalid until resolved:**
- Critical OQs still Open: list OQ-### IDs.
- Coverage gaps (FR / NFR / CON / Story / AC missing from the SRS): list IDs.

**Advisory — flag before approval:**
- High-severity OQs (orphans, External Interface gaps): list IDs.
- Stakeholders / BUCs / FRs deferred (parent Epic not yet Accepted): list IDs and recommend running `/create-stories` then `/create-srs` again after Acceptance.
- Glossary terms missing definitions: list acronyms.

If none of these issues exist: state `"No quality concerns — SRS is ready for approval."`

> Review `artifacts/04-srs/srs.md` start-to-finish. Type **APPROVED** to mark the SRS as the project's settled specification (and proceed to `/create-tests`), or provide corrections.
> **Approval is invalid if any Critical OQ is Open or any coverage gap remains.**

On APPROVED: update srs.md frontmatter `status: Accepted`. State `"SRS phase complete. You may now run /create-tests."` Do not invoke the next skill automatically.

---

## ID Reference

| Artifact | Format | Example | Source |
|----------|--------|---------|--------|
| Open Question | OQ-### | OQ-021 | continues from elicit + epic + story namespaces |

The SRS itself does not mint new IDs (FRs, NFRs, etc. are inherited verbatim). OQ-### is the only namespace this skill writes into. IDs are never reused.

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| `artifacts/02-epics/` missing or empty | Stop in Step 0. "Run `/create-epics` first." |
| No Accepted Epics | Stop in Step 0. "Have the human accept at least one Epic in `/create-epics`." |
| Accepted Epic with at least one Pending Story | Stop in Step 0. List the offending Story IDs. |
| Elicit doc regressed (status no longer Approved) | Stop in Step 0. Tell user to re-Approve in `/elicit`. |
| `inputs/APIs/` absent | Section 7 contains the "No external interfaces" placeholder. |
| OpenAPI YAML is malformed | Skip that file with a warning in Section 7; generate `OQ Severity=Medium`. |
| Existing srs.md is corrupted (cannot parse frontmatter) | Treat as first run; back up the corrupted file as `srs.md.bak-YYYY-MM-DD` before overwriting. |
| Human edited srs.md manually between runs | Read current state as truth; on Pending status, the skill regenerates per Step 8 and any manual edits are overwritten — warn the user in the review gate. On Accepted status, only Section 9 is regenerated; manual edits to Sections 1–8 are preserved. |
| All eligible elements were already covered in the previous run; nothing has changed | Run completes; Section 9 is rebuilt; review gate reports `No changes — SRS up to date.` |
