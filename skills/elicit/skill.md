# Skill: elicit

**Purpose:** Process raw input documents and produce (or incrementally update) the Elicitation Document — the foundational artifact of the RE pipeline.

**Invocation:**
- Claude Code: `/elicit`
- GitHub Copilot: "Run the elicit skill" or "Follow `skills/elicit/skill.md`"

**Inputs:** All files in `inputs/` (excluding `inputs/README.md` and `inputs/manifest.md`); API YAML files in `inputs/APIs/`
**Outputs:**
- `artifacts/01-elicitation/elicitation-document.md` (created or updated)
- `inputs/manifest.md` (created or appended)

---

## Step 1 — Prerequisites Check

Before doing anything else:

1. List all files in `inputs/` recursively, excluding `inputs/README.md` and `inputs/manifest.md`.
2. List all files in `inputs/APIs/` recursively. Note the count found. If `inputs/APIs/` does not exist or is empty, this is not an error — it triggers Open Questions in Step 4.
3. If no files are found in `inputs/` at all: stop and tell the user "No input documents found in `inputs/`. Drop at least one document there and re-run `/elicit`."
4. If any files cannot be read: note them — do not abort. They will be recorded as open questions.
5. Confirm the path `artifacts/01-elicitation/` exists in the repo. If it does not: warn the user and stop.

---

## Step 2 — Mode Detection

Follow this decision tree top to bottom. Stop at the first matching condition.

**Check 1 — Does the elicitation document exist?**
- Open `artifacts/01-elicitation/elicitation-document.md`.
- If the file does NOT exist → **CREATE MODE**. Proceed to Step 3, then Step 4a.
- If the file exists → read it fully now, then continue to Check 2.

**Check 2 — Does the document contain Section 4?**
- Search the document text for the exact heading `## 4. System Architecture Overview`.
- If this heading is NOT present → **UPDATE MODE (Section 4 backfill required)**. Proceed to Step 3, then Step 4b. Do NOT skip to Step 6.
- If the heading is present → continue to Check 3.

**Check 3 — Are there new input files?**
- Read `inputs/manifest.md` if it exists. Extract all filenames from the "File" column.
- List all files currently in `inputs/` (excluding `inputs/README.md` and `inputs/manifest.md`).
- If any file in `inputs/` does NOT appear in the manifest → **UPDATE MODE**. Proceed to Step 3, then Step 4b.
- If all files are already in the manifest → **REVIEW-ONLY MODE**. Tell the user "No new inputs detected. Presenting the current Elicitation Document for review." Skip to Step 6.

---

## Step 3 — Input Processing

**Part A — Read API files (always, regardless of manifest state):**

Read every file in `inputs/APIs/` now, even if those files already appear in the manifest. Architecture diagrams must always reflect the current API definitions, not just new ones. For each YAML file, extract:

| Input type | What to extract |
|------------|----------------|
| OpenAPI 3.x YAML (`openapi: 3.x.x`) | Service/component name from `info.title`; external server references from `servers`; components from tag groups or path prefixes; endpoint operations (path + method + operationId) and their request/response schemas; dependencies between services visible in server URLs |
| Other YAML | Best-effort: top-level keys as component names, nested structure as properties. Note format as "non-OpenAPI YAML" in Source. |

If `inputs/APIs/` is empty or does not exist, note that — Section 4 will use placeholder content and generate Open Questions.

**Part B — Read new input files:**

Apply to every new input file identified in Step 2 (files not in the manifest).

Read each file using the Read tool. For each file, extract:

| What to extract | How to handle it |
|----------------|-----------------|
| **Stakeholders** | Name, role, organisation, concerns, contact info |
| **Business-level needs** | What the system must enable — not technical features |
| **Functional requirements** | Explicit "the system shall / must / should" statements |
| **Non-functional requirements** | Performance, security, usability, reliability, scalability, compliance targets |
| **Constraints** | Technology mandates, regulatory rules, budget/timeline limits |
| **Ambiguities** | Anything unclear, contradictory, or undefined → candidate Open Questions |
| **Responsible stakeholder per item** | For each BUC, FR, NFR, CON: note the primary/responsible SH-xxx — used to pre-fill the Accepted By field |

**Source tagging:** Every extracted item must carry the originating filename as its Source. This is mandatory for traceability.

**Unreadable files:** Add one Open Question per unreadable file: "File `[filename]` could not be read automatically. Manual extraction required." Assigned To: the user. Status: Open.

**GitHub Copilot note:** Copilot cannot read `.docx` or `.pdf` files directly. If such files are present and unread, add the open question above and remind the user to convert them (`pandoc file.docx -o file.md` or `pdftotext file.pdf file.txt`) and re-run.

---

## Step 4a — Create Mode

1. Read the template at `skills/elicit/templates/elicitation-document.md`.
2. Replace `<!-- PROJECT_NAME -->` with the project name inferred from the inputs (or ask the user if unclear).
3. Replace `<!-- CREATION_DATE -->` and `<!-- LAST_UPDATED_DATE -->` with today's date (YYYY-MM-DD).
4. Populate each section using the extracted data from Step 3:
   - **Section 2 Stakeholders:** one row per stakeholder found; assign SH-001, SH-002, ... sequentially. Set Status=Pending and Accepted Date=— for every row.
   - **Section 3.0 Use Case Diagram:** After populating all BUC subsections, generate the Mermaid flowchart LR diagram. For each stakeholder in Section 2, add an actor node `SH[number]([role name])` (e.g., `SH001([Product Owner])`). For each BUC, add a use case node `BUC[number][BUC-xxx: short title]` inside the `subgraph SYS["Project Name"]` block. For each BUC's Primary Actor: draw a solid arrow (`-->`). For each BUC's secondary Stakeholders: draw dashed arrows (`-.->`) . Node IDs must use numbers only — no hyphens: `SH001`, `SH002`, `BUC001`, `BUC002`.
   - **Section 3 Business Use Cases:** one subsection per BUC; assign BUC-001, BUC-002, ... sequentially.
   - **Section 4 System Architecture Overview:** populate after Section 3 is complete (BUCs are needed for sequence diagrams).
     - **Section 4.0 Component Overview (COMP-001):**
       - If `inputs/APIs/` contains YAML: extract components and their relationships → generate Mermaid `flowchart LR` diagram. Place client/external actors outside the `subgraph SYS` block; system components inside. Label edges with protocol (HTTP, gRPC, Event, DB) where determinable from the API spec.
       - If no API YAML but inputs contain architectural/component descriptions (keywords: service, component, module, API, database, backend, frontend, microservice): generate best-effort diagram from described components. Add OQ: "COMP-001 was inferred from textual descriptions. Review accuracy and provide OpenAPI YAML in `inputs/APIs/` to improve precision."
       - If no architectural input at all: insert placeholder diagram (Client → System box with one placeholder component). Add OQ: "Component diagram is missing. Describe system components in inputs or place OpenAPI YAML files in `inputs/APIs/`." Assign OQ to the user; Status=Open.
       - Set Status=Pending, Accepted By = tech-lead or architect SH-xxx if identifiable, else most relevant SH-xxx.
     - **Section 4.1+ Sequence Diagrams (SEQ-001, SEQ-002, ...):**
       - For each BUC that describes a multi-step interaction involving more than one component: generate one sequence diagram subsection.
       - Simple BUCs (single actor performing a single action with no visible component interaction) do not require a sequence diagram.
       - If `inputs/APIs/` has YAML: use component names as participants; use endpoint operationId or path+method as message labels.
       - If no API YAML: infer participants from BUC descriptions and add OQ per diagram: "Sequence diagram SEQ-xxx (BUC-xxx: [title]) was inferred from textual descriptions. Review and correct, or provide OpenAPI YAML in `inputs/APIs/` for a more accurate diagram."
       - Assign SEQ-001, SEQ-002, ... sequentially. Set Status=Pending, Accepted By = same SH-xxx as the BUC's Accepted By.
   - **Section 5.1 Functional Requirements:** one subsection per FR; assign FR-001, FR-002, ... sequentially. Set Status=Pending, Accepted By = responsible SH-xxx (from extraction), Accepted Date=—.
   - **Section 5.2 Non-Functional Requirements:** assign NFR-001, NFR-002, ... Set Status=Pending, Accepted By = most-affected SH-xxx, Accepted Date=—.
   - **Section 5.3 Constraints:** assign CON-001, CON-002, ... Set Status=Pending, Accepted By = SH-xxx who imposed the constraint, Accepted Date=—.
   - **Section 6 Acceptance Criteria:** one or more AC entries per requirement using the nested bullet format. FR ACs use Given/When/Then sub-bullets. NFR ACs use a single Criterion sub-bullet. For every AC entry: set Status=Pending, Accepted By = same SH-xxx as the parent requirement's Accepted By field, Accepted Date=—.
   - **Section 7 Open Questions:** one row per ambiguity; assign OQ-001, OQ-002, ... (include any OQs generated for missing/inferred architecture diagrams).
   - **Section 8 Acceptance Status Overview:** build all eight subtables (Stakeholders, Business Use Cases, Component Overview, Sequence Diagrams, Functional Requirements, Non-Functional Requirements, Constraints, Acceptance Criteria) by reading back the acceptance fields from the sections just populated. One row per element. This is the last section populated.
   - **Section 9 Traceability Summary:** leave all Epic/Story/Test columns as "—".
   - **Section 10 Revision History:** one row: version 1.0, today's date, "elicit skill (initial run)", "Initial creation".
5. Write the completed document to `artifacts/01-elicitation/elicitation-document.md`.
6. Create `inputs/manifest.md` with the following content:

```markdown
# Input Manifest

Tracks which input files have been processed by the `/elicit` skill.
To reprocess a file: delete its row, then run `/elicit` again.

## Processed Inputs

| File | Processed Date | Run Mode | Notes |
|------|---------------|----------|-------|
| [filename] | YYYY-MM-DD | initial | — |
```

   Add one row per processed file.
7. Proceed to Step 6 (Review Gate).

---

## Step 4b — Update Mode

The Elicitation Document is a **living document**. Do not regenerate it. Merge new content into the existing structure.

1. Read the full existing `artifacts/01-elicitation/elicitation-document.md`.
2. Note the highest existing ID in each namespace: SH-xxx, BUC-xxx, FR-xxx, NFR-xxx, CON-xxx, OQ-xxx. New IDs continue from there.
3. Process each new input file (Step 3 extraction).

**Open Questions Check (mandatory):**
For every row in the Open Questions section (Section 7 in new documents; Section 6 in documents that predate the Section 4 update) where Status is "Open":
- Check whether the new inputs contain information that resolves or partially answers the question.
- If yes: update Status to "Resolved", write the answer in the Answer column, cite the source filename. Keep the original question text unchanged.
- If a new input partially answers a question: update Status to "Partially Resolved" and note what remains unclear.

**Merge Stakeholders (Section 2):**
- New stakeholders: add new rows.
- Known stakeholders appearing with new information: append `Updated: YYYY-MM-DD — [source filename]` to their Concerns cell. Do not replace existing content.

**Merge Business Use Cases (Section 3):**
- New BUCs: add new subsections. Set Status=Pending, Accepted By = primary actor SH-xxx, Accepted Date=—.
- Existing BUCs refined by new inputs: append a note below the existing BUC: `> Updated YYYY-MM-DD ([source filename]): [what changed]`. Do not replace existing content.
- **BUC diagram update (Section 3.0):** For each newly added BUC, add a new node inside the `subgraph SYS` block. For each newly added stakeholder, add a new actor node. Add the corresponding arrows. Never remove or alter existing nodes or arrows.

**Acceptance field preservation rule (applies to all elements — BUC, FR, NFR, CON, AC, SH rows):**
Never overwrite a Status of `Accepted` or `Rejected` with `Pending`. Only set `Status: Pending` on newly created entries. Status changes are made by humans, not by the skill.

**Merge System Architecture (Section 4):**

Check whether the current document contains the heading `## 4. System Architecture Overview`.

**If Section 4 is ABSENT (backfill required):**
1. Rename section headings in the existing document: `## 4.` → `## 5.`, `## 5.` → `## 6.`, `## 6.` → `## 7.`, `## 7.` → `## 8.`, `## 8.` → `## 9.`, `## 9.` → `## 10.`
2. Update all internal cross-references that cite section numbers (e.g., `See Section 4 —` → `See Section 5 —`, `Section 6 (Open Questions)` → `Section 7 (Open Questions)`).
3. Insert the new `## 4. System Architecture Overview` block immediately after the last line of Section 3. Use the API data already extracted in Step 3 Part A to populate it. Follow the same rules as Step 4a for Section 4 content (component diagram, sequence diagrams, OQs if data is insufficient).
4. Continue to the remainder of the Update Mode steps below.

**If Section 4 IS present AND new API YAML files were detected:**
- Re-derive component diagram and update Section 4.0. Append a note below the diagram: `> Updated YYYY-MM-DD ([source]): [what changed]`. Never replace existing content if COMP-001 Status=Accepted.
- Acceptance field preservation: never overwrite Accepted/Rejected on COMP-001 or any SEQ-xxx.
- For each new BUC added during this update: add a new SEQ-xxx subsection. If no API YAML available, add OQ as in Create Mode.
- If architecture OQs from a previous run are now resolved by new API YAML: update those OQ rows to Resolved; improve the diagram content; append update note.

**Merge Requirements (Sections 5.1–5.3):**
- New requirements: add new subsections with IDs continuing from the highest existing. Set Status=Pending, Accepted By = responsible SH-xxx, Accepted Date=—.
- Existing requirements clarified by new inputs: append a note to the relevant field. Do not modify acceptance fields.

**Merge Acceptance Criteria (Section 6):**
- Add AC entries for all new requirements using the nested bullet format. Set Status=Pending, Accepted By = same SH-xxx as the parent requirement's Accepted By, Accepted Date=—.
- Never modify Status, Accepted By, or Accepted Date on existing AC entries.

**Merge Open Questions (Section 7):**
- New ambiguities from new inputs: add new rows with IDs continuing from the highest existing OQ-xxx.

**Finalize:**
- Update `last-updated` in the YAML frontmatter to today's date.
- **Rebuild Section 8 (Acceptance Status Overview) entirely** from the current acceptance fields across Sections 2–4. This is the one section that is fully replaced on every update — it is always a derived view, never merged. Read every element's current Status, Accepted By, and Accepted Date and rewrite all eight subtables from scratch (Stakeholders, BUCs, Component Overview, Sequence Diagrams, FRs, NFRs, Constraints, ACs).
- Append a row to Section 10 (Revision History): version = previous version + 0.1, today's date, "elicit skill (incremental run)", brief summary of changes.
- Append rows to `inputs/manifest.md` for all newly processed files, mode "incremental". In the Notes column, record any OQs that were resolved (e.g., "Resolved OQ-003, OQ-007").

Proceed to Step 6 (Review Gate).

---

## Step 5 — (skipped; numbering reserved for future pre-review validation)

---

## Step 6 — Review Gate

Present the following to the user:

**1. Change summary**

> I have [created / updated] the Elicitation Document.
>
> **What changed:**
> - [bullet: e.g., "Added 2 stakeholders: SH-003 (Jane Smith, Product Owner), SH-004 (Dev Lead)"]
> - [bullet: e.g., "Added 4 functional requirements: FR-003–FR-006"]
> - [bullet: e.g., "Resolved OQ-002 (authentication approach now clear from api-spec.yaml)"]
> - [bullet: e.g., "Added 3 open questions: OQ-004–OQ-006"]

**2. Open questions warning (if any OQs have Status "Open")**

> **Warning — Unresolved Open Questions:**
>
> The following questions remain open. They do not block approval, but downstream artifacts (Epics, Stories, SRS) built on unresolved questions may need revision when answers arrive.
>
> | ID | Question | Assigned To | Deadline |
> |----|----------|-------------|----------|
> | OQ-001 | ... | ... | ... |

**3. Review prompt**

> Please review the Elicitation Document at `artifacts/01-elicitation/elicitation-document.md`.
>
> When you are satisfied, type **APPROVED** to proceed to the next phase (`/create-epics`).
> Or provide corrections and I will apply them and re-present for review.

**4. On corrections:** Apply exactly what the user specifies. Re-present the summary and prompt.

**5. On APPROVED:**

> Elicitation phase complete. The Elicitation Document is approved.
>
> You may now run `/create-epics` to transform this document into Epics.

Do NOT invoke `/create-epics` automatically. The human must trigger it.

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

IDs are never reused, even after a stakeholder is removed or a question is resolved.

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| No files in `inputs/` | Stop. Instruct user to add documents. |
| `inputs/manifest.md` missing but elicitation document exists | Treat all inputs as new (create mode for manifest, update mode for document). |
| A file exists in the manifest but not on disk | Warn user: "File `[x]` was previously processed but is no longer in `inputs/`. This is noted but does not affect the current run." |
| Conflicting information between two input files | Add an Open Question flagging the conflict. Cite both source files. |
| Input file is in a language other than English | Process it as-is; note the language in the Source field. Add an Open Question if translation accuracy is a concern. |
