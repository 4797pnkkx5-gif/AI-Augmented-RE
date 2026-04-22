# Skill: elicit

**Purpose:** Synthesise all available input documents into the Elicitation Document. Every run reads all inputs — new and existing — and updates the document to reflect the best current understanding. New information can refine existing requirements, resolve open questions, and improve architecture diagrams.

**Invocation:**
- Claude Code: `/elicit`
- GitHub Copilot: "Run the elicit skill" or "Follow `skills/elicit/skill.md`"

**Inputs:**
- All files in `inputs/` and sub-folders (Markdown, PDF, DOCX, plain text, YAML, JSON)
- OpenAPI YAML files in `inputs/APIs/` (for architecture diagrams)

**Outputs:**
- `artifacts/01-elicitation/elicitation-document.md` (created or updated)
- `inputs/manifest.md` (updated as audit log)

---

## Step 1 — Read all inputs

Read every input file now. Do not skip files that appear in the manifest — all files contribute to the synthesis.

**1a.** Read every file in `inputs/APIs/`. For each OpenAPI 3.x YAML, extract:
- Service name (`info.title`)
- Endpoints: path + HTTP method + `operationId`
- Inter-service dependencies (server URLs referencing other services)
- Key schema names from `components/schemas`

**1b.** Read every other file in `inputs/` recursively, excluding `inputs/README.md` and `inputs/manifest.md`. Extract from each file:

| What to extract | How |
|----------------|-----|
| Stakeholders | Name, role, organisation, concerns, contact |
| Business-level needs | What the system must enable — not implementation details |
| Functional requirements | "The system shall / must / should" statements |
| Non-functional requirements | Performance, security, usability, reliability, compliance targets with measurable values where stated |
| Constraints | Technology mandates, regulatory rules, budget/timeline limits |
| Assumptions | Statements treated as true without current verification — technology choices, external dependency availability, regulatory stability, stakeholder availability |
| Risks | Conditions or events that could prevent achieving goals — technical risks (integration, platform instability), delivery risks (timeline, external team dependencies), quality risks (insufficient test capacity), business risks (regulatory change, stakeholder availability) |
| Ambiguities and conflicts | Anything unclear, contradictory, or undefined → candidate Open Questions |
| Responsible stakeholder | For each BUC, FR, NFR, CON, ASMP, RSK: which stakeholder owns it |

Tag every extracted item with its source filename.

If no input files exist anywhere in `inputs/`: stop and tell the user to add documents.

---

## Step 2 — Read the existing document

Open `artifacts/01-elicitation/elicitation-document.md`.

- **File exists:** read the full content. For every element (SH, BUC, FR, NFR, CON, ASMP, RSK, OQ, COMP, SEQ), note: its ID, current description, Status, Accepted By, and Accepted Date.
- **File does not exist:** load the template at `skills/elicit/templates/elicitation-document.md`. Replace `<!-- PROJECT_NAME -->` with the project name inferred from inputs. Replace date placeholders with today's date. All subsequent steps treat this as a new empty document.

Note the highest existing ID in each namespace: SH-xxx, BUC-xxx, FR-xxx, NFR-xxx, CON-xxx, ASMP-xxx, RSK-xxx, OQ-xxx, SEQ-xxx.

---

## Step 3 — Synthesise requirements

For each item extracted in Step 1b, find the best matching element already in the document using semantic meaning and source file:

**Match found — Status is Pending:**
Update the element to reflect the improved synthesis:
- Sharpen the description if new inputs make it more precise or complete
- Update measurable targets on NFRs if new inputs specify concrete values
- Add the new source filename to the Source field if it contributes new detail
- Do not change the ID

**Match found — Status is Accepted or Rejected:**
Do not modify the element. Append this note below it:
> `Note [YYYY-MM-DD] ([source file]): new information may affect this element — human review recommended.`

**No match found — this is new content:**
Assign the next available ID in the appropriate namespace. Populate all fields. Set Status=Pending, Accepted By = responsible SH-xxx, Accepted Date=—.

Apply this logic for: Stakeholders, Business Use Cases, Functional Requirements, Non-Functional Requirements, Constraints, Assumptions, Risks.

**ASMP synthesis:** For ASMP entries with Status = Pending: apply the same match/refine logic. Status values are Pending | Validated | Invalidated — protect Validated/Invalidated; append review note only. For any ASMP with no Owner (SH-xxx): add OQ Severity=High: "ASMP-xxx has no assigned owner — who is accountable for validating this assumption?"

**RSK synthesis:** For RSK entries with Status = Pending: apply the same match/refine logic. Status values are Pending | Mitigated | Accepted | Closed — protect Mitigated/Accepted/Closed; append review note only. For RSK with Mitigation field blank or "TBD": add OQ Severity=High: "RSK-xxx has no mitigation — what action will reduce this risk?" For RSK with no Owner: add OQ Severity=High: "RSK-xxx has no assigned owner — who is accountable for this risk?"

**NFR measurability enforcement (C-003):** After synthesising each new or updated Pending NFR, check whether the Measurable Target field contains a concrete metric (a number, threshold, percentage, latency value, count, or named standard such as "WCAG 2.1 AA" or "OWASP Top 10"). If the field is empty, contains only qualitative language ("fast", "secure", "reliable", "easy", "user-friendly"), or is a placeholder:
- Generate an OQ Severity=Critical: "NFR-xxx has no measurable target. What is the specific, testable threshold for [quality attribute]? Example: 'p99 response time < 200ms under 500 concurrent users'."
- Set the NFR's Measurable Target field to: `PENDING — see OQ-xxx`

This check applies to both new NFRs and existing Pending NFRs whose Measurable Target is empty or unquantified.

**Structural validation (C-006):** After all synthesis is complete, run three checks. Add OQs for any violations:

1. **FR/NFR orphan check:** Every Pending FR/NFR must reference at least one BUC-xxx in its Business Use Case field. If the field is empty, "—", or "General" without a BUC-xxx: add OQ Severity=High: "FR-xxx (or NFR-xxx) has no linked Business Use Case — which BUC does this requirement serve?"
2. **Owner check:** Every Pending FR/NFR/BUC must have Accepted By (SH-xxx) populated. If empty or "—": add OQ Severity=Critical: "FR-xxx (or NFR-xxx / BUC-xxx) has no assigned stakeholder owner — who is accountable for this element?"
3. **BUC coverage check:** Every BUC-xxx should have at least one FR-xxx referencing it in the Business Use Case field. If none: add OQ Severity=Medium: "BUC-xxx has no linked functional requirements — is this use case decomposed into FRs?"

Add one summary line to the changelog: "Structural validation: [N] OQs added for orphans/missing owners."

---

## Step 4 — Resolve open questions

For every Open Question (Status = "Open") in the document:

1. Check the question against all extracted content from Step 1.
2. If an answer is found: set Status = "Resolved", write the answer, cite the source file.
3. If partially answered: set Status = "Partially Resolved", note what remains unclear.
4. If a new input creates a conflict between two sources: add a new OQ flagging the conflict, citing both files.

**OQ severity assignment:** For every OQ created in Steps 3 and 4 (new or updated), assign a Severity value using these rules:
- OQ created because an NFR has no measurable target → Critical
- OQ created because of a contradiction between elements → Critical
- OQ created because an FR, NFR, or BUC has no assigned owner → Critical
- OQ created because an FR/NFR has no BUC link → High
- OQ created because a BUC has no linked FRs → Medium
- OQ created because of a missing architecture diagram → High
- All other OQs → Medium unless context warrants otherwise

**Contradiction scan (C-007):** After resolving existing OQs and before adding remaining ambiguity OQs, scan for contradictions:

1. **FR vs FR (same BUC):** Group FRs by BUC. Within each group, check pairs: does one FR require an outcome or state that another FR explicitly prohibits or makes impossible? If yes: add OQ Severity=Critical: "FR-xxx and FR-yyy conflict — [describe the specific contradiction]. How should this be resolved?"
2. **NFR vs NFR (same category and operation):** Check whether two NFRs in the same category (e.g., Performance) specify conflicting measurable targets for the same operation or endpoint. Flag for human judgment — do not auto-resolve. Add OQ Severity=Critical if found.
3. **FR vs CON:** Check each CON against all FRs. If any FR requires something a constraint explicitly prohibits: add OQ Severity=Critical: "FR-xxx requires [action/state] but CON-yyy prohibits it — how should this be resolved?"

If no contradictions found: add one line to the changelog: "Contradiction scan: no contradictions detected."

For each remaining ambiguity from Step 1 extraction that is not already an open question: add a new row with the next OQ-xxx ID and assign appropriate Severity.

---

## Step 5 — Update BUC diagram

In Section 3.0, update the Mermaid `flowchart LR` diagram:
- Add actor nodes for any stakeholder not yet in the diagram
- Add BUC nodes inside `subgraph SYS` for any BUC not yet in the diagram
- Add arrows for new actor-to-BUC relationships
- Never remove existing nodes or arrows

---

## Step 6 — Update architecture diagrams

This step always runs.

**6a. Check for Section 4.** Search the document for `## 4. System Architecture Overview`.

If absent:
1. Rename headings: `## 4.` → `## 5.`, `## 5.` → `## 6.`, `## 6.` → `## 7.`, `## 7.` → `## 8.`, `## 8.` → `## 9.`, `## 9.` → `## 10.`
2. Update internal cross-references (e.g. "See Section 5 —" for requirements).
3. Insert `## 4. System Architecture Overview` after the last line of Section 3.

**6b. Component Overview (COMP-001).** Using the API data from Step 1a:

Generate (or regenerate if not Accepted) a Mermaid `flowchart LR` diagram:
- One rectangular node per service inside `subgraph SYS["<project name>"]`
- Client/mobile apps as `([...])` nodes outside the subgraph
- Arrows between services where one calls another, labelled with protocol (HTTP, gRPC, Event, DB)
- Node labels: 2–4 words maximum

If no API YAML was found: insert a placeholder and add OQ: "Component diagram is missing. Place OpenAPI YAML files in `inputs/APIs/` and re-run `/elicit`."

Set or keep: **Status:** Pending (if not already Accepted) | **Accepted By:** tech lead or most relevant SH-xxx | **Accepted Date:** —

**6c. Sequence Diagrams (SEQ-001, SEQ-002, ...).** Using the API data from Step 1a:

For each service (or BUC with multi-step component interaction), generate or update the sequence diagram:
- `sequenceDiagram` syntax
- Participants: Client + the service + any services it calls
- Messages: `operationId` values, or `METHOD /path` if no operationId
- Happy path only

For diagrams that already exist and are NOT Accepted: replace with current version derived from API YAML.
For diagrams that are Accepted: append `> Note [YYYY-MM-DD]: API definition updated — human review of this diagram recommended.`
For BUCs with no API YAML: add OQ if one does not already exist.

Assign new SEQ-xxx IDs for any diagrams that are genuinely new.

---

## Step 7 — Acceptance Criteria

**AC completeness check (C-004):** Scan Section 5.1 and 5.2 for ALL FRs and NFRs with Status = Pending. For each, check Section 6 for the existence of at least one entry with ID matching `AC-[parent ID]-01`. If a Pending FR or NFR has no AC entry at all:
- FR: generate at least one Given/When/Then entry in nested bullet format
- NFR: generate one Criterion entry — copy the exact measurable threshold string from the NFR's Measurable Target field verbatim

Exceptions: do not generate ACs for requirements with Status = Accepted or Rejected (frozen). Do not generate ACs for NFRs where Measurable Target = `PENDING — see OQ-xxx` (blocked until OQ resolved — add placeholder comment instead: `<!-- AC cannot be generated until OQ-xxx is resolved — NFR-xxx has no measurable target -->`).

Set Status=Pending, Accepted By = same SH-xxx as the parent requirement.

**AC independent testability rule (C-005):** Before writing any AC, validate:
1. If the Then clause contains two independent observable outcomes joined by AND (testing separate features or states): split into two ACs.
2. Each AC must be independently executable — its Given must establish a complete, reproducible starting state without relying on another AC's post-condition.
3. NFR ACs: the Criterion field must copy the exact measurable threshold from the parent NFR's Measurable Target verbatim — do not paraphrase.

Apply this rule to every AC generated in this step. If splitting is needed, assign the next available AC-[parent]-## ID for the new entry.

Never modify existing AC entries whose Status is Accepted or Rejected.

Add summary: "AC completeness: [N] ACs generated for [list FR/NFR IDs that had no prior AC]."

---

## Step 8 — Rebuild Acceptance Status Overview

Replace Section 8 (Acceptance Status Overview) entirely. Build ten grouped tables from the current acceptance fields:

1. Stakeholders  2. Business Use Cases  3. Component Overview  4. Sequence Diagrams
5. Functional Requirements  6. Non-Functional Requirements  7. Constraints  8. Assumptions
9. Risks  10. Acceptance Criteria

One row per element. This section is always fully replaced — never merged.

---

## Step 9 — Write outputs

1. Set `last-updated` in the YAML frontmatter to today's date.
2. Append to Section 10 (Revision History): next version number, today's date, "elicit skill", one-line summary of what changed.
3. Write the complete document to `artifacts/01-elicitation/elicitation-document.md`.
4. For each input file not yet in `inputs/manifest.md`: append a row with today's date and mode "initial" (first run) or "incremental" (subsequent). In the Notes column, record any OQs resolved by this file.

---

## Step 10 — Review gate

Present to the user:

> **What changed in this run:**
> - [refined requirements: list FR/NFR IDs that were updated]
> - [new elements: list new IDs added]
> - [resolved OQs: list OQ IDs resolved]
> - [architecture: Section 4 added / diagrams updated / no change]
> - [review notes added to Accepted elements: list IDs]

If any OQs remain Open:
> **Warning — Unresolved Open Questions:** [table of open OQs with Severity column]
> Critical OQs block approval. High/Medium/Low OQs do not block but will affect downstream artifacts.

Then give your **Professional Assessment** — cite specific element IDs:

**Blocking — APPROVED is invalid until resolved:**
- NFRs with no measurable target (Measurable Target = `PENDING — see OQ-xxx` or still qualitative): list NFR-xxx IDs. State: "These NFRs CANNOT be approved in their current form."
- Critical OQs still Open: list OQ-xxx IDs with Severity=Critical. State: "APPROVED is invalid while these Critical OQs remain Open."

**Advisory — flag before approval:**
- Acceptance criteria that test more than one condition or cannot be independently verified — cite AC IDs
- Unmitigated risks rated H likelihood AND H impact — cite RSK-xxx IDs
- Unvalidated assumptions with high Impact if Wrong — cite ASMP-xxx IDs
- Open Questions that appear answerable from the input content but were not resolved — cite OQ IDs

If none of these issues exist: state "No quality concerns — document is ready for approval."

> Review `artifacts/01-elicitation/elicitation-document.md`.
> Type **APPROVED** to proceed to `/create-epics`, or provide corrections.
> **Approval is invalid if any Critical OQ is Open or any NFR lacks a measurable target.**

On APPROVED: "Elicitation phase complete. You may now run `/create-epics`."
Do not invoke the next skill automatically.

---

## ID Reference

| Artifact | Format | Example |
|----------|--------|---------|
| Stakeholder | SH-### | SH-001 |
| Business Use Case | BUC-### | BUC-001 |
| Component Overview | COMP-### | COMP-001 |
| Sequence Diagram | SEQ-### | SEQ-001 |
| Functional Requirement | FR-### | FR-001 |
| Non-Functional Requirement | NFR-### | NFR-001 |
| Constraint | CON-### | CON-001 |
| Assumption | ASMP-### | ASMP-001 |
| Risk | RSK-### | RSK-001 |
| Acceptance Criterion | AC-[parent]-## | AC-FR-001-01 |
| Open Question | OQ-### | OQ-001 |

IDs are never reused, even after deletion or resolution.

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| No files in `inputs/` | Stop. Instruct user to add documents. |
| Unreadable file | Add OQ: "File [name] could not be read. Manual extraction required." |
| Two inputs contradict each other | Add OQ flagging the conflict; cite both source files. |
| `inputs/APIs/` empty or absent | Insert placeholder diagram + OQ in Section 4. |
| Extracted item matches existing Accepted element | Add review note only. Never modify Accepted content. |
