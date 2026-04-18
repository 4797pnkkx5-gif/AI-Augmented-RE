# Skill: elicit

**Purpose:** Process raw input documents and produce (or incrementally update) the Elicitation Document — the foundational artifact of the RE pipeline.

**Invocation:**
- Claude Code: `/elicit`
- GitHub Copilot: "Run the elicit skill" or "Follow `skills/elicit/skill.md`"

**Inputs:** All files in `inputs/` (excluding `inputs/README.md` and `inputs/manifest.md`)
**Outputs:**
- `artifacts/01-elicitation/elicitation-document.md` (created or updated)
- `inputs/manifest.md` (created or appended)

---

## Step 1 — Prerequisites Check

Before doing anything else:

1. List all files in `inputs/` recursively, excluding `inputs/README.md` and `inputs/manifest.md`.
2. If no files are found: stop and tell the user "No input documents found in `inputs/`. Drop at least one document there and re-run `/elicit`."
3. If any files cannot be read: note them — do not abort. They will be recorded as open questions.
4. Confirm the path `artifacts/01-elicitation/` exists in the repo. If it does not: warn the user and stop.

---

## Step 2 — Mode Detection

Determine which mode to operate in before processing any inputs.

**Read `inputs/manifest.md`** if it exists. Extract the list of already-processed filenames from the "File" column.

**List all files** currently in `inputs/` (excluding README.md and manifest.md).

**New inputs** = files currently in `inputs/` that do not appear in the manifest.

| Condition | Mode |
|-----------|------|
| `artifacts/01-elicitation/elicitation-document.md` does NOT exist | **Create** |
| Document exists AND new inputs were found | **Update** |
| Document exists AND no new inputs | **Review-only** |

**Review-only:** Tell the user "No new inputs detected. Presenting the current Elicitation Document for review." Then skip to Step 6 (Review Gate).

---

## Step 3 — Input Processing

Apply to every new input file identified in Step 2.

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
   - **Section 4.1 Functional Requirements:** one subsection per FR; assign FR-001, FR-002, ... sequentially. Set Status=Pending, Accepted By = responsible SH-xxx (from extraction), Accepted Date=—.
   - **Section 4.2 Non-Functional Requirements:** assign NFR-001, NFR-002, ... Set Status=Pending, Accepted By = most-affected SH-xxx, Accepted Date=—.
   - **Section 4.3 Constraints:** assign CON-001, CON-002, ... Set Status=Pending, Accepted By = SH-xxx who imposed the constraint, Accepted Date=—.
   - **Section 5 Acceptance Criteria:** one or more AC entries per requirement using the nested bullet format. FR ACs use Given/When/Then sub-bullets. NFR ACs use a single Criterion sub-bullet. For every AC entry: set Status=Pending, Accepted By = same SH-xxx as the parent requirement's Accepted By field, Accepted Date=—.
   - **Section 6 Open Questions:** one row per ambiguity; assign OQ-001, OQ-002, ...
   - **Section 7 Acceptance Status Overview:** build all six subtables (Stakeholders, Business Use Cases, Functional Requirements, Non-Functional Requirements, Constraints, Acceptance Criteria) by reading back the acceptance fields from the sections just populated. One row per element. This is the last section populated.
   - **Section 8 Traceability Summary:** leave all Epic/Story/Test columns as "—".
   - **Section 9 Revision History:** one row: version 1.0, today's date, "elicit skill (initial run)", "Initial creation".
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
For every row in Section 6 where Status is "Open":
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

**Merge Requirements (Sections 4.1–4.3):**
- New requirements: add new subsections with IDs continuing from the highest existing. Set Status=Pending, Accepted By = responsible SH-xxx, Accepted Date=—.
- Existing requirements clarified by new inputs: append a note to the relevant field. Do not modify acceptance fields.

**Merge Acceptance Criteria (Section 5):**
- Add AC entries for all new requirements using the nested bullet format. Set Status=Pending, Accepted By = same SH-xxx as the parent requirement's Accepted By, Accepted Date=—.
- Never modify Status, Accepted By, or Accepted Date on existing AC entries.

**Merge Open Questions (Section 6):**
- New ambiguities from new inputs: add new rows with IDs continuing from the highest existing OQ-xxx.

**Finalize:**
- Update `last-updated` in the YAML frontmatter to today's date.
- **Rebuild Section 7 (Acceptance Status Overview) entirely** from the current acceptance fields across Sections 2–5. This is the one section that is fully replaced on every update — it is always a derived view, never merged. Read every element's current Status, Accepted By, and Accepted Date and rewrite all six subtables from scratch.
- Append a row to Section 9 (Revision History): version = previous version + 0.1, today's date, "elicit skill (incremental run)", brief summary of changes.
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
