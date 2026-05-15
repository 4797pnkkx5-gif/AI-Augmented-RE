# `/create-tasks` Skill (Phase 7) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `/create-tasks` as Phase 7 of the AI-Augmented RE pipeline — a skill that derives developer-sized, codebase-agnostic implementation tasks from Accepted User Stories, and extends `/trace` to audit the new TASK column.

**Architecture:** Phase 7 produces a *handoff artifact* — markdown files describing intent + contract per task, consumed by the Dev-Team's own AI coding agent. The skill follows the exact pattern of the five generative siblings (skill.md + templates/ + evals/), reuses the SH→BUC→FR→EP→US→AC→TC chain by appending TASK, and obeys all existing immutability / OQ-namespace / APPROVED-integrity governance rules. `/trace` is extended once to walk and audit the new column.

**Tech Stack:** Markdown (skill definitions and artefacts), Mermaid for diagrams, YAML frontmatter, shell (setup.sh / sync-framework.sh).

---

## Strategic context (from approved brainstorm)

Source: `/Users/axelburkhardt/.claude/plans/not-i-want-to-gentle-pixel.md` (approved 2026-05-15).

- Consumer: the Dev-Team's own AI coding agent. Their agent maps intent → codebase.
- Tasks describe **intent + contract**, not codebase locations. No file paths, no class names, no library versions, no tech-stack assumptions beyond what the SRS already records as Constraints.
- Inputs allowed: Stories, SRS Sections 4 (logical components) / 5 (NFRs) / 6 (CONs) / 8 (canonical ACs), Test Cases, elicit doc Section 4 component diagrams.
- Inputs forbidden: source code, repo structure, framework choices.
- Out of scope: code generation, PR/commit tooling, agent-prompt engineering, runbooks, sprint/velocity management.

## File Structure

| File | Responsibility | Status |
|------|---------------|--------|
| `skills/create-tasks/skill.md` | Skill definition: gate, steps, validation, review gate, edge cases, ID reference | Create |
| `skills/create-tasks/templates/task.md` | Per-TASK file template (frontmatter + 13 sections) | Create |
| `skills/create-tasks/templates/index.md` | Aggregator template (project overview, task map, coverage matrices, distribution, OQs, revision history) | Create |
| `skills/create-tasks/evals/evals.json` | 3 evals: happy path, gate failure, immutability + cross-cutting | Create |
| `skills/trace/skill.md` | Extend Step 0 detection, Step 1 extract, Step 2/3 matrix columns, Step 4 coverage stats, Step 5 orphans, Step 6 drift, ID Reference, Edge Cases | Modify |
| `skills/trace/templates/traceability-matrix.md` | Render TASK column in forward/backward matrix and add TASK row in coverage table | Modify |
| `skills/GOVERNANCE.md` | Add Phase-7 governance section; bump version 1.7.0 → 1.8.0 | Modify |
| `CLAUDE.md` (framework root) | Add Phase 7 row to pipeline diagram + skill table; update Repository Structure | Modify |
| `AGENTS.md` (framework root) | Add Phase 7 row to RE Pipeline + skill table | Modify |
| `setup/CLAUDE.md.template` | Same as framework CLAUDE.md but project-facing | Modify |
| `setup/AGENTS.md.template` | Same as framework AGENTS.md but project-facing | Modify |
| `setup.sh` | Add `artifacts/07-implementation-tasks` to folder-loop on line 151; update Next Steps text | Modify |
| `sync-framework.sh` | **No change** — rsync include `skills/***` already covers the new dir; verified manually | Verify |
| `examples/07-implementation-tasks/index.md` | Benchmark task-set aggregator derived from PocketPing | Create |
| `examples/07-implementation-tasks/task-NNN.md` | One per derived task (~12–16 files projected from 8 Stories + 14 TCs) | Create |

---

## Design decisions locked in here

These shape multiple downstream tasks. They are **decisions**, not options — task steps assume them.

1. **Upstream gate:** require `artifacts/04-srs/srs.md` `status: Accepted` AND at least one `artifacts/03-user-stories/story-*.md` with `status: Accepted`. Incremental on Stories — operate on the Accepted Story subset; Pending Stories listed in `index.md` as Deferred. The SRS gate is strict because Tasks bind to NFR / CON / component context that must be stable.
2. **Task ID space:** `TASK-###` global, zero-padded to 3, never reused, continues from the highest existing TASK-### across all `task-*.md` files. The shared OQ namespace extends the same way it has across every other generative phase.
3. **Decomposition heuristic (deterministic, published in skill.md):**
   - 1 Story with 1 AC and no Performance/Security NFR exposure → 1 task ("deliver Story behavior; satisfies AC-###; verified by TC-###").
   - 1 Story with multiple ACs (typical: 2–3) → 1 task per AC.
   - Story whose parent FR / Epic carries a Performance, Security, or Reliability NFR with a measurable threshold → 1 extra task ("verify NFR-### threshold via TC-### under measurable conditions").
   - SRS Section 4 introduces a **logical component** that does not yet exist in any prior Story's component-coverage map → 1 scaffolding task ("establish logical component COMP-### per SRS §4; no specific implementation prescribed").
   - Cross-cutting NFR present in `epic-NNN.md` `Cross-cutting: Yes` and referenced by 2+ Stories → 1 cross-cutting task linked to every relevant Story.
   - Effort flag (AI-provisional): S = 1 AC + no NFR, M = 2–3 ACs OR 1 AC + 1 NFR threshold, L = 4+ ACs OR cross-cutting NFR with multi-Story scope. Always carries the note **"AI estimate — confirm with team."**
4. **Boundary enforcement (validation step in skill.md):** task content scanned for forbidden patterns (codebase file extensions like `.ts/.js/.py/.go`, framework names from a denylist of common ones, slashes that look like file paths, code-fence content). Hits → OQ Severity=High asking the author to rewrite as intent.
5. **Per-task fields lifted, never invented:**
   - Inputs / Outputs: derived from AC Given/When/Then (Given = inputs / state; Then = outputs / observable result).
   - Technical Context: lifted from Story §8 (Implementation Notes) + SRS §4 component the Story affects + cross-cutting NFRs from parent Epic.
   - Definition of Done: per-task subset of Story DoD plus "[ ] AC-### verified by TC-### (TC results: pass)".
6. **Re-run immutability:** Accepted/Rejected Tasks are immutable. Only Revision History (Section 13) receives review notes on re-run.
7. **Trace integration:** TASK appears as the final column. Orphan rules:
   - Accepted Story under an Accepted Epic with zero Tasks (after Phase 7 has run) → High.
   - Task whose parent Story is not Accepted → High.
   - Task whose parent AC is not in the SRS canonical list → Critical.
   - Two Tasks sharing the same parent-story AND the same parent-ac AND no cross-cutting flag → Medium (suggests redundant decomposition).
   - Cross-cutting Task linking to non-existent or non-Accepted Stories → High.

---

## Tasks

Each task below is a coherent unit. Markdown content authoring does not decompose into 2-minute TDD bullets; instead each task lists the deliverable, the sections required, and verification steps. Frequent commits at task boundaries.

### Task 1: Scaffold `skills/create-tasks/` directory + write `templates/task.md`

**Files:**
- Create: `skills/create-tasks/templates/task.md`

The per-TASK file template. Mirrors `skills/create-tests/templates/test-case.md` structure exactly.

- [ ] **Step 1: Create directories**

```bash
mkdir -p /Users/axelburkhardt/projects/AI-Augmented-RE/skills/create-tasks/templates
mkdir -p /Users/axelburkhardt/projects/AI-Augmented-RE/skills/create-tasks/evals
```

- [ ] **Step 2: Write `skills/create-tasks/templates/task.md`** with exactly these sections and the frontmatter below.

```yaml
---
artifact: implementation-task
project: <!-- PROJECT_NAME -->
task-id: <!-- TASK-### -->
parent-story: <!-- US-### (primary; cross-cutting tasks list extras in Section 2) -->
parent-acs: <!-- [AC-FR-###-NN, ...] -->
parent-fr: <!-- FR-### or — (omit one of parent-fr/parent-nfr depending on AC type) -->
parent-nfr: <!-- NFR-### or — -->
parent-epic: <!-- EP-### -->
parent-tcs: <!-- [TC-###, ...] (the Test Cases that verify the ACs this task contributes to) -->
cross-cutting: <!-- Yes / No -->
created: <!-- CREATION_DATE -->
last-updated: <!-- LAST_UPDATED_DATE -->
status: Pending
owner: <!-- SH-### (inherited from parent Story owner) -->
priority: <!-- Must Have / Should Have / Could Have / Won't Have (inherited from parent FR/NFR) -->
effort: <!-- S / M / L (AI provisional) -->
reviewed-by: <!-- SH-### -->
approved-date: —
---
```

Then a body with these 13 sections, in this order, each with an HTML comment explaining the lift rules:

1. **Intent** — One paragraph: what behaviour or quality this task delivers, expressed as intent (no HOW). Lifted/synthesised from the parent Story's Description and the relevant AC's Then clause. No code, no file paths, no framework names.
2. **Parent Traceability** — Table: Parent Story | Additional Stories (cross-cutting only) | Parent ACs (list) | Parent FR or NFR | Source BUC | Parent Epic | Parent TCs | Stakeholder.
3. **Inputs** — Bullet list of data shapes / preconditions the task consumes. Derived from the Given clauses of the parent ACs. No code-level types — describe shape in plain language ("a user identifier", "the recipient's email and display name").
4. **Outputs** — Bullet list of observable results the task produces. Derived from the Then clauses of the parent ACs.
5. **Technical Context** — Bullet list lifted from: parent Story Section 8 (Implementation Notes), SRS Section 4 (logical component(s) this task touches), SRS Section 5 (NFRs the parent Epic exposes), SRS Section 6 (CONs that bind). No new technical assumptions. If nothing applies: `(none — this task is unconstrained beyond the project-wide CONs)`.
6. **Definition of Done (per-task)** — Checkbox list. Mandatory items, in order:
   - `[ ] AC-### verified by TC-### (TC result: pass)` — one line per parent AC, naming the parent TC.
   - `[ ] No regression in tests for related Stories.`
   - `[ ] Cross-cutting NFR thresholds (if any) measured per SRS §5 Measurable Target.`
   - The team may add task-specific items below a delimiter comment; the skill seeds only the above.
7. **Dependencies** — Table populated only when upstream artefacts state a dependency (parent Story Section 7, or a cross-cutting NFR shared with another Story). Columns: Type | Target TASK-### | Reason | Source. Do not invent dependencies.
8. **Effort (AI provisional)** — Field: S / M / L. Heuristic published verbatim from skill.md §Decomposition heuristic #3. Carries the line **"AI estimate — confirm with team."**
9. **Coverage Notes** — Which AC(s) this task contributes to and which TC(s) verify it. Cross-references not duplicated narratively beyond Section 2's table.
10. **Open Questions** — Standard table (ID / Question / Severity / Status / Source). OQ-### continues the shared namespace.
11. **Boundary Audit** — One-line confirmation: `"No codebase-specific assumptions detected by /create-tasks Step 6 validation."` If the validation flagged any, the matching OQ-### is referenced here.
12. **Acceptance** — Status / Owner / Accepted By / Accepted Date / Source.
13. **Revision History** — Append-only table. Initial row: `1.0 | <date> | create-tasks skill (initial run) | Initial Task minted from US-### / AC-### / TC-###.`

- [ ] **Step 3: Verify against sibling template structure**

Run: `diff <(grep -E "^## [0-9]+\." skills/create-tests/templates/test-case.md) <(grep -E "^## [0-9]+\." skills/create-tasks/templates/task.md)`
Expected: both have 13 sections, numbered sequentially.

- [ ] **Step 4: Commit**

```bash
git add skills/create-tasks/templates/task.md
git commit -m "feat(skill): create-tasks per-task template (Phase 7)"
```

---

### Task 2: Write `templates/index.md`

**Files:**
- Create: `skills/create-tasks/templates/index.md`

Aggregator. Mirrors `skills/create-tests/templates/index.md`.

- [ ] **Step 1: Write file** with frontmatter `artifact: tasks-index`, `status: Auto-generated`. Body sections in this order, each with one-line lift rule in HTML comments:

1. **Project Overview** — Project name, source SRS version + Accepted date, total Stories in Accepted set, total Tasks (Pending / Accepted / Rejected), total cross-cutting Tasks.
2. **Task Map** — Mermaid `flowchart LR` with Stories as parent nodes branching to Tasks. Numeric-only IDs (`US001`, `TASK001`). Cross-cutting Tasks rendered as a separate subgraph with edges to every linked Story. `%%{init: {'theme': 'neutral'}}%%` first line per vault rules.
3. **Task List** — Table: TASK-ID | Title | Parent Story | Parent ACs | Parent TCs | Owner | Priority | Effort | Cross-cutting | Status | File.
4. **Story Coverage Matrix** — Every Accepted Story with its Tasks. Status: `Covered` / `Deferred` (parent Story Pending) / `Orphan` (Accepted Story with no Tasks). One row per Story.
5. **AC Coverage Matrix** — Every AC under every Accepted Story with the Tasks that satisfy it. Status: `Covered` / `Orphan`.
6. **Effort Distribution** — Count of Tasks per effort flag (S / M / L), plus a note that this is AI-provisional.
7. **Cross-Cutting Tasks** — Table: TASK-ID | Title | Linked Stories | Origin NFR (the NFR that drives cross-cutting). If none: `"No cross-cutting tasks in this Story subset."`
8. **Open Questions** — Aggregated from every task-NNN.md; sorted by Severity.
9. **Boundary Audit Summary** — Count of Tasks flagged by Step 6 validation; list of TASK-### / OQ-### pairs.
10. **Acceptance Status Overview** — Same shape as create-tests index.md Section 8.
11. **Revision History** — Append-only.

- [ ] **Step 2: Commit**

```bash
git add skills/create-tasks/templates/index.md
git commit -m "feat(skill): create-tasks index template (Phase 7)"
```

---

### Task 3: Write `skills/create-tasks/skill.md`

**Files:**
- Create: `skills/create-tasks/skill.md`

The core skill definition. Follow the structure of `skills/create-tests/skill.md` exactly: Purpose → Invocation → Inputs → Outputs → Step 0 → Step 1..N → ID Reference → Edge Cases.

- [ ] **Step 1: Write Purpose paragraph**

> **Purpose:** Decompose every Accepted User Story into developer-sized, codebase-agnostic implementation tasks at `artifacts/07-implementation-tasks/`. Each task describes intent + contract (Inputs, Outputs, Definition of Done) that the Dev-Team's AI coding agent consumes — never source-code locations, framework names, or library versions. Tasks are derived deterministically from a published heuristic over AC count, Story Implementation Notes, NFR exposure on the parent Epic, and SRS §4 component coverage. The skill cross-references the Accepted SRS for stable NFR / CON / component context, raises OQs when the heuristic produces unusual outputs (e.g., a Story decomposes into 7+ tasks), and audits every task for codebase-specific content before writing. Re-runs are idempotent: Pending tasks refined in place, Accepted tasks immutable, TASK-### IDs never reused. Cross-cutting tasks emit once and link to every Story they serve.

- [ ] **Step 2: Write Invocation block**

```
**Invocation:**
- Claude Code: `/create-tasks`
- GitHub Copilot: "Run the create-tasks skill" or "Follow `skills/create-tasks/skill.md`"
```

- [ ] **Step 3: Write Inputs / Outputs**

Inputs:
- `artifacts/04-srs/srs.md` (`status: Accepted`) — required; provides SRS §4 components, §5 NFRs, §6 CONs, §8 canonical AC list
- `artifacts/03-user-stories/story-*.md` — Accepted Story subset is in scope; Pending listed as Deferred in index
- `artifacts/02-epics/epic-*.md` — for Cross-cutting NFR identification
- `artifacts/01-elicitation/elicitation-document.md` — Section 4 component diagrams (logical components only)
- `artifacts/05-test-concept/test-case-*.md` — to map TC-### per AC into the task's parent-tcs field
- `artifacts/07-implementation-tasks/task-*.md` and `index.md` — existing, if any

Outputs:
- `artifacts/07-implementation-tasks/task-NNN.md` — one per task
- `artifacts/07-implementation-tasks/index.md` — always rebuilt

- [ ] **Step 4: Write Step 0 — Approval gate (SRS strict + Story incremental)**

State the rules from Design Decision #1 verbatim. Cite the upstream gates the skill defensively re-checks (elicit Approved, SRS Accepted; no Critical OQ Open across any earlier phase). The skill halts if any rule fails; otherwise it proceeds, operating on the Accepted Story subset.

- [ ] **Step 5: Write Step 1 — Read every upstream artefact**

Reuse the table pattern from create-tests Step 1. Columns: Source | What to extract. Rows for each input above. Build the **canonical Story subset** (all Stories with `status: Accepted` whose parent Epic is also Accepted). This is the source of truth for what tasks must exist.

- [ ] **Step 6: Write Step 2 — Read existing task artefacts**

Walk `artifacts/07-implementation-tasks/task-*.md`. For each: capture TASK-ID, parent-story, parent-acs, parent-tcs, cross-cutting flag, status, owner, effort, OQ refs. Compute `next_TASK_id = max(existing TASK-### across all task files) + 1` and `next_OQ_id` continuing the shared namespace. **TASK-### and OQ-### IDs are never reused.**

- [ ] **Step 7: Write Step 3 — Apply the decomposition heuristic**

State Design Decision #3 verbatim. For each Story in the canonical subset:
- Compute the list of (Story, AC) pairs → one task per pair.
- Compute the list of NFR-threshold tasks for ACs under NFRs with measurable thresholds → one extra task per such AC.
- Compute the list of scaffolding tasks for newly-introduced logical components in SRS §4 → one per component not already covered by a task from a lower-numbered Story.
- Compute the list of cross-cutting tasks per cross-cutting NFR (referenced by 2+ Stories in this run) → one task linked to all matching Stories.

Output: a list of `(parent-story | parent-acs | parent-tcs | cross-cutting | effort)` tuples — the **canonical task seed list** for this run.

- [ ] **Step 8: Write Step 4 — Mint or refine tasks**

Same idempotency contract as create-tests Step 4:
- No matching task in store for a (parent-story, parent-acs) tuple → mint new with `next_TASK_id`. Increment counter. Create from `templates/task.md`.
- Matching Pending task → refine fields in place (Step 5). Preserve TASK-###.
- Matching Accepted task → immutable. Append review note to Section 13.
- Matching Rejected task → same as Accepted; the file persists for audit.
- An Accepted task referencing an AC no longer in the SRS canonical list → append review note + OQ Severity=High.
- An Accepted task whose parent Story has been Rejected upstream → append review note + OQ Severity=Critical (the task is orphaned).

The skill never restructures: it does not merge two tasks into one or split one into two on re-run. Restructuring requires explicit human action (Reject the existing task, edit upstream, re-run).

- [ ] **Step 9: Write Step 5 — Populate task fields**

For every Pending task, populate every field. Lift verbatim from upstream; never invent codebase specifics.

Sub-steps 5.1 through 5.7, mirroring create-tests Step 5:
- 5.1 Title + frontmatter (Title format: `"Implement: <parent Story title>` for single-AC tasks; `"Verify NFR-###: <threshold>"` for NFR-threshold tasks; `"Scaffold component <COMP-###>"` for scaffolding tasks; `"Cross-cutting: <NFR-### title>"` for cross-cutting tasks).
- 5.2 Parent Traceability table from Story + AC + TC links.
- 5.3 Intent paragraph synthesised from parent Story Description + AC Then clause.
- 5.4 Inputs from AC Given clauses; Outputs from AC Then clauses.
- 5.5 Technical Context from Story §8 + SRS §4/5/6 (component / NFR / CON references). State: **"This section lists ONLY content lifted from upstream. The skill never adds new technical assumptions."**
- 5.6 Definition of Done — seeds the mandatory items per Design Decision #5.
- 5.7 Effort field per published heuristic.

- [ ] **Step 10: Write Step 6 — Boundary audit (the codebase-awareness validator)**

After populating fields, scan the task content for forbidden patterns. **This is the rule that makes the framework hold its boundary.**

Forbidden patterns (denylist; case-insensitive; matched against rendered task content):
- File-path-like substrings matching `[\w/_-]+\.(ts|tsx|js|jsx|py|go|rs|java|kt|swift|rb|php|cs|sql|yml|yaml|json|toml|ini)`
- Framework names not present in the SRS Constraints section (a configurable list): `react`, `vue`, `angular`, `express`, `fastapi`, `django`, `flask`, `spring`, `rails`, `next.js`, `nuxt`, `nest`, `gin`, `axum`, `tokio`, `prisma`, `typeorm`, `sequelize`, `mongoose`
- Code fences (triple-backtick blocks containing executable-looking syntax — `function`, `class`, `def`, `func`, `const`, `import`, `from .* import`)
- Slash-prefixed paths that look like routes paired with HTTP verbs ONLY if accompanied by a function/class name from the previous bullet (raw routes like `/signup` are AC content and allowed)

For each hit: raise OQ Severity=High: `"TASK-### contains '<excerpt>' which looks codebase-specific. Tasks describe intent + contract, not codebase locations. Rewrite as intent (e.g., 'deliver signup behaviour' instead of 'add handler in src/auth.ts')."` Record the OQ-### in the task's Section 11 (Boundary Audit). Do not auto-rewrite — flag and let the human reviewer decide.

If a denylisted framework name appears as text inside an AC or NFR that was lifted from upstream (the SRS or elicit doc legitimately mentions e.g. "PostgreSQL"): do not raise OQ. The validator skips matches inside `parent-traceability`, lifted AC Given/When/Then text, and lifted SRS quotations.

- [ ] **Step 11: Write Step 7 — Validation**

Run every check; add OQs at the indicated severity:
1. **Story coverage:** every Accepted Story in canonical subset has ≥1 Task. Orphan → `Critical`.
2. **AC coverage within a Story:** every AC of every Accepted Story has ≥1 Task contributing to it. Orphan → `High`.
3. **Task owner:** every Pending Task has Owner = SH-###. Missing → `Critical`.
4. **TC linkage:** every Pending Task's parent-tcs list is non-empty and every TC-### exists in `artifacts/05-test-concept/`. Missing or dangling → `High`.
5. **Definition of Done:** every Pending Task's Section 6 includes one `[ ] AC-### verified by TC-### (TC result: pass)` line per parent AC. Missing → `High`.
6. **Cross-cutting integrity:** every cross-cutting Task lists ≥2 Stories in Section 2 and the linked Stories are all Accepted. Violation → `High`.
7. **Boundary audit:** all Step 6 hits resolved or accepted by the human. Open Step 6 OQs → `High`.
8. **Effort sanity:** any Story producing 7+ Tasks → `High` ("Story likely needs splitting upstream — consider re-running /create-stories with an additional AC pass").

Add a one-line summary to `index.md` Section 9.

- [ ] **Step 12: Write Step 8 — Build `index.md`**

State that the file is always rebuilt from the current state of `task-*.md` files. Reference Task 2's template for the section list.

- [ ] **Step 13: Write Step 9 — Write outputs**

Same idempotency as create-tests Step 9, adapted for task files.

- [ ] **Step 14: Write Step 10 — Review gate**

Present to the user:
```
**Changes in this run:**
- **ADDED:** [list new TASK-IDs with parent-story / parent-acs]
- **REFINED:** [Pending tasks updated, with reason]
- **UNCHANGED:** [Pending tasks with no new info, or omit if long]
- **PROTECTED:** [Accepted/Rejected tasks that received review notes only]
- **BOUNDARY FLAGS:** [list TASK-### / OQ-### pairs from Step 6 validation]
- **COVERAGE:** [N Accepted Stories in canonical subset; M tasks minted or refined; orphans: list Story-IDs]
- **DEFERRED:** [list of Pending Stories whose tasks are deferred to a future run after they are Accepted]
- **EFFORT DISTRIBUTION:** [S: N; M: M; L: K]
```

Professional Assessment, blockers vs advisory, mirroring create-tests Step 10. Approval valid only when no Critical OQ Open, every Accepted Story has Tasks, every Pending Task has Owner + TC linkage + DoD, and no Boundary Audit Step 6 OQ is unresolved.

On APPROVED: state `"Implementation-Tasks phase complete. The Dev-Team's coding agent may now consume artifacts/07-implementation-tasks/. Re-run /trace to verify TASK column traceability."`

- [ ] **Step 15: Write ID Reference and Edge Cases**

| Artifact | Format | Example | Source |
|----------|--------|---------|--------|
| Implementation Task | TASK-### | TASK-001 | minted by this skill |
| Open Question | OQ-### | OQ-052 | continues from elicit + epic + story + srs + test namespaces |

Edge Cases table — at minimum:
- SRS not Accepted → stop in Step 0.
- No Accepted Story yet → stop with a message naming current Story states.
- Parent Story was Rejected after a task was Accepted → append review note + Critical OQ.
- Cross-cutting NFR referenced by zero Accepted Stories at run time → no cross-cutting task minted; the NFR's coverage shows in index.md Section 7 as `(no linked Story Accepted yet)`.
- Boundary audit hit inside a lifted AC text → suppress (not a violation; the SRS authored it).
- Human manually edited a task file between runs (Pending) → regenerate, warn in review gate; (Accepted) → only Section 13 touched.

- [ ] **Step 16: Verify skill.md structure matches sibling pattern**

Run: `grep -E "^## " skills/create-tasks/skill.md | head -20`
Expected: `Step 0 — Approval gate ...`, `Step 1 — Read every upstream artefact`, `Step 2 — Read existing task artefacts`, ..., `Step 10 — Review gate`, `ID Reference`, `Edge Cases`.

- [ ] **Step 17: Commit**

```bash
git add skills/create-tasks/skill.md
git commit -m "feat(skill): create-tasks skill definition (Phase 7)"
```

---

### Task 4: Write `skills/create-tasks/evals/evals.json`

**Files:**
- Create: `skills/create-tasks/evals/evals.json`

Three evals — same shape as create-tests:

- [ ] **Step 1: Write the file**

```json
{
  "skill_name": "create-tasks",
  "evals": [
    {
      "id": 1,
      "name": "happy-path-pocketping-stories-accepted",
      "prompt": "All 8 PocketPing Stories are Accepted and the SRS is Accepted. Run /create-tasks to decompose them into implementation tasks. Save outputs to outputs/.",
      "expected_output": "task-NNN.md per (Story, AC) pair (PocketPing has 14 ACs across 8 Stories → 14 base tasks). Plus NFR-threshold tasks for NFR-001/002/003/004 (4 extra tasks). Plus 1-2 cross-cutting tasks if any cross-cutting NFR is shared across 2+ Stories. index.md aggregates with Task Map (Stories → Tasks), Story Coverage Matrix, AC Coverage Matrix, Effort Distribution. No task contains codebase-specific content; boundary audit clean. Total tasks ~16-20.",
      "files": [],
      "assertions": []
    },
    {
      "id": 2,
      "name": "gate-failure-srs-pending",
      "prompt": "Decompose the PocketPing Stories into implementation tasks. The SRS may not be Accepted yet.",
      "expected_output": "Step 0 halts with a clear message: artifacts/04-srs/srs.md is `<current status>`, not Accepted. The SRS must be Accepted before /create-tasks runs. No task files written.",
      "files": [],
      "assertions": []
    },
    {
      "id": 3,
      "name": "boundary-audit-flags-codebase-leak",
      "prompt": "Run /create-tasks against the PocketPing Accepted Stories. Note: a previous run accidentally produced TASK-001 with the Intent 'Add a POST handler to src/api/auth.ts using the existing UserService class'. Re-run the skill and audit.",
      "expected_output": "Step 6 boundary audit flags TASK-001 with OQ Severity=High naming the offending phrase ('src/api/auth.ts', 'UserService'). The task's Section 11 (Boundary Audit) records the OQ-### reference. The task itself is not auto-rewritten — the human reviewer must edit it or re-run after the human strips codebase specifics.",
      "files": [],
      "assertions": []
    }
  ]
}
```

- [ ] **Step 2: Commit**

```bash
git add skills/create-tasks/evals/evals.json
git commit -m "feat(skill): create-tasks evals (Phase 7)"
```

---

### Task 5: Extend `skills/trace/skill.md` for TASK column

**Files:**
- Modify: `skills/trace/skill.md`

Extend, do not rewrite. Five concrete edit points:

- [ ] **Step 1: Step 0 detection table — add Phase 7 row**

Edit the table in `## Step 0 — No gate; gracefully detect the pipeline state`. After the Phase 5 (Tests) row, add:

```
| 6 — Tasks | `artifacts/07-implementation-tasks/` contains at least one `task-*.md` | Note "Tasks not yet generated"; matrix shows `—` for the TASK column |
```

Note: the row is labelled "6 — Tasks" because `/trace` is the auditor running after Phase 7; in the trace skill's own numbering, "6 — Tasks" is the sixth detection row (the original Phase 6 is the trace skill itself and doesn't appear in its own detection table). Verify this matches the existing pattern in the file.

- [ ] **Step 2: Step 1 extract table — add Task row**

In `## Step 1 — Read every available artefact`, after the Test Case row, add:

```
| Task files | TASK-### (parent-story, parent-acs, parent-tcs, parent-epic, cross-cutting flag, owner, effort, status), Source field (cross-cutting linkage) |
```

- [ ] **Step 3: Step 2 forward matrix — add TASK column**

In `## Step 2 — Build the Forward Trace Matrix`:
- Add to the chain narrative: `... AC → TC → TASK`.
- Add to the join list: `"TC is verified by TASK via TASK's parent-tcs frontmatter list"`.
- Update the rendered Markdown table column list: `SH | BUC | FR / NFR | EP | US | AC | TC | TASK`. Sort rows by SH → BUC → FR/NFR → AC → TASK.

Note: NFR rows often have `—` in the US column AND `—` in the TASK column (NFR-threshold tasks attach to TASKs, not Stories). This is correct, not a defect.

- [ ] **Step 4: Step 3 backward matrix — start from TASK**

Update the narrative: backward matrix sorts by TASK → TC → AC → FR/NFR → EP → US → BUC → SH.

- [ ] **Step 5: Step 4 coverage stats — add Tasks row**

Add to the coverage table:

```
| Tasks | total Pending / Accepted / Rejected; cross-cutting count separately |
```

- [ ] **Step 6: Step 5 orphan reports — add four new orphan kinds**

Append to the orphan-kind table:

```
| Accepted Story under Accepted Epic with no Task (Tasks phase has run) | High |
| Task whose parent Story is not Accepted | High |
| Task whose parent AC is not in the SRS canonical list | Critical |
| Two non-cross-cutting Tasks sharing the same parent-story + parent-ac | Medium |
| Cross-cutting Task linked to non-existent Story | High |
```

- [ ] **Step 7: Step 6 drift detection — add Task drift checks**

Append to the pairs table:

```
| AC text in SRS Section 8 vs the same AC reproduced (if any) in `task-NNN.md` Section 2 traceability | exact string equality |
```

(Tasks reference ACs by ID in Section 2; if the human added AC text to the task body manually, drift detection compares it. The skill itself only writes IDs, not AC text, so this drift check is defensive.)

- [ ] **Step 8: Step 7 impact analysis — extend example**

Add to the Pending/Rejected dependency list one more line in the existing FR-005 example:
```
> - TASK-NNN, TASK-MMM (parent-acs include AC-FR-005-* children)
```

- [ ] **Step 9: Edge cases — add Task-related rows**

Append:
```
| Task references AC-### no longer in SRS canonical list | List as Critical orphan "Task referencing non-existent AC in SRS". |
| Two Tasks share parent-story + parent-acs + cross-cutting=No | List as Medium orphan: "Story may be over-decomposed; consider merging tasks". |
```

- [ ] **Step 10: Commit**

```bash
git add skills/trace/skill.md
git commit -m "feat(trace): audit TASK column (Phase 7 integration)"
```

---

### Task 6: Extend `skills/trace/templates/traceability-matrix.md`

**Files:**
- Modify: `skills/trace/templates/traceability-matrix.md`

- [ ] **Step 1: Read current template**

```bash
cat skills/trace/templates/traceability-matrix.md | head -80
```

- [ ] **Step 2: Add TASK column to forward matrix table header and example row**

Find the forward matrix table and add `| TASK |` to the header and the row(s).

- [ ] **Step 3: Add TASK column to backward matrix table header and example row**

Same edit, mirrored.

- [ ] **Step 4: Add Tasks row to coverage table**

```
| Tasks | <!-- total --> | <!-- covered --> | <!-- % --> |
```

- [ ] **Step 5: Add new orphan-kind row examples**

For each of the 5 new orphan kinds in Task 5 Step 6, add an example row to the orphans section example.

- [ ] **Step 6: Commit**

```bash
git add skills/trace/templates/traceability-matrix.md
git commit -m "feat(trace): TASK column in traceability matrix template"
```

---

### Task 7: Update `skills/GOVERNANCE.md`

**Files:**
- Modify: `skills/GOVERNANCE.md`

- [ ] **Step 1: Bump version + last-updated**

Edit lines 3-4: `Version: 1.7.0` → `Version: 1.8.0`. `Last updated: 2026-05-08` → `Last updated: 2026-05-15`.

- [ ] **Step 2: Add new section after "Trace-Phase" section**

Append a new top-level section `## Implementation-Tasks-Phase Governance Rules` with these sub-sections (paragraphs follow the same shape as the existing Test-Phase rules):

1. **Upstream gate (strict on SRS + incremental on Stories):** SHALL refuse to run unless SRS is Accepted AND at least one Story is Accepted under an Accepted Epic. Defensive re-check that the elicit doc has `status: Approved`. Reason for SRS strictness: tasks bind to NFR / CON / component context which must be stable. Reason for Story incrementality: lets large projects deliver tasks for completed Stories without serialising on the full set.
2. **Story-to-Task mapping rule:** every Accepted Story under an Accepted Epic SHALL produce at least one Task. Multiple Tasks per Story are allowed (and expected) when ACs decompose naturally. Two non-cross-cutting Tasks sharing the same `parent-story + parent-acs` is a structural defect → `OQ Severity=Medium` ("Story may be over-decomposed; consider merging tasks").
3. **AC contribution rule:** every AC of an Accepted Story SHALL be referenced by at least one Task's `parent-acs` list. AC orphan → `OQ Severity=High`.
4. **TC linkage rule:** every Pending Task's `parent-tcs` list SHALL be non-empty and every TC-### SHALL exist in `artifacts/05-test-concept/`. Dangling TC reference → `OQ Severity=High`. Reason: tasks describe intent + contract; the contract is verified by TCs. A task without TC linkage cannot be Accepted.
5. **Definition of Done rule:** every Pending Task's Section 6 SHALL include one `[ ] AC-### verified by TC-### (TC result: pass)` line per parent AC. Missing → `OQ Severity=High`. The team may add task-specific DoD items below a delimiter comment; the skill seeds only the AC/TC items and the standard regression / NFR-threshold lines.
6. **Codebase-agnosticism rule (boundary enforcement):** Tasks SHALL NOT reference Dev-Team source-code file paths, class names, function names, framework names not present in the SRS Constraints section, or library versions. The skill validates this in Step 6 (boundary audit) by scanning task content against a denylist and raises `OQ Severity=High` per violation. The skill SHALL NOT auto-rewrite the violation; the human reviewer either edits the task to remove the leak or accepts the OQ with a justification. Rationale: the framework has no access to the Dev-Team's repo; the task is an intent + contract handoff, not an implementation prescription.
7. **Cross-cutting task rule:** a Task whose `cross-cutting` frontmatter is `Yes` SHALL list ≥2 parent Stories in Section 2 and the origin NFR (whose `Business Use Case` field is multi-BUC or `General` / blank per the cross-cutting NFR rule from the Epic phase) MUST be the same NFR in every linked Story's parent Epic's `Cross-cutting NFRs` table. Cross-cutting tasks are minted once and reused. Violation → `OQ Severity=High`.
8. **Effort provisional rule:** the `effort` field on every Pending Task carries a T-shirt size (S / M / L) derived from a published heuristic over AC count, NFR exposure, and cross-cutting scope. The estimate is **AI-provisional** and MUST carry the note `**AI estimate — confirm with team.**` A Story producing 7+ Tasks triggers `OQ Severity=High` asking the human to consider re-running `/create-stories` after adding ACs that split the Story.
9. **Re-run immutability rule:** Accepted and Rejected Tasks are immutable. On re-run, the skill MUST NOT modify any field of a Task with `Status = Accepted` or `Status = Rejected`. New information appears as a review note appended to Section 13.
10. **OQ namespace continuity rule:** the `OQ-###` namespace is shared across the Elicitation Document, every Epic file, every Story file, the SRS, every Test Case file, and every Task file. New OQs continue numbering from the highest existing OQ-###. IDs are never reused.
11. **Implementation-Tasks-phase APPROVED integrity:** APPROVED is invalid if any of:
    - Any Open Question with Severity = Critical raised by `/create-tasks` is Open.
    - Any Pending Task has no Owner.
    - Any Pending Task has empty `parent-tcs` list.
    - Any Pending Task is missing the `[ ] AC-### verified by TC-###` DoD line.
    - Any Accepted Story under an Accepted Epic has no Task.
    - Any non-resolved Step 6 boundary-audit OQ is Open.

The skill SHALL state every blocker explicitly in the review gate before presenting the APPROVED prompt.

- [ ] **Step 3: Update Trace-Phase note**

In the existing `## Trace-Phase (read-only auditor — no governance gate)` section, append to the first paragraph: `"The matrix now extends through the TASK column added in Phase 7; orphan rules for Tasks are enforced by /create-tasks, not /trace."`

- [ ] **Step 4: Commit**

```bash
git add skills/GOVERNANCE.md
git commit -m "feat(governance): Phase-7 (Implementation Tasks) governance rules; v1.8.0"
```

---

### Task 8: Update framework-root `CLAUDE.md` and `AGENTS.md`

**Files:**
- Modify: `CLAUDE.md`
- Modify: `AGENTS.md`

- [ ] **Step 1: Update `CLAUDE.md` Pipeline diagram**

Find the ASCII pipeline diagram (currently ending at Test Cases). Extend:

```
Raw Inputs → Elicitation Document → Epics → User Stories → SRS → Test Cases → Implementation Tasks
                                                                                    ↑ review gate
```

Adjust spacing as needed to fit.

- [ ] **Step 2: Update `CLAUDE.md` skills table**

After the `/trace` row, add:

```
| 7 | `/create-tasks` | Implementation Tasks |
```

Renumber `/trace` to Phase 6 if needed (it already is). Result: Phase 6 is `/trace`, Phase 7 is `/create-tasks`. **Re-verify the existing numbering before editing.**

- [ ] **Step 3: Update `CLAUDE.md` Repository Structure**

Add after `skills/trace/` block:

```
│   └── create-tasks/
│       ├── skill.md             — /create-tasks skill definition (Phase 7)
│       ├── templates/
│       │   ├── task.md          — per-Task file template
│       │   └── index.md         — Tasks aggregator/index template
│       └── evals/
│           └── evals.json       — skill-creator iteration-1 test prompts
```

And add to `examples/`:
```
│   └── 07-implementation-tasks/
│       ├── index.md
│       └── task-001..NNN.md     — benchmark Task set derived from the PocketPing chain
```

And add to `artifacts/`:
```
    └── 07-implementation-tasks/
```

- [ ] **Step 4: Update Architecture block**

In the `## Architecture — Hybrid: Pipeline Agent + Phase Skills` block, after the `/trace` line, add:

```
└── /create-tasks skill   — decomposes Accepted Stories into developer-sized implementation tasks (Phase 7)
```

- [ ] **Step 5: Update Traceability ID Chain**

Replace `SH-001 → BUC-001 → FR-001 → EP-001 → US-001 → TC-001` with `SH-001 → BUC-001 → FR-001 → EP-001 → US-001 → TC-001 → TASK-001`.

- [ ] **Step 6: Update `AGENTS.md`**

Same Pipeline and skills table updates. AGENTS.md does not have the Repository Structure block — keep updates to the pipeline + skills table only.

- [ ] **Step 7: Commit**

```bash
git add CLAUDE.md AGENTS.md
git commit -m "docs: add Phase 7 (create-tasks) to framework-root CLAUDE.md and AGENTS.md"
```

---

### Task 9: Update `setup/CLAUDE.md.template` and `setup/AGENTS.md.template`

**Files:**
- Modify: `setup/CLAUDE.md.template`
- Modify: `setup/AGENTS.md.template`

The project-facing templates. They mirror the framework-root files but use `<!-- PROJECT_NAME -->` placeholders.

- [ ] **Step 1: Read each template**

```bash
cat setup/CLAUDE.md.template | head -100
cat setup/AGENTS.md.template | head -100
```

- [ ] **Step 2: Apply the same pipeline + skills table + ID-chain edits as Task 8**

Do NOT add the framework-development Repository Structure block — these are project-facing. Project templates may have a different structure (artefact-folder list rather than skill-tree). Follow whatever pattern the template currently uses for skills + artefact folders and add Phase 7 row(s).

- [ ] **Step 3: Commit**

```bash
git add setup/CLAUDE.md.template setup/AGENTS.md.template
git commit -m "docs(setup): add Phase 7 to project-facing CLAUDE.md and AGENTS.md templates"
```

---

### Task 10: Update `setup.sh` (folder loop + Next Steps text)

**Files:**
- Modify: `setup.sh`

- [ ] **Step 1: Add Phase 7 folder to the for-loop on line ~151**

Current:
```bash
for folder in artifacts/01-elicitation artifacts/02-epics artifacts/03-user-stories artifacts/04-srs artifacts/05-test-concept artifacts/06-traceability; do
```

After:
```bash
for folder in artifacts/01-elicitation artifacts/02-epics artifacts/03-user-stories artifacts/04-srs artifacts/05-test-concept artifacts/06-traceability artifacts/07-implementation-tasks; do
```

And update the success message: `success "Artifact folders ready (01 through 06)"` → `success "Artifact folders ready (01 through 07)"`.

- [ ] **Step 2: Update vault project-index template** (the heredoc around line 188)

Add a row to the RE Pipeline table:
```
| Implementation Tasks | `/create-tasks` | Pending |
```

- [ ] **Step 3: Update Next Steps echo block at the bottom**

After the `/create-stories` step (currently the last one mentioned), add:

```bash
echo
echo "  7. Continue with /create-srs → /create-tests → /trace"
echo
echo "  8. Continue with /create-tasks — decomposes Accepted Stories into developer-"
echo "     sized implementation tasks in artifacts/07-implementation-tasks/. The"
echo "     output is the hand-off artefact the Dev-Team's coding agent consumes."
```

- [ ] **Step 4: Update calibration examples block**

```bash
echo "  examples/04-srs/                                         — SRS compiled from elicit + epics + stories"
echo "  examples/05-test-concept/                                — Test Concept + Test Cases derived from the SRS"
echo "  examples/06-traceability/                                — Traceability Matrix produced by /trace"
echo "  examples/07-implementation-tasks/                        — Implementation Tasks derived from Accepted Stories"
```

- [ ] **Step 5: Smoke-test the script**

```bash
cd /tmp && rm -rf rl-setup-test && /Users/axelburkhardt/projects/AI-Augmented-RE/setup.sh /tmp/rl-setup-test <<< $'Setup-Test\nn\n' && ls /tmp/rl-setup-test/artifacts/
```
Expected: directory listing shows `01-elicitation/  02-epics/  03-user-stories/  04-srs/  05-test-concept/  06-traceability/  07-implementation-tasks/`.

Clean up:
```bash
rm -rf /tmp/rl-setup-test
```

- [ ] **Step 6: Commit**

```bash
git add setup.sh
git commit -m "feat(setup): bootstrap artifacts/07-implementation-tasks/ for Phase 7"
```

---

### Task 11: Verify `sync-framework.sh` (no code change expected)

**Files:**
- Verify only: `sync-framework.sh`

- [ ] **Step 1: Dry-run against an existing project**

```bash
cd /Users/axelburkhardt/projects/AI-Augmented-RE
./sync-framework.sh ~/projects/linked-locket
```
Reply `n` when prompted to proceed (we don't want to actually sync until everything is committed). Expected: the dry-run lists `skills/create-tasks/skill.md`, `skills/create-tasks/templates/task.md`, `skills/create-tasks/templates/index.md`, `skills/create-tasks/evals/evals.json`, and any updates to `skills/trace/skill.md`, `skills/trace/templates/traceability-matrix.md`, `skills/GOVERNANCE.md`, `setup.sh`, `setup/CLAUDE.md.template`, `setup/AGENTS.md.template`.

If anything is missing from the dry-run output, sync-framework.sh's rsync includes need investigation — but the include `skills/***` should catch the new subdir automatically.

- [ ] **Step 2: No commit; this was a verification step.**

---

### Task 12: Produce `examples/07-implementation-tasks/` benchmark

**Files:**
- Create: `examples/07-implementation-tasks/index.md`
- Create: `examples/07-implementation-tasks/task-001.md` through `task-NNN.md` (NNN = number minted)

Reuse the PocketPing chain: 8 Stories (US-001..US-008), 14 ACs, 14 TCs.

- [ ] **Step 1: Read every PocketPing Story file**

```bash
for f in examples/03-user-stories/story-*.md; do echo "=== $f ==="; cat "$f"; done | head -400
```

- [ ] **Step 2: Read every PocketPing Test Case file**

```bash
for f in examples/05-test-concept/test-case-*.md; do echo "=== $f ==="; cat "$f"; done | head -400
```

- [ ] **Step 3: Read PocketPing SRS Section 4 (components) and Section 5 (NFRs)**

```bash
sed -n '/^## 4\./,/^## 5\./p' examples/04-srs/srs.md
sed -n '/^## 5\./,/^## 6\./p' examples/04-srs/srs.md
```

- [ ] **Step 4: Apply the decomposition heuristic mentally**

Produce the canonical task seed list:
- 1 base task per (Story, AC) pair → 14 base tasks (one per AC, named by Story).
- NFR-threshold tasks for NFR-001..NFR-004 — if those NFRs have Measurable Targets that are not already verified by a base task's TC, mint extras. Typically 1 per NFR with a measurable threshold → ~3 extra tasks (skip NFR-004 if it has no measurable target — check the SRS).
- Cross-cutting tasks: identify any NFR marked `Cross-cutting: Yes` in any Epic and referenced by 2+ Stories. PocketPing's session-authentication NFR (NFR-002) is the most likely candidate → 1 cross-cutting task.
- Scaffolding tasks for SRS §4 components: skip — the PocketPing benchmark is small and base tasks cover component scaffolding implicitly.

Total expected: ~16-18 tasks.

- [ ] **Step 5: For each task, write `task-NNN.md`**

Use the template from Task 1. Per file:
- frontmatter: `task-id: TASK-NNN`, `status: Pending`, `owner: SH-### (inherited)`, `effort: S/M/L per heuristic`, `cross-cutting: Yes/No`.
- Intent paragraph: describe what the task delivers in plain language. **No code, no file paths, no framework names.** Lifted from Story Description + AC Then clause.
- Parent Traceability table with concrete IDs.
- Inputs (from Given) and Outputs (from Then).
- Technical Context: lifted bullets from Story §8 + SRS §4/5/6.
- DoD seeded with `[ ] AC-FR-###-NN verified by TC-### (TC result: pass)`.
- Effort flag per heuristic.
- Coverage Notes: state which ACs and TCs this task touches.
- Section 11 Boundary Audit: `"No codebase-specific assumptions detected by /create-tasks Step 6 validation."`
- Revision History: `1.0 | 2026-05-15 | create-tasks skill (initial run) | Initial Task minted from US-### / AC-### / TC-###.`

**Boundary discipline self-check while writing each one:** if the Intent paragraph contains the word "endpoint", "handler", "schema", "table", "function", "class" — replace with intent-language ("behaviour that accepts X and produces Y", "state change that records X", "interface that exposes X to clients"). The benchmark must read as a coding-agent prompt, not a code review.

- [ ] **Step 6: Write `index.md`**

Use the template from Task 2. Populate every section with concrete data. Mermaid Task Map renders 8 Story subgraphs each containing their tasks, plus a separate Cross-cutting subgraph.

- [ ] **Step 7: Smoke check the example**

```bash
ls examples/07-implementation-tasks/
grep -l "src/" examples/07-implementation-tasks/task-*.md && echo "BOUNDARY VIOLATION" || echo "boundary clean"
grep -l "function\|class\|import " examples/07-implementation-tasks/task-*.md && echo "BOUNDARY VIOLATION" || echo "boundary clean"
```
Both checks: `boundary clean`. If any task triggers the violation, rewrite it.

- [ ] **Step 8: Commit**

```bash
git add examples/07-implementation-tasks/
git commit -m "docs(examples): Phase-7 benchmark — Implementation Tasks for PocketPing"
```

---

### Task 13: Final verification — run `/trace` mentally on the benchmark

**Files:**
- Read-only: every benchmark artefact

- [ ] **Step 1: Verify TASK forward-chain rendering**

For each PocketPing Story US-001..US-008, confirm:
- At least one TASK-### exists with `parent-story: US-###`
- The TASK-###'s `parent-acs` covers every AC of US-### (cross-reference with examples/03-user-stories/story-NNN.md Section 4)
- The TASK-###'s `parent-tcs` references TCs that exist in examples/05-test-concept/

- [ ] **Step 2: Verify no orphan ACs**

For each AC in the SRS canonical list (examples/04-srs/srs.md Section 8), confirm at least one Task lists it in `parent-acs`.

- [ ] **Step 3: Verify cross-cutting task is well-formed**

If a cross-cutting task was minted, confirm:
- `cross-cutting: Yes`
- ≥2 stories in Section 2's additional-stories field
- the origin NFR is the same in every linked Story's parent Epic's Cross-cutting table

- [ ] **Step 4: Boundary audit on every example task file**

Grep for the forbidden patterns (Task 12 Step 7). All checks `boundary clean`.

- [ ] **Step 5: Re-render the trace matrix manually**

Build a small Markdown table for the first 3 PocketPing Stories with columns `SH | BUC | FR | EP | US | AC | TC | TASK`. Confirm every cell is populated and consistent with the underlying example files.

- [ ] **Step 6: Done — mark all tasks complete**

```bash
git log --oneline | head -12
```
Expected: 12 commits — one per task in this plan plus the planning commit.

---

## Verification

End-to-end, when the plan is complete:

1. Run `setup.sh /tmp/phase7-verify` (project name "Phase7"), confirm `artifacts/07-implementation-tasks/` exists.
2. Confirm `sync-framework.sh ~/projects/linked-locket` dry-run lists every changed/new framework file.
3. Confirm `examples/07-implementation-tasks/` has ≥14 tasks, all with `boundary clean` per the grep checks.
4. Confirm the framework-root `CLAUDE.md` and `AGENTS.md` show Phase 7 in their tables.
5. Confirm `skills/GOVERNANCE.md` is `Version: 1.8.0` and includes the Implementation-Tasks-Phase section.
6. Confirm `skills/trace/skill.md` Step 2 forward matrix includes the TASK column.

If all six pass, Phase 7 is integrated.

## Spec coverage self-review

Strategic plan items mapped to tasks:
- "Skill: skills/create-tasks/skill.md" → Task 3
- "Templates: skills/create-tasks/templates/task.md + templates/index.md" → Tasks 1, 2
- "Evals: skills/create-tasks/evals/evals.json" → Task 4
- "Output dir: artifacts/07-implementation-tasks/" → Task 10
- "ID space: TASK-### global" → Task 3 Step 6, Task 3 Step 15, Task 7 Step 2
- "Required/optional inputs" → Task 3 Step 3
- "Per-task fields" → Task 1 (template), Task 3 Step 9 (population)
- "Boundary rules — no architecture decisions" → Task 3 Step 10 (Step 6 boundary audit), Task 7 Step 2 (governance rule 6)
- "Trace integration: extend /trace to walk TC → TASK" → Tasks 5, 6
- "Orphan rules" → Task 5 Step 6, Task 7 Step 2 (governance rule 11)
- "CLAUDE.md / AGENTS.md / setup.sh / sync-framework.sh updates" → Tasks 8, 9, 10, 11
- "Examples: examples/07-implementation-tasks/ from PocketPing" → Task 12

No gaps. No placeholders. Type/method consistency: `parent-tcs` (plural list), `parent-story` (singular), `parent-acs` (plural list), `TASK-###`, `OQ-###`, `cross-cutting: Yes/No`, `effort: S/M/L`, `status: Pending/Accepted/Rejected` — used consistently across Tasks 1, 2, 3, 5, 7.
