# Skill: create-tasks

**Purpose:** Decompose every Accepted User Story into developer-sized, codebase-agnostic implementation Tasks at `artifacts/07-implementation-tasks/`. Each Task describes intent + contract (Inputs, Outputs, Technical Context, Definition of Done) that the Dev-Team's AI coding agent consumes — never source-code locations, framework names, or library versions. Tasks are derived deterministically from a published heuristic over Acceptance-Criterion count, Story Implementation Notes, NFR exposure on the parent Epic, and SRS Section 4 component coverage. The skill cross-references the Accepted SRS for stable NFR / CON / component context, raises OQs when the heuristic produces unusual outputs (e.g., a Story decomposes into 7+ Tasks), and audits every Task for codebase-specific content before writing. Re-runs are idempotent: Pending Tasks are refined in place, Accepted Tasks are immutable, and TASK-### IDs are never reused. Cross-cutting Tasks (e.g., a foundational Auth Task driven by a cross-cutting NFR) are minted once and linked to every Story they serve.

**Invocation:**
- Claude Code: `/create-tasks`
- GitHub Copilot: "Run the create-tasks skill" or "Follow `skills/create-tasks/skill.md`"

**Inputs:**
- `artifacts/04-srs/srs.md` (`status: Accepted`) — required; provides Section 4 (logical components), Section 5 (NFRs and Measurable Targets), Section 6 (CONs), Section 8 (canonical AC list)
- `artifacts/03-user-stories/story-*.md` — Accepted Story subset is in scope; Pending Stories listed in `index.md` as Deferred
- `artifacts/02-epics/epic-*.md` — for cross-cutting NFR identification (each Epic's Cross-cutting NFRs table)
- `artifacts/01-elicitation/elicitation-document.md` — Section 4 component diagrams (logical components only)
- `artifacts/05-test-concept/test-case-*.md` — to map TC-### per AC into each Task's `parent-tcs` field
- `artifacts/07-implementation-tasks/task-*.md` and `index.md` (existing, if any)

**Outputs:**
- `artifacts/07-implementation-tasks/task-NNN.md` — one file per Task, NNN = zero-padded TASK-### sequence
- `artifacts/07-implementation-tasks/index.md` — always rebuilt every run (Task Map, Story / AC Coverage Matrices, Effort Distribution, Cross-Cutting table, OQ aggregation, Boundary Audit Summary)

---

## Step 0 — Approval gate (SRS strict + Story incremental)

Implementation Tasks bind to two upstream layers: the SRS for stable NFR / CON / component context, and the Story set for unit-of-work decomposition. The gate is strict on the SRS and incremental on Stories — Tasks run as soon as at least one Story is Accepted under an Accepted Epic, while letting Pending Stories defer to a future re-run.

Read `artifacts/04-srs/srs.md`.

- If the file does not exist: stop. "Run `/create-srs` first to compile the Software Requirements Specification."
- If frontmatter `status` is not `Accepted`: stop and tell the user the current status. "The SRS is `<current status>`, not Accepted. Have the human reviewer review and accept the SRS in `/create-srs` before invoking `/create-tasks`."

Read every `artifacts/03-user-stories/story-*.md`.

- If the directory does not exist or contains no Story files: stop. "Run `/create-stories` first to derive User Stories."
- If no Story has `status: Accepted` whose `parent-epic` references an Accepted Epic: stop. "No Accepted Story under an Accepted Epic yet. Re-run `/create-tasks` once at least one Story is Accepted."

Defensive checks (the upstream gates have held but verify):

- The Elicitation Document at `artifacts/01-elicitation/elicitation-document.md` exists with `status: Approved`.
- No Critical OQ from any earlier phase is still `Open` in the SRS, the elicit doc, any Epic file, any Story file, or any Test Case file.

---

## Step 1 — Read every upstream artefact

Extract structural fields from each input. Build the **canonical Story subset** (all Stories with `status: Accepted` whose `parent-epic` references an Accepted Epic) — this is the source of truth for what Tasks must exist.

| Source | What to extract |
|--------|-----------------|
| SRS Section 4 | Logical component IDs / titles touched by each Story (via the Story's parent FR and the SRS Traceability Matrix) |
| SRS Section 5 | NFR ID, Title, Category, Measurable Target, Priority — drives the NFR-threshold Task and effort heuristic |
| SRS Section 6 | CON ID, Type, Status — bound to Tasks via Technical Context |
| SRS Section 8 | Canonical AC list: every AC ID (`AC-FR-###-NN` / `AC-NFR-###-NN`), parent FR or NFR, Given/When/Then text or Criterion |
| Story files | US-### (parent-fr, parent-epic, owner, ACs lifted in Section 4, Implementation Notes in Section 8, Dependencies in Section 7); the canonical Story subset is the Accepted set under Accepted Epics |
| Epic files | Cross-cutting NFRs table per Epic — identifies which NFRs may drive cross-cutting Tasks |
| Elicit doc Section 4 | Component diagram (Mermaid) — read for logical component identifiers used in SRS Section 4 |
| Test Case files | TC-### with `parent-ac` — used to populate each Task's `parent-tcs` list |

The skill uses IDs and structural fields, not full prose. Drift is detected by `/trace` at Phase 6 and is not re-checked here.

---

## Step 2 — Read existing Task artefacts

Walk every `artifacts/07-implementation-tasks/task-*.md`. For each Task: capture TASK-ID, parent-story, parent-acs, parent-tcs, cross-cutting flag, status, owner, effort, OQs referenced.

Compute counters:

- `next_TASK_id = max(existing TASK-### across all task-*.md files) + 1`
- `next_OQ_id = max(OQ-### across the elicit doc, every Epic file, every Story file, the SRS, every Test Case file, and every existing Task file) + 1`

TASK-### IDs and OQ-### IDs are **never reused** even after deletion or rejection.

---

## Step 3 — Apply the decomposition heuristic

The heuristic is **published**, not hidden. The team may override during sprint planning, but the skill always produces a deterministic seed list.

For each Story in the canonical Story subset:

1. **Per-AC base Tasks** — for every AC referenced in the Story's Section 4: mint one base Task with that AC in `parent-acs`. A Story with N ACs produces N base Tasks. (Exception: when the heuristic detects a tight pair of ACs that read as positive/negative paths of the same observable behaviour — e.g., AC-FR-###-01 happy + AC-FR-###-02 invalid-input — they MAY be combined into one Task with both ACs listed. The skill picks the conservative default — one Task per AC — and never auto-combines without explicit human direction.)
2. **NFR-threshold Tasks** — for each NFR with a measurable threshold (Category ∈ Performance / Security / Reliability) whose parent BUC is in the Story's parent Epic's BUC scope: mint one extra Task whose `parent-acs` is the matching `AC-NFR-###-NN` and whose Title is `"Verify NFR-### threshold: <Measurable Target excerpt>"`. Skip if the AC-NFR is already covered by an existing Task.
3. **Cross-cutting Tasks** — for each NFR marked `Cross-cutting: Yes` in any Epic and referenced by ≥2 Stories in the canonical Story subset: mint one cross-cutting Task with `cross-cutting: Yes` in frontmatter. Section 2 lists the primary Story (lowest US-### in the linked set) under "Parent Story" and the rest under "Additional Stories". The Task's `parent-acs` is the cross-cutting NFR's AC.
4. **Component scaffolding Tasks** — for each logical component in SRS Section 4 that is touched by a Story but has not yet been targeted by any earlier Task in the canonical seed list: mint one scaffolding Task with Title `"Scaffold logical component <COMP-###>"`. Intent describes the component's role per SRS §4; no implementation prescription. Skip if the component is implicitly delivered by a base Task (e.g., the only Story touching the component has only one AC — the base Task subsumes scaffolding).

Effort flag (AI-provisional, applied per Task):

- **S** — 1 AC, no Performance/Security/Reliability NFR exposure on the parent Epic
- **M** — 2–3 ACs OR 1 AC plus a Performance/Security/Reliability NFR threshold
- **L** — 4+ ACs OR cross-cutting NFR with multi-Story scope

The flag is **AI-provisional** and every Task carries the note `**AI estimate — confirm with team.**` A Story whose total Task count is ≥7 triggers `OQ Severity=High`: `"US-### produced N Tasks. Consider re-running /create-stories with an AC split — Stories of this size are difficult to deliver as a single sprint commitment."`

Output of this step: the **canonical Task seed list** — `[(parent-story, parent-acs, parent-tcs, cross-cutting, title-class, effort), ...]`.

---

## Step 4 — Mint or refine Tasks (idempotent contract)

For every tuple in the canonical Task seed list:

- **No matching Task in store** (no `task-*.md` file with the same `(parent-story, parent-acs, cross-cutting)` signature): mint new. Assign `next_TASK_id`. Increment counter. Create `artifacts/07-implementation-tasks/task-NNN.md` from `skills/create-tasks/templates/task.md`.
- **Matching Pending Task exists:** refine fields (per Step 5) in place. Preserve TASK-###. Update `last-updated` frontmatter.
- **Matching Accepted Task exists:** **immutable**. Do not modify any field. Append a review note to Section 13 (Revision History): `Note YYYY-MM-DD: re-run on upstream update — human review of this Task recommended.`
- **Matching Rejected Task exists:** same as Accepted. The TASK-### is permanently retired but the file persists for audit.
- **An Accepted Task references an AC no longer in the SRS canonical list:** append review note + raise `OQ Severity=High`: `"TASK-### references AC-### which is no longer in the SRS. The AC was dropped, deferred, or renamed. Reconcile manually."`
- **An Accepted Task references a parent Story that has been Rejected upstream:** append review note + raise `OQ Severity=Critical`: `"TASK-### references US-### which is now Rejected. The Task is orphaned — Reject TASK-### or restore US-###."`

The skill never restructures: it does not split or merge Tasks, and it does not change a Task's `parent-story` or `parent-acs` on re-run. Restructuring requires explicit human action (Reject the existing Task, edit upstream, re-run).

---

## Step 5 — Populate Task fields

For every Pending Task (do not modify Accepted/Rejected), populate every field. Lift content verbatim from upstream where possible; never invent codebase specifics.

### 5.1 — Title and frontmatter

Title format depends on Task class:

| Class | Title format | Example |
|-------|--------------|---------|
| Per-AC base Task | `Implement: <parent Story title> — <AC summary>` | `Implement: Send Ping — recipient receives within 5s` |
| NFR-threshold Task | `Verify NFR-###: <Measurable Target excerpt>` | `Verify NFR-001: p95 latency under 200ms` |
| Cross-cutting Task | `Cross-cutting: <origin NFR title>` | `Cross-cutting: Session Authentication` |
| Scaffolding Task | `Scaffold logical component <COMP-###>` | `Scaffold logical component COMP-002 (Location Service)` |

Frontmatter: `artifact: implementation-task`, `task-id`, `parent-story`, `parent-acs` (list), `parent-fr` OR `parent-nfr` (whichever applies), `parent-epic`, `parent-tcs` (list), `cross-cutting` (Yes/No), `status: Pending`, `owner` (inherited from parent Story Owner — defaults to the Story's `owner` field), `priority` (inherited from parent FR/NFR Priority), `effort` (per Step 3 heuristic), `created`, `last-updated`.

### 5.2 — Parent Traceability table

Forward chain rendered as a table: Parent Story → Additional Stories (cross-cutting only) → Parent ACs → Parent FR / NFR → Source BUC → Parent Epic → Parent TCs → Stakeholder. Lifted from upstream artefacts; never authored.

### 5.3 — Intent paragraph

One paragraph synthesised from parent Story Description + parent AC Then clause. Plain language, observable-outcome framing. **No code, no file paths, no framework names, no library versions, no class/function/handler/schema/endpoint nouns.** When upstream Story Description leans implementation-prescriptive, rewrite as intent (e.g., upstream "add a /signup endpoint" → Task Intent "deliver signup behaviour that accepts a new user's email, password, and display name").

### 5.4 — Inputs and Outputs

- **Inputs (Section 3):** bullets lifted from the Given clauses of every parent AC. Describe shape in plain language (e.g., "a user identifier (uniquely identifies the actor)"). If the parent ACs imply no specific inputs beyond baseline state: write `(none beyond the system's baseline state)`.
- **Outputs (Section 4):** bullets lifted from the Then clauses. Express as state changes or observable behaviour. If no observable outputs beyond a successful invocation: write `(success indication only)`.

### 5.5 — Technical Context

Bullets lifted from upstream artefacts ONLY. Sources permitted:

- Parent Story Section 8 (Implementation Notes)
- SRS Section 4 (logical component(s) this Task touches, via the SRS Traceability Matrix mapping FR → component)
- SRS Section 5 (NFRs the parent Epic exposes — Performance, Security, Reliability, Compliance, etc.)
- SRS Section 6 (CONs that bind this Task — Regulatory / Technology constraints recorded in the SRS)

The skill **never adds new technical assumptions**. New constraints must originate upstream in `/elicit` or `/create-srs`. If no upstream context applies: write `(none — this Task is unconstrained beyond the project-wide CONs)`.

### 5.6 — Definition of Done (per-Task)

Seed the mandatory items:

- One `[ ] AC-FR-###-NN verified by TC-### (TC result: pass)` line per parent AC, naming the parent TC from the Task's `parent-tcs` list.
- `[ ] No regression in tests for related Stories`
- `[ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target`

Add the delimiter comment `<!-- TEAM-ADDITIONS-BELOW: ... -->` — the skill never touches the region below this comment on re-run. The delivery team adds task-specific DoD items there during sprint planning.

### 5.7 — Dependencies

Populate ONLY when upstream artefacts state a dependency explicitly:

- Parent Story Section 7 (Dependencies) names another Story whose Task this Task depends on — propagate the Story-level dependency to the corresponding Task pair.
- Cross-cutting NFR Tasks block per-Story integration Tasks for the same NFR — the cross-cutting Task is a `Depends on` target for every linked Story's relevant Task.

The skill **never invents dependencies**. Cycles between Pending Tasks generate `OQ Severity=Critical`.

### 5.8 — Effort, Coverage Notes, Owner, Acceptance

- **Effort (Section 8):** per Step 3 heuristic. Carry `**AI estimate — confirm with team.**` Rationale: one sentence naming the driver factor (e.g., "Single AC, no NFR threshold → S").
- **Coverage Notes (Section 9):** which ACs this Task contributes to and which TCs verify it. Cross-reference siblings — e.g., `"Covers AC-FR-001-01 (happy path). The negative-path AC-FR-001-02 is covered by TASK-NNN."`
- **Owner:** parent Story `owner` field (SH-###). Default `Accepted By` to the same.
- **Status:** `Pending`. **Accepted Date:** `—`.
- **Source:** `parent Story US-###; AC list AC-FR-###-NN, ...; TC list TC-###, ...`.

---

## Step 6 — Boundary audit (codebase-awareness validator)

After populating fields, scan every Pending Task's Sections 1, 3, 4, 5, 6, 7, 9 (the body sections the skill authored or lifted into — not Section 2 Parent Traceability, which is structural). **This is the rule that holds the framework's boundary.**

Forbidden patterns (denylist; case-insensitive; matched against the rendered Section text):

| Pattern | Example match |
|---------|---------------|
| File-path-like substrings ending in `.ts/.tsx/.js/.jsx/.py/.go/.rs/.java/.kt/.swift/.rb/.php/.cs/.sql/.yml/.yaml/.json/.toml/.ini` | `src/api/auth.ts`, `models/user.py` |
| Framework names NOT recorded in the SRS Constraints section: `react`, `vue`, `angular`, `express`, `fastapi`, `django`, `flask`, `spring`, `rails`, `next.js`, `nuxt`, `nest`, `gin`, `axum`, `tokio`, `prisma`, `typeorm`, `sequelize`, `mongoose` | `using React`, `add to the Express router` |
| Code fences (triple-backtick blocks containing executable-looking syntax — `function`, `class`, `def`, `func`, `const`, `let`, `var`, `import`, `from .* import`) | any fenced code block with code |
| Class/handler nouns paired with action verbs: `add .* handler`, `create .* controller`, `extend .* class`, `inherit from`, `implement .* interface` | `add a POST handler`, `create UserController` |

Suppression rules (do not flag):

- Matches inside Section 2 (Parent Traceability) — that's structural ID references.
- Matches inside lifted AC text (Given/When/Then) — the SRS authored the language and the Task quotes it verbatim. If a Section legitimately quotes an AC that contains a route path like `/signup`, that is allowed; routes alone are AC content, not codebase specifics.
- Matches inside lifted SRS Constraints quotations (e.g., the SRS records "Technology Constraint: PostgreSQL 14" — the Task may legitimately echo this in Technical Context).

For each unsuppressed hit: raise `OQ Severity=High`:

> `TASK-### contains "<excerpt>" in Section <N>, which looks codebase-specific. Tasks describe intent + contract, not codebase locations. Rewrite as intent — e.g., "deliver signup behaviour that accepts {email, password, displayName}" instead of "add a POST handler in src/api/auth.ts". Suppression: if this content was legitimately lifted from upstream (SRS Constraint, AC text), confirm in the review gate.`

Record the OQ-### in the Task's Section 11 (Boundary Audit). The skill **does not auto-rewrite** the violation — flag it and let the human reviewer decide.

If the Task has no hits: Section 11 reads `"No codebase-specific assumptions detected by /create-tasks Step 6 validation."`

---

## Step 7 — Validation (Pending Tasks only)

Run every check; add OQs at the indicated severity.

1. **Story coverage:** every Accepted Story in the canonical subset has ≥1 Task. Orphan → `Critical`.
2. **AC coverage within a Story:** every AC of every Accepted Story has ≥1 Task contributing to it via `parent-acs`. Orphan → `High`.
3. **Task Owner:** every Pending Task has Owner = SH-###. Missing → `Critical`.
4. **TC linkage:** every Pending Task's `parent-tcs` list is non-empty and every TC-### exists in `artifacts/05-test-concept/`. Missing or dangling → `High`.
5. **Definition of Done seeding:** every Pending Task's Section 6 includes one `[ ] AC-### verified by TC-### (TC result: pass)` line per parent AC. Missing → `High`.
6. **Cross-cutting integrity:** every Task with `cross-cutting: Yes` lists ≥2 Stories in Section 2's "Additional Stories" row and every linked Story is Accepted. Violation → `High`.
7. **Boundary audit:** all Step 6 hits resolved or accepted by the human reviewer. Open Step 6 OQs → `High`.
8. **Effort sanity:** any Story producing ≥7 Tasks → `High` (per Step 3).
9. **Over-decomposition:** two non-cross-cutting Tasks sharing `(parent-story, parent-acs)` → `Medium`: `"US-### may be over-decomposed; consider merging TASK-### and TASK-###."`

Add a one-line summary to `index.md` Section 9: `"Validation: [N] OQs added across coverage / owner / TC-linkage / boundary / effort / decomposition checks."`

---

## Step 8 — Build `index.md`

Always rebuilt from the current state of all `task-*.md` files. Never merged.

Sections (per `skills/create-tasks/templates/index.md`):

1. **Project Overview** — counts (Pending / Accepted / Rejected / Cross-cutting), source SRS version + Accepted date, total Stories in Accepted subset, total Deferred Stories, coverage stats
2. **Task Map** — Mermaid `flowchart LR` with one subgraph per Accepted Story and one separate subgraph for Cross-cutting Tasks (with edges to every linked Story). Numeric-only node IDs (`US001`, `TASK001`). `%%{init: {'theme': 'neutral'}}%%` first line. Short single-phrase labels per vault rules.
3. **Task List** — table with TASK-ID, Title, Parent Story, Parent ACs, Parent TCs, Owner, Priority, Effort, Cross-cutting, Status, file path
4. **Story Coverage Matrix** — every Accepted Story with AC count, Task count, Status (`Covered` / `Deferred` / `Orphan`), Notes
5. **AC Coverage Matrix** — every AC under every Accepted Story with its contributing Task(s) and Status (`Covered` / `Orphan`)
6. **Effort Distribution** — count of Tasks per effort flag (S / M / L) with heuristic reminder
7. **Cross-Cutting Tasks** — table: TASK-ID, Title, Linked Stories, Origin NFR, Effort. If none: `"No cross-cutting Tasks in this Story subset."`
8. **Open Questions** — aggregated from every `task-*.md` + boundary-audit OQs, sorted by Severity
9. **Boundary Audit Summary** — Tasks scanned / Tasks flagged / Flagged Task-OQ pairs. If 0: `"Boundary audit clean — no codebase-specific content detected in any Task."`
10. **Acceptance Status Overview** — TASK-ID, Title, Owner, Status, Accepted Date
11. **Revision History** — append-only; one row per run with summary

---

## Step 9 — Write outputs

1. For each Pending Task with changes: rewrite `artifacts/07-implementation-tasks/task-NNN.md`. Update `last-updated` frontmatter.
2. For each Accepted/Rejected Task with appended review notes: write only Section 13; leave Sections 1–12 untouched.
3. For each newly-minted Task: create from `skills/create-tasks/templates/task.md`.
4. Always rewrite `artifacts/07-implementation-tasks/index.md` from scratch using Step 8 data.

Do not delete files — even Rejected Tasks persist so the TASK-### is auditable.

---

## Step 10 — Review gate

Present to the user:

> **Changes in this run:**
> - **ADDED:** [list new TASK-IDs with parent-story / parent-acs]
> - **REFINED:** [list Pending Tasks updated, with reason]
> - **UNCHANGED:** [list Pending Tasks with no new info, or omit if long]
> - **PROTECTED:** [list Accepted/Rejected Tasks that received review notes only]
> - **BOUNDARY FLAGS:** [list TASK-### / OQ-### pairs from Step 6 validation]
> - **COVERAGE:** [N Accepted Stories in canonical subset; M Tasks minted or refined; orphans: list Story-IDs]
> - **DEFERRED:** [list of Pending Stories whose Tasks are deferred to a future run after they are Accepted]
> - **EFFORT DISTRIBUTION:** [S: N; M: M; L: K]
> - **CROSS-CUTTING:** [list cross-cutting Task IDs with their origin NFR and linked Stories]

If any OQs remain Open:
> **Warning — Unresolved Open Questions:** [table with Severity column]

Then give your **Professional Assessment** — cite specific element IDs:

**Blocking — APPROVED is invalid until resolved:**
- Critical OQs Open: list OQ-### IDs.
- Pending Tasks with no Owner: list TASK-### IDs.
- Pending Tasks with empty `parent-tcs` list: list TASK-### IDs.
- Pending Tasks missing the `[ ] AC-### verified by TC-###` Definition-of-Done line: list TASK-### IDs.
- Orphaned Accepted Stories (no Task): list US-### IDs.
- Open Boundary Audit OQs (Step 6 hits): list TASK-### / OQ-### pairs.

**Advisory — flag before approval:**
- Stories producing ≥7 Tasks (Step 7.8): list US-### with Task count; recommend re-running `/create-stories` after AC split.
- Over-decomposition warnings (Step 7.9): list TASK-### pairs sharing `(parent-story, parent-acs)`.
- Effort distribution heavily skewed L: note it; the heuristic may be flagging Stories that should be split.
- Cross-cutting Tasks whose origin NFR is not marked `Cross-cutting: Yes` in every linked Story's parent Epic: list with the Epic-side correction needed.

If none of these issues exist: state `"No quality concerns — Task set is ready for approval."`

> Review `artifacts/07-implementation-tasks/index.md` first, then drill into each `task-NNN.md`.
> Type **APPROVED** to mark the Task set as the final RE handoff artefact (the Dev-Team's coding agent may now consume it), or provide corrections.
> **Approval is invalid if any Critical OQ is Open, any Accepted Story is orphan, any Pending Task lacks Owner / TC linkage / DoD seed, or any Boundary Audit OQ is Open.**

On APPROVED: update each Pending Task's frontmatter to `status: Accepted` only when the human reviewer signals per-Task Acceptance (the default is partial — the human types `APPROVED` to ratify the entire set, the skill flips Status on whichever Tasks the reviewer named; absent per-Task overrides, the entire Pending set transitions). State `"Implementation-Tasks phase complete. The Dev-Team's coding agent may now consume artifacts/07-implementation-tasks/. Re-run /trace to verify the full SH → BUC → FR → EP → US → AC → TC → TASK chain."` Do not invoke `/trace` automatically.

---

## ID Reference

| Artifact | Format | Example | Source |
|----------|--------|---------|--------|
| Implementation Task | TASK-### | TASK-001 | minted by this skill |
| Open Question | OQ-### | OQ-052 | continues from elicit + epic + story + srs + test namespaces |
| User Story (parent) | US-### | US-001 | inherited from `/create-stories` (not minted here) |
| Acceptance Criterion (parent) | AC-FR-###-NN / AC-NFR-###-NN | AC-FR-001-01 | inherited via the SRS canonical list (not minted here) |
| Test Case (linked) | TC-### | TC-001 | inherited via `/create-tests` (not minted here) |

TASK-### IDs are never reused, even after deletion or rejection. OQ-### IDs are never reused across the entire pipeline namespace.

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| `artifacts/04-srs/srs.md` does not exist or status ≠ Accepted | Stop in Step 0. State current status. |
| `artifacts/03-user-stories/` empty or no Story Accepted under an Accepted Epic | Stop in Step 0. State that at least one Accepted Story under an Accepted Epic is required. |
| Elicit doc has regressed (status no longer Approved) | Stop. Tell the user to re-Approve in `/elicit`. |
| Parent Story was Rejected after a Task was Accepted | Append review note to Task Section 13 + raise `OQ Severity=Critical` ("TASK-### references Rejected US-###"). Do not modify the Accepted Task. |
| Cross-cutting NFR referenced by zero Accepted Stories at run time | No cross-cutting Task minted; the NFR's coverage shows in `index.md` Section 7 as `(no linked Story Accepted yet)`. |
| Boundary audit hit inside a lifted AC text or SRS Constraint quote | Suppressed — not a violation. Skill recognises the lifted region by structural markers (Section 2 table, fenced AC quote blocks). |
| AC drift between SRS and elicit doc | Not checked here — `/trace` at Phase 6 audits drift across the whole pipeline. `/create-tasks` treats SRS Section 8 as canonical and reports the SRS state. |
| Human edited a Task file manually between runs (Pending status) | Read current state as truth; regenerate per Step 9 — manual edits in regenerated sections are overwritten and the user is warned in the review gate. The `<!-- TEAM-ADDITIONS-BELOW -->` region in Section 6 is preserved. |
| Human edited a Task file manually between runs (Accepted status) | Only Section 13 is touched. Manual edits to Sections 1–12 of an Accepted Task are preserved. The skill never silently destabilises Accepted content. |
| Two Pending Tasks with identical `(parent-story, parent-acs, cross-cutting)` signature (defensive — Step 4 should prevent this) | Pick the lower TASK-ID; mark the higher Rejected with note "duplicate of TASK-### — superseded". OQ Severity=High asks the human to confirm. |
| Task whose `parent-tcs` references a TC-### that does not exist in `artifacts/05-test-concept/` | Raise `OQ Severity=High` ("TASK-### references non-existent TC-###"). Leave the Task Pending until reconciled. |
| `artifacts/07-implementation-tasks/` does not exist | Create the directory. Continue. |
| Existing `index.md` was edited manually | Overwrite. Note in Revision History row: `"Note YYYY-MM-DD: previous content overwritten on re-run; manual edits to index.md are not preserved."` |
