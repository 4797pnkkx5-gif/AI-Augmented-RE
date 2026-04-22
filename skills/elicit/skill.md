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
| Ambiguities and conflicts | Anything unclear, contradictory, or undefined → candidate Open Questions |
| Responsible stakeholder | For each BUC, FR, NFR, CON: which stakeholder owns it |

Tag every extracted item with its source filename.

If no input files exist anywhere in `inputs/`: stop and tell the user to add documents.

---

## Step 2 — Read the existing document

Open `artifacts/01-elicitation/elicitation-document.md`.

- **File exists:** read the full content. For every element (SH, BUC, FR, NFR, CON, OQ, COMP, SEQ), note: its ID, current description, Status, Accepted By, and Accepted Date.
- **File does not exist:** load the template at `skills/elicit/templates/elicitation-document.md`. Replace `<!-- PROJECT_NAME -->` with the project name inferred from inputs. Replace date placeholders with today's date. All subsequent steps treat this as a new empty document.

Note the highest existing ID in each namespace: SH-xxx, BUC-xxx, FR-xxx, NFR-xxx, CON-xxx, OQ-xxx, SEQ-xxx.

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

Apply this logic for: Stakeholders, Business Use Cases, Functional Requirements, Non-Functional Requirements, Constraints.

---

## Step 4 — Resolve open questions

For every Open Question (Status = "Open") in the document:

1. Check the question against all extracted content from Step 1.
2. If an answer is found: set Status = "Resolved", write the answer, cite the source file.
3. If partially answered: set Status = "Partially Resolved", note what remains unclear.
4. If a new input creates a conflict between two sources: add a new OQ flagging the conflict, citing both files.

For each remaining ambiguity from Step 1 extraction that is not already an open question: add a new row with the next OQ-xxx ID.

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

For any new requirement (FR or NFR) added in Step 3, add at least one Acceptance Criterion:
- FR: one or more Given/When/Then entries in nested bullet format
- NFR: one Criterion entry matching the measurable target

Set Status=Pending, Accepted By = same SH-xxx as the parent requirement.

Never modify existing AC entries whose Status is Accepted or Rejected.

---

## Step 8 — Rebuild Acceptance Status Overview

Replace Section 8 (Acceptance Status Overview) entirely. Build eight grouped tables from the current acceptance fields:

1. Stakeholders  2. Business Use Cases  3. Component Overview  4. Sequence Diagrams
5. Functional Requirements  6. Non-Functional Requirements  7. Constraints  8. Acceptance Criteria

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
> **Warning — Unresolved Open Questions:** [table of open OQs]
> These do not block approval but will affect downstream artifacts.

> Review `artifacts/01-elicitation/elicitation-document.md`.
> Type **APPROVED** to proceed to `/create-epics`, or provide corrections.

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
