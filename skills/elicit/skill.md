# Skill: elicit

**Purpose:** Process raw input documents and produce (or incrementally update) the Elicitation Document — the foundational artifact of the RE pipeline. Handles requirements extraction, open question resolution, and architecture diagram generation in a single run.

**Invocation:**
- Claude Code: `/elicit`
- GitHub Copilot: "Run the elicit skill" or "Follow `skills/elicit/skill.md`"

**Inputs:**
- Text/YAML/JSON/PDF/DOCX files in `inputs/` and its sub-folders
- OpenAPI YAML files in `inputs/APIs/` (for architecture diagrams)

**Outputs:**
- `artifacts/01-elicitation/elicitation-document.md` (created or updated)
- `inputs/manifest.md` (created or appended)

---

## Step 1 — Read all inputs

Execute all reads now, before any other step.

**1a. Read every file in `inputs/APIs/`** (if the folder exists). Do this unconditionally — architecture diagrams must always reflect the current API definitions. For each OpenAPI 3.x YAML file, note:
- Service name (`info.title`)
- Endpoints: path + HTTP method + `operationId`
- Dependencies: server URLs that reference other services
- Key schema names from `components/schemas`

If `inputs/APIs/` is empty or absent, note that — architecture diagrams will use placeholders.

**1b. List all other input files** in `inputs/` recursively, excluding `inputs/README.md` and `inputs/manifest.md`.

If no files exist anywhere in `inputs/`: stop and tell the user to add documents.

---

## Step 2 — Read the existing document (if any)

Open `artifacts/01-elicitation/elicitation-document.md`.

- **If the file does not exist:** use the template at `skills/elicit/templates/elicitation-document.md` as the starting point. This is **Create mode** — continue to Step 3.
- **If the file exists:** read its full content. Note the highest existing ID in each namespace (SH-xxx, BUC-xxx, FR-xxx, NFR-xxx, CON-xxx, OQ-xxx, SEQ-xxx). This is **Update mode** — continue to Step 3.

---

## Step 3 — Identify new inputs and extract requirements

Read `inputs/manifest.md` (if it exists). Extract all filenames already listed in the "File" column — these are already-processed files.

**New inputs** = files from Step 1b that are NOT in the manifest.

For each new input file, read it and extract:

| What to extract | How to handle it |
|----------------|-----------------|
| **Stakeholders** | Name, role, organisation, concerns, contact info |
| **Business-level needs** | What the system must enable — not technical features |
| **Functional requirements** | "The system shall / must / should" statements |
| **Non-functional requirements** | Performance, security, usability, reliability, compliance targets |
| **Constraints** | Technology mandates, regulatory rules, budget/timeline limits |
| **Ambiguities** | Anything unclear → candidate Open Questions |
| **Responsible stakeholder** | For each BUC/FR/NFR/CON: note which SH-xxx is responsible |

Tag every extracted item with its source filename.

**Unreadable files:** create one OQ per file: "File `[name]` could not be read. Manual extraction required."

If there are no new inputs and the document already exists: skip to Step 4 (still check OQs and update diagrams).

---

## Step 4 — Resolve open questions

Read every Open Question (Status = "Open") in the existing document. Check each one against **all** input files — not just new ones.

- If an input file answers a question: set Status = "Resolved", write the answer, cite the source filename.
- If partially answered: set Status = "Partially Resolved", note what remains unclear.

---

## Step 5 — Write requirements into the document

### Create mode (no existing document)

Read the template. Replace `<!-- PROJECT_NAME -->` with the project name inferred from inputs. Replace date placeholders with today's date.

Populate sections in this order:
- **Section 2 Stakeholders:** one table row per stakeholder. IDs: SH-001, SH-002, ... Status=Pending.
- **Section 3.0 BUC diagram:** Mermaid `flowchart LR`. Actor nodes outside subgraph, BUC nodes inside. Solid arrows for primary actors, dashed for secondary. Node IDs: SH001, BUC001 (no hyphens).
- **Section 3 BUCs:** one subsection per BUC. IDs: BUC-001, BUC-002, ... Status=Pending, Accepted By = primary actor SH-xxx.
- **Section 5 Requirements:** FR-001, FR-002, ...; NFR-001, ...; CON-001, ... Status=Pending, Accepted By = responsible SH-xxx.
- **Section 6 Acceptance Criteria:** one or more AC entries per requirement. Nested bullet format. FR: Given/When/Then. NFR: Criterion. Status=Pending.
- **Section 7 Open Questions:** one row per ambiguity. IDs: OQ-001, OQ-002, ...
- **Section 9 Traceability Summary:** leave all columns as "—".
- **Section 10 Revision History:** one row, version 1.0, today's date, "elicit skill (initial run)".

Section 4 and Section 8 are populated in Steps 6 and 7.

### Update mode (existing document)

Merge new content. Preserve everything that exists.

- **Section 2:** add new stakeholder rows. Append `Updated: YYYY-MM-DD — [source]` to concerns of existing stakeholders if new info found.
- **Section 3.0 BUC diagram:** append new actor and BUC nodes. Never remove existing nodes.
- **Section 3 BUCs:** add new BUC subsections. For existing BUCs with new info: append `> Updated YYYY-MM-DD ([source]): [what changed]`.
- **Section 5 Requirements:** add new subsections continuing from the highest existing ID. Never overwrite existing content.
- **Section 6 Acceptance Criteria:** add AC entries for new requirements only.
- **Section 7 Open Questions:** add new rows for new ambiguities.
- **Acceptance field preservation rule:** never overwrite Status=Accepted or Status=Rejected with Pending. Only newly created entries get Status=Pending.

---

## Step 6 — Update architecture diagrams (always runs)

This step always runs regardless of whether there were new input files.

**Check:** does the document contain the heading `## 4. System Architecture Overview`?

**If NO (Section 4 is absent):**
1. In the document, rename: `## 4.` → `## 5.`, `## 5.` → `## 6.`, `## 6.` → `## 7.`, `## 7.` → `## 8.`, `## 8.` → `## 9.`, `## 9.` → `## 10.`
2. Update cross-references in the document body (e.g. "See Section 5 —" wherever Requirements are referenced).
3. Insert `## 4. System Architecture Overview` after the last line of Section 3.

**Now generate or update Section 4 content using the API data read in Step 1a:**

**Section 4.0 — Component Overview (COMP-001):**

If API YAML was found in Step 1a: generate a Mermaid `flowchart LR` diagram:
- One rectangular node per service inside `subgraph SYS["<project name>"]`
- External clients/mobile apps as `([...])` nodes outside the subgraph
- Arrows between services where one calls another; label with protocol (HTTP, gRPC, Event, DB)
- Keep node labels short (2–4 words)

If no API YAML: insert a placeholder diagram and add OQ: "Component diagram is missing. Place OpenAPI YAML files in `inputs/APIs/` and re-run `/elicit`."

Set: **Status:** Pending | **Accepted By:** tech lead or most relevant SH-xxx | **Accepted Date:** —

If Section 4 already existed and COMP-001 Status is NOT Accepted: replace the diagram with the freshly derived version.

**Section 4.1+ — Sequence Diagrams (SEQ-001, SEQ-002, ...):**

For each service (or BUC with multi-step component interaction):
- Generate a `sequenceDiagram` using operationIds as message names
- Participants = Client + the service + any services it calls
- Show the happy-path request/response only

If no API YAML: add one OQ per BUC: "Sequence diagram for BUC-xxx is missing."

Set Status=Pending, Accepted By = same SH-xxx as the BUC's Accepted By.

For diagrams that already exist and are NOT Accepted: update content from current API YAML.

---

## Step 7 — Rebuild Acceptance Status Overview

Replace Section 8 (Acceptance Status Overview) entirely. Build eight grouped tables from the current acceptance fields across Sections 2–4:

1. Stakeholders
2. Business Use Cases
3. Component Overview
4. Sequence Diagrams
5. Functional Requirements
6. Non-Functional Requirements
7. Constraints
8. Acceptance Criteria

One row per element. Never merge — always fully replace this section.

---

## Step 8 — Write outputs

1. Update `last-updated` in the YAML frontmatter to today's date.
2. Append to Section 10 (Revision History): version = previous + 0.1, today's date, "elicit skill", brief summary.
3. Write the complete document to `artifacts/01-elicitation/elicitation-document.md`.
4. Append rows to `inputs/manifest.md` for all newly processed files (from Step 3). Mode = "initial" for first run, "incremental" for updates. Note resolved OQs in the Notes column.

---

## Step 9 — Review gate

Present to the user:

> **What changed in this run:**
> - [new stakeholders added, if any]
> - [new requirements added, if any]
> - [OQs resolved, if any]
> - [Section 4 diagrams added or updated]
> - ["No requirement changes — diagrams updated only" if only Step 6 ran]

If any OQs remain Open:
> **Warning — Unresolved Open Questions:** [table of open OQs]
> These do not block approval but will affect downstream artifacts.

> Review `artifacts/01-elicitation/elicitation-document.md`.
> Type **APPROVED** to proceed to `/create-epics`, or provide corrections.

On APPROVED: confirm "Elicitation phase complete." Do not invoke the next skill automatically.

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
| Manifest missing, document exists | Treat all inputs as new. Create manifest. |
| File in manifest but not on disk | Warn user; do not abort. |
| Two inputs conflict | Add OQ flagging conflict; cite both sources. |
| `inputs/APIs/` empty or absent | Insert placeholder diagram + OQ in Section 4. |
