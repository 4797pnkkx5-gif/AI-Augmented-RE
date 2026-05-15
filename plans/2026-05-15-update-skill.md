# `/update` Skill (Component 1 of Approach 2) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `/update` — a diagnostic, retrospective skill that runs after `/elicit` to produce an Update Report summarising what changed in the elicit doc since the last update and recommending which downstream skills to re-run.

**Architecture:** `/update` is a thin coordinator + reporter, modeled on `/trace`. It reads the current elicit doc, diffs it against the snapshot embedded in the previous Update Report (if any), and writes a new Update Report at `artifacts/00-updates/update-YYYY-MM-DD-NN.md`. No new IDs minted, no skills invoked, no review gate of its own. The framework's "step-by-step with human review gates" philosophy is preserved by recommending rather than orchestrating.

**Tech Stack:** Markdown (skill + templates), YAML frontmatter, Mermaid (in the Update Report for the cascade-recommendation diagram), shell (`setup.sh` updates).

---

## Strategic context

Source: `~/.claude/plans/not-i-want-to-gentle-pixel.md` (Approach 2, approved 2026-05-15). This plan implements **Component 1 only** — the `/update` orchestrator. Components 2 (SRS baselining) and 3 (Amendment protocol) get their own follow-up plans.

Resolution of open question O1 from the strategic plan: **`/update` is retrospective.** It does NOT invoke `/elicit` programmatically. The expected workflow is:

1. User drops new files into `inputs/`
2. User runs `/elicit` → `/elicit` reads everything, refines Pending elements, raises OQs, presents its review gate
3. User reviews and types `APPROVED`
4. User runs `/update` → `/update` compares the current elicit doc against the snapshot in the previous Update Report (or "first run" if none), writes a new Update Report, and presents the recommended downstream re-run chain

Rationale: invoking `/elicit` from `/update` would nest review gates (`/update` → `/elicit` review gate → APPROVED → return to `/update` → present `/update` summary), which is fragile and conflicts with the framework's "step-by-step with review gates" identity. A retrospective design mirrors `/trace`'s pattern: diagnostic, no gate of its own, runs anytime after upstream work has settled.

## What Component 1 deliberately does NOT do (yet)

These belong to Components 2 and 3, which ship separately:

- **No SRS baselining detection.** `/update` will say "consider re-running `/create-srs`" but the v1.0 → v1.1 supersession logic lives in Component 2's `/create-srs` extension.
- **No amendment-proposal handling.** The Update Report Template has a placeholder section for Amendment Proposals; for now it always reports "(none — amendment protocol not yet shipped; Component 3)". When Component 3 lands, `/elicit` itself will raise `AM-###` proposals and `/update`'s report will surface them.
- **No auto-invocation of downstream skills.** Recommendations only. The human invokes each phase manually.

## File Structure

| Path | Responsibility | Status |
|------|----------------|--------|
| `skills/update/skill.md` | Skill definition: step-by-step procedure, delta computation, recommendation heuristics, edge cases, ID reference | Create |
| `skills/update/templates/update-report.md` | Update Report template — frontmatter + 8 sections + machine-readable Appendix A snapshot | Create |
| `skills/update/evals/evals.json` | 3 evals: first-run / steady-state delta / no-changes | Create |
| `setup.sh` | Add `artifacts/00-updates` to folder loop; update Next Steps text; update calibration examples block | Modify |
| `skills/GOVERNANCE.md` | Add "Update-Phase Governance Rules" section (the skill is read-only, never bypasses downstream gates, mints no IDs); bump version 1.8.0 → 1.9.0 | Modify |
| `CLAUDE.md` (framework root) | Add `/update` to skills table; mention in architecture block | Modify |
| `AGENTS.md` (framework root) | Same | Modify |
| `setup/CLAUDE.md.template` | Add `/update` row to project-facing pipeline table | Modify |
| `setup/AGENTS.md.template` | Same | Modify |
| `examples/00-updates/` | Benchmark Update Report for the PocketPing chain (simulated meeting-minutes input) | Create |
| `docs/Documentation/09-Update-Skill.md` | Vault daily-use docs (mirrors `07-Trace-Skill.md` pattern) | Create |
| `docs/Specification/11-Update-Skill.md` | Vault formal spec (mirrors `09-Trace-Skill.md` pattern) | Create |
| `docs/Plans/13-Update-Skill-Implementation.md` | Vault historical plan record (mirrors `11-Trace-Skill-Implementation.md`) | Create |
| `docs/Learning/10-Update-Skill-Iteration-1-Lessons.md` | Vault lessons (mirrors `08-Trace-Iteration-1-Lessons.md`) | Create |

## Locked design decisions

These shape every task; do not re-litigate during implementation.

1. **Retrospective, not active.** `/update` reads, never writes anything except its own Update Report. It does not invoke `/elicit` or any other skill.
2. **Update Report is the state record.** The previous Update Report's Appendix A (element snapshot, YAML block) is the baseline `/update` diffs against. First run has no previous report → reports the full current state with no delta annotations.
3. **Update Report IDs.** Filenames are `update-YYYY-MM-DD-NN.md` where NN is a 2-digit per-day sequence number (01, 02, ...). Run-on-the-same-day produces 02, 03, etc. Reports are never deleted (audit trail).
4. **No new artefact IDs.** The skill mints no new namespace. AM-### (Amendment IDs) is reserved for Component 3.
5. **Recommendation heuristics are published.** Step 6 of `skill.md` lists every rule for "when should phase X be re-run?" — no hidden logic.
6. **Element snapshot format.** A YAML block in Appendix A of every Update Report contains every element's `id`, `status`, `content-hash` (sha256 of normalised content), `last-modified-by` (the input file that most recently affected this element). This is what `/update` diffs against on next run.
7. **Diagnostic, no gate.** Like `/trace`, `/update`'s frontmatter has `status: Auto-generated`. There is no APPROVED prompt. Re-running `/update` produces a new dated report; old reports persist.
8. **Idempotent re-runs.** Running `/update` twice in a row with no upstream changes produces a near-identical report (same snapshot; the delta section reads "no changes since previous run").

---

## Tasks

Markdown content authoring; not TDD-shaped. Each task delivers a complete unit with verification steps.

### Task 1: Create the per-Update-Report template

**Files:**
- Create: `skills/update/templates/update-report.md`

The skill renders each run's output from this template. Define every section explicitly so the skill can populate fields by lookup rather than by re-reasoning each run.

- [ ] **Step 1: Create the directory structure**

```bash
mkdir -p /Users/axelburkhardt/projects/AI-Augmented-RE/skills/update/templates
mkdir -p /Users/axelburkhardt/projects/AI-Augmented-RE/skills/update/evals
```

- [ ] **Step 2: Write `skills/update/templates/update-report.md`**

Required structure (see content below). Frontmatter + 8 numbered sections + Appendix A.

**Frontmatter:**

```yaml
---
artifact: update-report
project: <!-- PROJECT_NAME -->
run-date: <!-- YYYY-MM-DD -->
run-number: <!-- NN -->
previous-report: <!-- update-YYYY-MM-DD-NN.md or "none (first run)" -->
inputs-processed:
  - <!-- input filename 1 -->
  - <!-- input filename 2 -->
status: Auto-generated
---
```

**Body sections** (each with one-line lift comment in HTML form so the skill knows what to populate):

1. **Run Summary** — counts: inputs processed, OQs resolved this run, new elements minted, Pending elements refined, Amendment Proposals raised (always 0 until Component 3). Plus a one-paragraph narrative ("This run processed N new inputs; M new elements; K OQs resolved; downstream re-runs recommended: ...").

2. **Inputs Processed Since Last Run** — table: `Filename | Type (estimated from extension) | One-line summary | OQs Resolved (list) | Elements Affected (list of IDs)`. Lifted from `inputs/manifest.md` and the run's elicit-doc delta.

3. **Element-Level Deltas** — sub-sectioned by element type:
   - **3.1 New elements** — table: `ID | Type | Title | Status (always Pending for new) | Source Input | Notes`
   - **3.2 Pending elements refined** — table: `ID | Type | Title | What changed | Source Input`
   - **3.3 OQs resolved** — table: `OQ-### | Question | Resolution summary | Source Input`
   - **3.4 OQs newly raised** — table: `OQ-### | Severity | Question | Affected Element(s)`
   - **3.5 Amendment Proposals (Component 3 placeholder)** — text: `(none — amendment protocol not yet shipped)` until Component 3.

4. **Recommended Downstream Re-Runs** — ordered list with rationale per item:
   ```
   1. /create-epics — because: 2 new FRs (FR-009, FR-010) need Epic allocation
   2. /create-stories — because: FR-009 will produce a new Story under EP-001 (already Accepted)
   3. /create-srs — because: a new in-scope FR landed under an Accepted Epic (note: Component 2 not yet shipped; manual SRS revision workaround required until then)
   4. /create-tests — because: SRS canonical AC list will grow once /create-srs reruns
   5. /create-tasks — because: a new Story will be Accepted; need a new TASK
   6. /trace — always, to verify the chain is intact
   ```
   If no downstream re-runs are recommended: `"No downstream re-runs needed — this run only affected Pending elements with no Accepted dependants."`

5. **Cascade Recommendation Diagram** — Mermaid `flowchart LR` showing the chain of recommended re-runs with their dependencies. Numeric-only node IDs (`elicit`, `epics`, etc.). `%%{init: {'theme': 'neutral'}}%%` first line.

6. **Pipeline State After /elicit** — table: `Phase | Skill | Artifact | Status | Notes`. Snapshot of every phase's current state.

7. **Open Questions Across the Pipeline (current)** — table aggregated from elicit doc + all downstream artefacts: `OQ-### | Severity | Source artefact | Question | Status`. Informational; `/update` mints no new OQs.

8. **Revision History** — append-only; one row per re-run of the same date (NN sequence).

**Appendix A — Element Snapshot (machine-readable)** — YAML block listing every element with: `id`, `type` (SH/BUC/FR/NFR/CON/AC/ASMP/RSK/OQ/EP/US/TC/TASK), `status`, `content-hash` (sha256 of the element's normalised content), `last-modified-by` (input filename or "skill-generated" for downstream-only elements). This is the diff baseline for the next `/update` run.

```yaml
elements:
  - id: SH-001
    type: SH
    status: Accepted
    content-hash: <sha256 hex>
    last-modified-by: meeting-minutes-2026-04-18.md
  - id: FR-001
    type: FR
    status: Accepted
    content-hash: <sha256 hex>
    last-modified-by: PRD-v1.md
  # ... every element
```

- [ ] **Step 3: Verify template against sibling shapes**

```bash
grep -E "^## [0-9]+\." skills/update/templates/update-report.md | wc -l
```
Expected: `8` sections (matches plan).

```bash
grep -c "^elements:" skills/update/templates/update-report.md
```
Expected: `1` (the Appendix A snapshot block).

- [ ] **Step 4: Commit**

```bash
git add skills/update/templates/update-report.md
git commit -m "feat(skill): /update — per-run Update Report template (Component 1)"
```

---

### Task 2: Write the `/update` skill definition

**Files:**
- Create: `skills/update/skill.md`

The core skill — mirrors `/trace` in shape (diagnostic, no gate, single canonical output). Cite `templates/update-report.md` as the rendering target.

- [ ] **Step 1: Write Purpose paragraph**

> **Purpose:** Produce a single Update Report at `artifacts/00-updates/update-YYYY-MM-DD-NN.md` summarising what changed in the Elicitation Document since the previous Update Report and recommending which downstream skills to re-run. The skill is the framework's **update coordinator** — it runs after `/elicit` has been re-run and Approved with new inputs, compares the current elicit doc against the snapshot embedded in the previous Update Report (if any), and writes a fresh report. The skill is diagnostic, not generative: it mints no IDs, modifies no upstream artefact, never invokes another skill, and has no APPROVED gate of its own.

- [ ] **Step 2: Write Invocation block**

```
**Invocation:**
- Claude Code: `/update`
- GitHub Copilot: "Run the update skill" or "Follow `skills/update/skill.md`"
```

- [ ] **Step 3: Write Inputs / Outputs**

**Inputs (all optional except the elicit doc):**
- `artifacts/01-elicitation/elicitation-document.md` — required; the canonical source of element state
- `inputs/manifest.md` — used to determine which input files were processed by the most recent `/elicit` run
- `artifacts/00-updates/update-*.md` — previous Update Reports; the highest-numbered file is the baseline for delta computation
- `artifacts/02-epics/`, `03-user-stories/`, `04-srs/`, `05-test-concept/`, `07-implementation-tasks/` — used for the Pipeline State After /elicit section and the recommendation heuristics

**Outputs:**
- `artifacts/00-updates/update-YYYY-MM-DD-NN.md` — one new file per run (never overwrites a prior report; NN auto-increments for same-day re-runs)

- [ ] **Step 4: Write Step 0 — No gate; ensure prerequisites exist**

State that `/update` is diagnostic and has no gate. The only hard prerequisite is the elicit doc:

- If `artifacts/01-elicitation/elicitation-document.md` does not exist: stop with `"Run /elicit first; no elicit doc to derive an update report from."`
- If `inputs/` is empty: stop with `"No inputs in inputs/; /update has nothing to coordinate."`

No other gates. The skill runs whatever pipeline state is present.

- [ ] **Step 5: Write Step 1 — Locate the previous Update Report**

Read every `artifacts/00-updates/update-*.md`. Identify the highest by date + sequence (latest `run-date`, tiebreak on `run-number`). Capture its Appendix A snapshot as `prev_snapshot`. If no previous report exists: `prev_snapshot = None` and the run is flagged "first run" in the report's frontmatter.

Compute `next_run_number`: if any reports exist for today, increment the highest `run-number` of today by 1; else 01. Format as zero-padded 2-digit.

- [ ] **Step 6: Write Step 2 — Snapshot the current elicit-doc state**

For every first-class entity in the elicit doc (SH-/BUC-/FR-/NFR-/CON-/AC-/ASMP-/RSK-/OQ-### / and EP-/US-/TC-/TASK-### in downstream artefacts):

- Extract `id`, `type`, `status` (Pending / Accepted / Rejected / Resolved / Open / Validated / Invalidated / Mitigated / Accepted / Closed depending on element type)
- Compute `content-hash`: sha256 of the element's normalised body content (strip leading/trailing whitespace; collapse multiple spaces to single; lowercase for comparison only — the hash itself is on the original normalised content)
- Determine `last-modified-by`: search the manifest for the most recent input file that mentions the element's ID; if no manifest mention, fall back to `"skill-generated"` (true for downstream elements like TCs / Tasks)

Build `current_snapshot` as a YAML structure mirroring Appendix A's format.

- [ ] **Step 7: Write Step 3 — Compute the delta**

Compare `current_snapshot` against `prev_snapshot`:

| Delta category | Detection rule |
|---|---|
| **New element** | ID in current_snapshot, NOT in prev_snapshot |
| **Refined Pending element** | ID in both; status was Pending in prev, content-hash changed in current |
| **Refined other-status element** | ID in both; status NOT Pending in prev; content-hash changed — this is an **anomaly** (Component 3 will treat as Amendment Proposal); for Component 1, raise a Note in Section 3.5: `"Anomalous content change on Accepted element <ID> — Component 3 amendment protocol required to handle this properly. Manual reconciliation required for now."` |
| **OQ resolved** | OQ-### in prev with `Status: Open`, in current with `Status: Resolved` |
| **OQ newly raised** | OQ-### in current, not in prev |
| **Status transition** | ID in both; status changed (Pending → Accepted, etc.) |
| **No change** | ID in both; status same; content-hash same — not reported |

For the first run (no `prev_snapshot`): every element is "current state, no delta annotation." The report's Section 3 is informational ("This is the first Update Report; the snapshot below is the baseline for future delta computation").

- [ ] **Step 8: Write Step 4 — Determine downstream re-run recommendations**

Apply these heuristics (published verbatim, no hidden rules):

| Recommend | When |
|-----------|------|
| `/create-epics` | New FR or NFR exists in the delta; OR any FR's `Business Use Case` field changed (a refined-Pending FR is enough) |
| `/create-stories` | New FR Accepted under an Accepted Epic exists, OR any AC list change under an existing Story's parent FR, OR a Pending FR was refined and that FR's parent Epic is Accepted |
| `/create-srs` | Any element is now Accepted-and-in-scope that was not in the current SRS body. **Note (Component 1):** since the SRS baselining protocol (Component 2) is not yet shipped, this recommendation includes a caveat: `"Manual workaround until Component 2: Reject the Accepted SRS, then re-run /create-srs to publish a new version."` |
| `/create-tests` | SRS has new in-scope content per the heuristic above, OR any new AC was minted |
| `/create-tasks` | Any new Story Accepted under an Accepted Epic exists, OR any Task's parent AC is in the delta |
| `/trace` | Always, after `/update` completes — to verify chain integrity |

For each triggered recommendation, capture the **rationale** (the specific element IDs that triggered it). The rationale is rendered in Section 4 of the report.

- [ ] **Step 9: Write Step 5 — Build the Mermaid cascade diagram**

Render Section 5 as a `flowchart LR` showing only the recommended re-runs with arrows indicating ordering dependency:

```mermaid
%%{init: {'theme': 'neutral'}}%%
flowchart LR
    elicit[/elicit — done /]
    epics[/create-epics — needed/]
    stories[/create-stories — needed/]
    srs[/create-srs — needed/]
    tests[/create-tests — needed/]
    tasks[/create-tasks — needed/]
    trace[/trace — always/]

    elicit --> epics --> stories --> srs --> tests --> tasks --> trace
```

Skills not recommended are omitted from the diagram. If only `/trace` is recommended (no other changes): show just `elicit --> trace`.

- [ ] **Step 10: Write Step 6 — Write the Update Report**

Render `artifacts/00-updates/update-YYYY-MM-DD-NN.md` from `skills/update/templates/update-report.md`, populating every section per the deltas computed in Step 3, the recommendations from Step 4, and the cascade diagram from Step 5. Append the new `current_snapshot` as Appendix A.

If `artifacts/00-updates/` does not exist: create it.

The new Update Report is **never** an overwrite — `update-YYYY-MM-DD-NN.md` is always a fresh file. Old reports are preserved as the audit trail.

- [ ] **Step 11: Write Step 7 — Review summary (no APPROVED)**

Present to the user:

> **Update report — `<project>`, run `<date-NN>`**
> - **Previous report:** `<previous-filename>` or `"none (first run)"`
> - **Inputs processed since previous report:** `[count and one-line list]`
> - **Element-level deltas:** `New: N | Refined: M | OQs resolved: K | OQs raised: J | Anomalies: A`
> - **Recommended downstream re-runs (in order):** `[list with rationale per item]`
> - **Anomalous content changes detected:** `[Component-3 placeholder — list IDs or "none"]`
>
> Read `artifacts/00-updates/<filename>.md` for the full report (Mermaid cascade diagram included).
>
> There is no APPROVED prompt — `/update` is informational. Proceed to invoke the recommended downstream skills in order.

If the run found no deltas: state `"No changes detected since the previous Update Report. The pipeline state is unchanged. The new report at <filename> records this snapshot for the next run's delta computation."`

- [ ] **Step 12: Write ID Reference and Edge Cases**

```markdown
## ID Reference

| Artifact | Format | Example | Source |
|----------|--------|---------|--------|
| Update Report | `update-YYYY-MM-DD-NN.md` (filename) | `update-2026-05-20-01.md` | minted by this skill |

`/update` mints no element-level IDs and writes nothing to the OQ-### namespace.
```

```markdown
## Edge Cases

| Situation | Action |
|-----------|--------|
| `artifacts/01-elicitation/elicitation-document.md` does not exist | Stop at Step 0; instruct user to run `/elicit` first |
| `inputs/` is empty | Stop at Step 0; nothing to coordinate |
| `artifacts/00-updates/` does not exist | Create it in Step 6 |
| No previous Update Report (first run) | `prev_snapshot = None`; report is marked "first run"; Section 3 narrates the baseline; no delta annotations |
| Two reports on the same date | Increment `run-number` (01 → 02 → ...) |
| Anomalous content change on a non-Pending element | Component 1 workaround: record in Section 3.5 as a Note; the human resolves manually until Component 3 ships the amendment protocol |
| The elicit doc was edited manually between `/elicit` runs (skipping `/elicit`) | `/update` will still produce a delta against the previous report's snapshot; the report will recommend re-running `/elicit` if any element appears manually edited (content-hash changed but `last-modified-by` is unchanged) |
| Two consecutive `/update` runs with no changes | The second run produces a near-identical report with the delta sections empty and a "no changes since previous run" Note in Section 1 |
```

- [ ] **Step 13: Verify skill.md structure**

```bash
grep -E "^## " skills/update/skill.md
```
Expected output (in order):
- `## Step 0 — No gate; ensure prerequisites exist`
- `## Step 1 — Locate the previous Update Report`
- `## Step 2 — Snapshot the current elicit-doc state`
- `## Step 3 — Compute the delta`
- `## Step 4 — Determine downstream re-run recommendations`
- `## Step 5 — Build the Mermaid cascade diagram`
- `## Step 6 — Write the Update Report`
- `## Step 7 — Review summary (no APPROVED)`
- `## ID Reference`
- `## Edge Cases`

- [ ] **Step 14: Commit**

```bash
git add skills/update/skill.md
git commit -m "feat(skill): /update — diagnostic update coordinator (Component 1)"
```

---

### Task 3: Write `skills/update/evals/evals.json`

**Files:**
- Create: `skills/update/evals/evals.json`

Three evals: first-run / steady-state-delta / no-changes-since-last.

- [ ] **Step 1: Write the file**

```json
{
  "skill_name": "update",
  "evals": [
    {
      "id": 1,
      "name": "first-run-with-pocketping-baseline",
      "prompt": "PocketPing is at full pipeline state: elicit Approved, 3 Epics Accepted, 8 Stories Accepted, SRS Accepted v1.0, 14 TCs Pending, 14 Tasks Pending. No Update Report exists yet. Run /update.",
      "expected_output": "First Update Report written to artifacts/00-updates/update-YYYY-MM-DD-01.md. frontmatter previous-report: 'none (first run)'. Section 3 reports baseline (no delta annotations). Section 4 recommends only /trace (no upstream changes pending). Appendix A snapshot enumerates every SH/BUC/FR/NFR/CON/AC/ASMP/RSK/OQ/EP/US/TC/TASK with current status and content-hash. No skills invoked; no element IDs minted.",
      "files": [],
      "assertions": []
    },
    {
      "id": 2,
      "name": "steady-state-delta-after-meeting-minutes",
      "prompt": "PocketPing at full pipeline state with previous Update Report at update-2026-05-20-01.md. A meeting-minutes input added 1 new stakeholder, 1 new NFR (NFR-005 encryption-at-rest), and resolved OQ-005 (the EP-001 merge question). /elicit was re-run and APPROVED. Now run /update.",
      "expected_output": "New Update Report at update-2026-05-21-01.md (or same date +1 NN if same day). frontmatter previous-report: 'update-2026-05-20-01.md'. Section 3.1 lists SH-005 + NFR-005 as new. Section 3.3 lists OQ-005 resolved. Section 4 recommends in order: /create-epics (because NFR-005 needs allocation) → /create-stories (skip — NFR has no Story) → /create-srs (NEEDED — new NFR is in-scope under Accepted Epic; Component-1 caveat about manual workaround included) → /create-tests (NEEDED — new AC will land in SRS canonical list) → /create-tasks (NEEDED — depends on TC) → /trace (always). Section 5 Mermaid diagram shows the chain. Appendix A updated with new elements.",
      "files": [],
      "assertions": []
    },
    {
      "id": 3,
      "name": "no-changes-since-last-update",
      "prompt": "Previous Update Report exists at update-2026-05-20-01.md. No new inputs added; /elicit not re-run since. Run /update.",
      "expected_output": "New Update Report at update-2026-05-20-02.md (same date, NN incremented to 02). frontmatter previous-report: 'update-2026-05-20-01.md'. Section 1 Run Summary narrates 'No changes detected since the previous Update Report.' Sections 3.1-3.4 are empty (or display '(no changes in this category)'). Section 4 recommends ONLY /trace. Appendix A snapshot identical to previous. Section 8 Revision History records this no-op run.",
      "files": [],
      "assertions": []
    }
  ]
}
```

- [ ] **Step 2: Commit**

```bash
git add skills/update/evals/evals.json
git commit -m "feat(skill): /update — evals (Component 1)"
```

---

### Task 4: Update `setup.sh`

**Files:**
- Modify: `setup.sh`

Two surgical edits.

- [ ] **Step 1: Add `artifacts/00-updates` to the folder loop**

Current (after the Phase-7 commit):

```bash
for folder in artifacts/01-elicitation artifacts/02-epics artifacts/03-user-stories artifacts/04-srs artifacts/05-test-concept artifacts/06-traceability artifacts/07-implementation-tasks; do
  mkdir -p "$folder"
  touch "$folder/.gitkeep"
done
success "Artifact folders ready (01 through 07)"
```

Change to:

```bash
for folder in artifacts/00-updates artifacts/01-elicitation artifacts/02-epics artifacts/03-user-stories artifacts/04-srs artifacts/05-test-concept artifacts/06-traceability artifacts/07-implementation-tasks; do
  mkdir -p "$folder"
  touch "$folder/.gitkeep"
done
success "Artifact folders ready (00 through 07)"
```

- [ ] **Step 2: Update Next Steps text — add `/update` to the workflow**

After the existing step 7 block (the `/create-tasks` description), add:

```bash
echo
echo "  8. When new inputs land in inputs/ AFTER any phase is Approved:"
echo "     a. Re-run /elicit to refine the elicit doc (full-synthesis on all inputs)"
echo "     b. Type APPROVED on the elicit review gate"
echo "     c. Run /update to get the cascade roadmap — an Update Report at"
echo "        artifacts/00-updates/ lists what changed and which downstream"
echo "        skills to re-run. /update is diagnostic; no APPROVED prompt."
```

- [ ] **Step 3: Smoke-test `setup.sh`**

```bash
rm -rf /tmp/rl-setup-test
/Users/axelburkhardt/projects/AI-Augmented-RE/setup.sh /tmp/rl-setup-test <<< $'Setup-Test\nn\n' 2>&1 | tail -20
ls /tmp/rl-setup-test/artifacts/
rm -rf /tmp/rl-setup-test
```
Expected: `artifacts/` lists `00-updates  01-elicitation  ...  07-implementation-tasks`.

- [ ] **Step 4: Commit**

```bash
git add setup.sh
git commit -m "feat(setup): bootstrap artifacts/00-updates/ for /update skill"
```

---

### Task 5: Update `skills/GOVERNANCE.md`

**Files:**
- Modify: `skills/GOVERNANCE.md`

Three edits: version bump, new section, integration note in the Trace-Phase note.

- [ ] **Step 1: Bump version**

```
Version: 1.8.0
Last updated: 2026-05-15
```

→

```
Version: 1.9.0
Last updated: 2026-05-15
```

- [ ] **Step 2: Add new section AFTER the Trace-Phase section, BEFORE the Implementation-Tasks-Phase section**

```markdown
---

## Update-Phase Governance Rules

These rules govern `/update` (the framework's update coordinator). The skill produces `artifacts/00-updates/update-YYYY-MM-DD-NN.md` — one Update Report per run — summarising what changed in the elicit doc since the previous Update Report and recommending which downstream skills to re-run.

### Diagnostic, not generative

`/update` is **diagnostic, not generative**. Like `/trace`, it has no governance gate and no acceptance lifecycle of its own. The skill mints no element-level IDs, modifies no upstream artefact, and never invokes another skill. Re-runs always produce a NEW dated file (never overwrite a prior report) so the Update Report history is an immutable audit trail.

### Read-only on upstream and on prior reports

The skill SHALL NOT modify the elicit doc, any downstream artefact, the manifest, or any previous Update Report. It produces exactly one output (a new Update Report). Manual edits to prior Update Reports are not preserved across re-runs of any skill (they should not be edited; they are audit records).

### Snapshot-based delta computation

The skill SHALL compute deltas by comparing the current elicit-doc state against the snapshot embedded in Appendix A of the most recent previous Update Report. The snapshot format is YAML, one entry per first-class element, capturing `id`, `type`, `status`, `content-hash`, `last-modified-by`. The snapshot is the canonical inter-run state record — git history is not consulted (the skill remains portable to projects that may not be under git).

### Recommendation heuristics are published

`/update` Step 4 (downstream-rerun recommendation) uses a published heuristic table — every rule that triggers a "rerun X" recommendation is enumerated in `skills/update/skill.md` Step 4. No hidden logic. The team can verify *what* will be recommended before relying on the skill.

### No new OQs minted

The skill SHALL NOT add to the OQ-### namespace. Findings (anomalous content changes, manual-edit suspicions) are reported inline in the Update Report's relevant section. The OQ namespace is reserved for skills that generate content; `/update` is informational.

### No bypassing of downstream review gates

The skill SHALL NOT invoke any downstream skill automatically. Recommendations are presented in the Update Report's Section 4 with ordered rationale; the human invokes each downstream skill manually. This rule preserves the framework's "step-by-step with review gates" identity at the meta-orchestration layer.

### Forward compatibility with Amendments (Component 3)

The Update Report template includes Section 3.5 (Amendment Proposals) as a placeholder. Until Component 3 ships, this section reads `"(none — amendment protocol not yet shipped)"`. When Component 3 lands, `/elicit` will raise `AM-###` proposals and `/update` Step 3 will surface them in this section without changes to the Update Report template structure.

### Update-Phase APPROVED integrity

There is no APPROVED at the Update phase. The skill mints a report and stops. If the human disagrees with a recommendation, the resolution is to ignore the recommendation; the report is informational only.
```

- [ ] **Step 3: Update the Trace-Phase note paragraph**

Find the paragraph in the Trace-Phase section beginning `"/trace (Phase 6 of the pipeline) is diagnostic, not generative"`. After the sentence about the TASK column, append:

> `/trace` and `/update` are sibling diagnostic skills. `/trace` audits cross-pipeline consistency at any point in time; `/update` coordinates the re-run cascade after new inputs land. Neither has a governance gate; both produce immutable historical artefacts.

- [ ] **Step 4: Commit**

```bash
git add skills/GOVERNANCE.md
git commit -m "feat(governance): Update-Phase rules; bump to v1.9.0"
```

---

### Task 6: Update framework-root `CLAUDE.md` and `AGENTS.md`

**Files:**
- Modify: `CLAUDE.md`
- Modify: `AGENTS.md`

Add a row for `/update` and mention in the architecture block.

- [ ] **Step 1: `CLAUDE.md` — add `/update` row to the skills table**

Find the existing table after Phase 7. Insert a new row labelled "8" (since /update is not phase-bound, but for table ordering we put it at the end), or alternatively at the top before Phase 1 (since /update precedes everything in the update-cycle workflow). **Choose: insert at the END of the skills table as Phase 8 (formal numbering for the table) with a footnote clarifying that it has no fixed phase.**

```
| 8 | `/update` | Update Report (cascade coordinator) | Diagnostic — no gate |
```

And update the architecture block:

Find:
```
└── /create-tasks skill   — decomposes Accepted Stories into codebase-agnostic implementation Tasks (Dev-Team handoff)
```

Insert before this line:
```
├── /update skill         — coordinates re-runs after new inputs land (no gate)
```

And update the rendering accordingly (the last `└──` should reflect the now-last entry).

- [ ] **Step 2: `AGENTS.md` — same edits**

Add the `/update` row to the RE Pipeline table. AGENTS.md does not have the architecture block; only update the table.

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md AGENTS.md
git commit -m "docs: add /update skill to framework-root pipeline and architecture"
```

---

### Task 7: Update project-facing templates

**Files:**
- Modify: `setup/CLAUDE.md.template`
- Modify: `setup/AGENTS.md.template`

Same `/update` row addition for new projects.

- [ ] **Step 1: Add `/update` row to both template pipeline tables**

```
| 8 | `/update` | Update Report (cascade coordinator) | Diagnostic — no gate |
```

- [ ] **Step 2: Commit**

```bash
git add setup/CLAUDE.md.template setup/AGENTS.md.template
git commit -m "docs(setup): add /update row to project-facing pipeline templates"
```

---

### Task 8: Produce `examples/00-updates/` benchmark

**Files:**
- Create: `examples/00-updates/update-2026-05-20-01.md`

A worked example: imagined PocketPing situation where a meeting-minutes input has been processed by `/elicit`. This is the first Update Report for the PocketPing example chain.

- [ ] **Step 1: Read the PocketPing elicit-doc current state**

```bash
head -200 examples/01-elicitation/elicitation-document-example.md
```

This is the canonical baseline. The benchmark Update Report assumes a synthetic scenario where a new input has just been processed.

- [ ] **Step 2: Write `examples/00-updates/update-2026-05-20-01.md`**

Use the template from Task 1. Populate every section concretely:

**Frontmatter:**
```yaml
---
artifact: update-report
project: PocketPing
run-date: 2026-05-20
run-number: 01
previous-report: none (first run)
inputs-processed:
  - meeting-minutes-2026-05-20.md (synthetic — illustrative only)
status: Auto-generated
---
```

**Section 1 — Run Summary:** narrative describing this as a calibration example. Counts: 0 OQs resolved (first run; baseline only), 0 new elements, 0 refinements (first run carries the baseline forward as the starting snapshot).

**Section 2 — Inputs Processed:** table showing the (synthetic) meeting-minutes input alongside the original PocketPing source inputs. Mark all as "baseline" since this is the first report.

**Section 3 — Element-Level Deltas:**
- 3.1 New elements: `"(none — first run)"`
- 3.2 Pending refined: `"(none — first run)"`
- 3.3 OQs resolved: `"(none — first run)"`
- 3.4 OQs newly raised: `"(none — first run)"`
- 3.5 Amendment Proposals (Component 3 placeholder): `"(none — amendment protocol not yet shipped)"`

**Section 4 — Recommended Downstream Re-Runs:** `"None this run — this is the baseline Update Report. Future runs against new inputs will recommend downstream re-runs per Step 4 heuristics."`

**Section 5 — Cascade Recommendation Diagram:** a minimal diagram showing just `elicit --> trace` since no other re-runs are recommended.

**Section 6 — Pipeline State After /elicit:** table summarising current status (elicit Approved, 3 Epics Accepted, 8 Stories Accepted, SRS Accepted v1.0, 14 TCs Pending, 14 Tasks Pending — exactly the PocketPing baseline).

**Section 7 — OQs Across the Pipeline:** lift the open OQs from the elicit doc and downstream artefacts (OQ-005, OQ-006 from `/create-epics`, OQ-011 from `/create-tests`, etc.).

**Section 8 — Revision History:** one row recording this first run.

**Appendix A — Element Snapshot:** YAML block listing every element from the PocketPing chain with current status. Stub the content-hash values as `<sha256 of normalised content>` (the calibration example doesn't compute real hashes; it documents the format).

- [ ] **Step 3: Commit**

```bash
git add examples/00-updates/
git commit -m "docs(examples): PocketPing benchmark Update Report (first-run baseline)"
```

---

### Task 9: Produce vault documentation set

**Files:**
- Create: `docs/Documentation/09-Update-Skill.md`
- Create: `docs/Specification/11-Update-Skill.md`
- Create: `docs/Plans/13-Update-Skill-Implementation.md`
- Create: `docs/Learning/10-Update-Skill-Iteration-1-Lessons.md`

Four vault-side files following the established per-skill pattern (mirror the structure of `07-Trace-Skill.md` / `09-Trace-Skill.md` / `11-Trace-Skill-Implementation.md` / `08-Trace-Iteration-1-Lessons.md`).

- [ ] **Step 1: Create the four files**

Use the exact structure of the corresponding `/trace` documents as the pattern. Each file's specific content:

- **Documentation/09-Update-Skill.md** — daily use: what it does, when to run, inputs/outputs, snapshot model explained, worked PocketPing example, role & working model, Related links to Specification/Plans/Lessons.
- **Specification/11-Update-Skill.md** — formal spec: Goal, Requirements (inputs/outputs/no-gate/read-only/snapshot-based/published-heuristics/no-new-OQs/no-skill-invocation/Component-3-forward-compat), Non-requirements, Skill Structure (8 Steps), Why retrospective not active, Edge Cases, Related.
- **Plans/13-Update-Skill-Implementation.md** — historical record: Goal, Status (Complete), Spec reference, Tasks 1–9 from this plan with brief outcomes, Decisions Made During Implementation (including O1 resolution), Pipeline now seven-plus-one phases, Related.
- **Learning/10-Update-Skill-Iteration-1-Lessons.md** — lessons learned: covering at least (a) why retrospective beat active design, (b) the snapshot-in-Appendix-A pattern (avoids dependence on git history; portable), (c) forward compatibility with Component 3, (d) /update + /trace as sibling diagnostics, (e) what's deferred (real /elicit-side conflict detection — Component 3).

- [ ] **Step 2: No commit needed** — vault is gitignored.

---

### Task 10: End-to-end verification on PocketPing benchmark

**Files:**
- Read-only: every benchmark artefact in `examples/`

- [ ] **Step 1: Confirm directory structure**

```bash
ls -la skills/update/
ls -la skills/update/templates/
ls -la skills/update/evals/
ls examples/00-updates/
```
Expected: skill.md / templates/update-report.md / evals/evals.json present; examples/00-updates/ contains the baseline report.

- [ ] **Step 2: Confirm framework integration**

```bash
grep -c "update\b\|/update\b" CLAUDE.md AGENTS.md setup/CLAUDE.md.template setup/AGENTS.md.template
grep -E "^Version:" skills/GOVERNANCE.md
grep -E "Update-Phase Governance Rules" skills/GOVERNANCE.md
```
Expected: non-zero hits per file; Version is `1.9.0`; the new section is present.

- [ ] **Step 3: Smoke-test `setup.sh` once more**

```bash
rm -rf /tmp/rl-update-test
/Users/axelburkhardt/projects/AI-Augmented-RE/setup.sh /tmp/rl-update-test <<< $'Update-Test\nn\n' 2>&1 | tail -5
ls /tmp/rl-update-test/artifacts/
rm -rf /tmp/rl-update-test
```
Expected: artifacts listing includes `00-updates`.

- [ ] **Step 4: Walk the benchmark Update Report**

Read `examples/00-updates/update-2026-05-20-01.md` end-to-end. Confirm:
- Frontmatter has `previous-report: none (first run)`
- Section 4 recommends nothing (or only /trace)
- Section 5 Mermaid renders cleanly with the framework's neutral theme
- Appendix A enumerates all PocketPing elements

- [ ] **Step 5: Done — mark all tasks complete**

```bash
git log --oneline -8
```
Expected: 7 commits from this plan plus the planning commit, all on branch `main`.

---

## Verification (full)

When the plan is complete:

1. `setup.sh /tmp/verify` creates `artifacts/00-updates/`
2. `skills/GOVERNANCE.md` is at v1.9.0 with the Update-Phase section
3. `skills/update/skill.md` has 8 Steps + ID Reference + Edge Cases
4. `examples/00-updates/update-2026-05-20-01.md` is a complete first-run baseline report for PocketPing
5. `CLAUDE.md`, `AGENTS.md`, `setup/*.template` all mention `/update`
6. Vault docs at the four expected paths

If all six pass, Component 1 ships.

## Spec coverage self-review

Strategic plan's Component 1 requirements mapped to tasks:

- "Read `inputs/manifest.md`. Compute the delta" → Task 2 Step 7 (Step 3 of skill.md: snapshot-based delta)
- "Snapshot the current elicit doc element states" → Task 2 Step 6
- "Invoke /elicit" — **resolved to retrospective**; documented in plan context and skill.md Step 0
- "Compute the change set" → Task 2 Step 7
- "For each downstream phase determine whether a re-run is recommended, using these heuristics" → Task 2 Step 8 (Step 4 of skill.md)
- "Write `artifacts/00-updates/update-YYYY-MM-DD-NN.md`" → Task 2 Step 10
- "Present a Review Summary" → Task 2 Step 11
- "No new artefact IDs minted" → Task 2 Step 12 (ID Reference) + Task 5 Step 2 (Governance)
- "Update-Phase Governance Rules" → Task 5 Step 2
- "Setup.sh bootstrap of `artifacts/00-updates/`" → Task 4
- "examples/00-updates/ benchmark" → Task 8
- Vault docs → Task 9

No gaps. No placeholders. Type consistency: `run-number` (2-digit zero-padded NN), `content-hash` (sha256), `last-modified-by`, `previous-report` — used consistently across Tasks 1, 2, 8.
