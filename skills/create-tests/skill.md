# Skill: create-tests

**Purpose:** Derive a Test Concept document plus per-Acceptance-Criterion Test Cases from the Approved Software Requirements Specification. Each AC in the SRS becomes exactly one Test Case (`AC-FR-###-NN` → `TC-###`); the skill never invents test scenarios. Test Type and Level are auto-assigned by a deterministic heuristic (FR ACs → Functional / Acceptance level; NFR ACs → category-driven Type at System level). The skill cross-checks every AC against the upstream Elicitation Document to detect drift and raises an OQ if the SRS and the elicit doc disagree. Re-runs are idempotent: Pending TCs are refined in place, Accepted TCs are immutable, and TC-### IDs are never reused.

**Invocation:**
- Claude Code: `/create-tests`
- GitHub Copilot: "Run the create-tests skill" or "Follow `skills/create-tests/skill.md`"

**Inputs:**
- `artifacts/04-srs/srs.md` (`status: Accepted`) — primary source for ACs (Section 8) and FR / NFR / CON / Story context
- `artifacts/01-elicitation/elicitation-document.md` — Section 6 ACs, used to cross-check drift against the SRS
- `artifacts/02-epics/epic-*.md` and `artifacts/03-user-stories/story-*.md` — read for forward-traceability context (parent Epic + Story per TC)
- `artifacts/05-test-concept/test-concept.md` and `test-case-*.md` and `index.md` (existing, if any)

**Outputs:**
- `artifacts/05-test-concept/test-concept.md` — single strategy document (regenerated in place each run)
- `artifacts/05-test-concept/test-case-NNN.md` — one file per Test Case, NNN = zero-padded TC-### sequence
- `artifacts/05-test-concept/index.md` — always rebuilt every run (AC coverage matrix, Type/Level distribution, OQ aggregation)

---

## Step 0 — Approval gate (strict on SRS)

The Test Concept and Test Cases are downstream artefacts of a settled specification. They must not be derived from a Pending SRS — running on a moving target means re-publishing the test set whenever the SRS shifts.

Read `artifacts/04-srs/srs.md`.

- If the file does not exist: stop. "Run `/create-srs` first to compile the Software Requirements Specification."
- If frontmatter `status` is not `Accepted`: stop and tell the user the current status. "The SRS is `<current status>`, not Accepted. Have the human reviewer review and accept the SRS in `/create-srs` before invoking `/create-tests`."

Defensive checks (the SRS gate has held upstream but verify):

- The Elicitation Document at `artifacts/01-elicitation/elicitation-document.md` exists with `status: Approved`.
- No Critical OQ from any earlier phase is still `Open` in the SRS, the elicit doc, or any Epic / Story file.

---

## Step 1 — Read every upstream artefact

| Source | What to extract |
|--------|-----------------|
| SRS Section 8 | Every AC: ID (`AC-FR-###-NN` or `AC-NFR-###-NN`), parent FR or NFR, Given/When/Then text or Criterion field, acceptance fields |
| SRS Section 4 | FR ID, Title, Priority, Stakeholder — for inheriting Owner and Priority into TCs |
| SRS Section 5 | NFR ID, Title, Category, Measurable Target, Priority — drives Test Type heuristic |
| SRS Section 3 | Epic + Story context — for forward traceability (parent Epic, parent Story per TC) |
| Elicit doc Section 6 | Every AC, used **only for cross-check against SRS** (drift detection) |
| Existing Story files | Each Story's `parent-fr` field — used to map AC → Story |

Build the **canonical AC list** from SRS Section 8. This is the source of truth for what TCs must exist.

---

## Step 2 — Read existing tests artefacts

Read every file matching `artifacts/05-test-concept/test-case-*.md`, plus `test-concept.md` and `index.md`. For each TC: capture its TC-ID, parent-ac, parent-fr-or-nfr, status, owner, type, level, OQs referenced.

Compute counters:

- `next_TC_id = max(existing TC-### across all test-case files) + 1`
- `next_OQ_id = max(OQ-### across the elicit doc, every Epic file, every Story file, the SRS, and existing test files) + 1`

TC-### IDs and OQ-### IDs are **never reused** even after deletion or rejection.

---

## Step 3 — Cross-check ACs between SRS and elicit doc

For every AC in the SRS canonical list, find the matching AC in elicit doc Section 6 (same AC-### ID).

- **Found, identical text:** OK — no action.
- **Found, text differs:** raise `OQ Severity=High`: `"AC-### text differs between SRS and elicit doc. SRS reads: '<excerpt>'. Elicit reads: '<excerpt>'. The skill treats SRS as authoritative for TC generation; reconcile upstream if the divergence is unintentional."` Continue using SRS text.
- **AC in elicit doc but missing from SRS:** raise `OQ Severity=Medium`: `"AC-### exists in elicit doc but is not in SRS Section 8. Was it deferred (parent Epic Pending) or dropped during SRS compilation? No TC will be generated."` Skip — the SRS is the canonical source.
- **AC in SRS but missing from elicit doc (defensive — should not happen if /create-srs is correct):** raise `OQ Severity=Critical`: `"AC-### is in the SRS but not in the elicit doc. The /create-srs lift may have been incorrect."` Skip until reconciled.

---

## Step 4 — For each canonical AC, mint or update one TC

For every AC in the SRS canonical list:

- **No matching TC exists** (no test-case file has `parent-ac: AC-###`): mint a new TC. Assign `next_TC_id`. Increment counter. Create `artifacts/05-test-concept/test-case-NNN.md` from `skills/create-tests/templates/test-case.md`.
- **Matching TC exists, Status = Pending:** refine fields (per Step 5) in place. Preserve TC-###. Update `last-updated` frontmatter.
- **Matching TC exists, Status = Accepted:** **immutable**. Do not modify any field. Append a review note to Section 13 (Revision History): `Note YYYY-MM-DD: re-run on upstream update — human review of this TC recommended.`
- **Matching TC exists, Status = Rejected:** same as Accepted. The TC-### is permanently retired but the file persists for audit.
- **An Accepted TC references an AC no longer in the SRS canonical list:** append review note + raise `OQ Severity=High`: `"TC-### references AC-### which is no longer in the SRS. The AC was dropped, deferred, or renamed. Reconcile manually."`

The skill never restructures: it does not split or merge TCs, and it does not change a TC's parent AC on re-run. Restructuring requires explicit human action (Reject the existing TC, edit upstream, re-run).

---

## Step 5 — Populate TC fields

For every Pending TC (do not modify Accepted/Rejected), populate every field. Lift content verbatim from SRS / upstream where possible; never invent test scenarios.

### 5.1 — Title and frontmatter

- **Title:** `"Test <parent FR or NFR title> — <AC summary>"`. The AC summary is one short phrase derived from the Then clause (FR ACs) or the Criterion field (NFR ACs).
- **Frontmatter:** `artifact: test-case`, `tc-id`, `parent-ac`, `parent-fr` or `parent-nfr` (whichever applies), `parent-epic`, `parent-story` (if any), `status: Pending`, `owner` (inherited from parent FR/NFR Stakeholder), `priority` (inherited from parent FR/NFR Priority), `type` (per Step 5.4), `level` (per Step 5.4), `created`, `last-updated`.

### 5.2 — Parent Traceability table

Forward chain rendered as a table: AC → FR or NFR → BUC → Epic → Story → Stakeholder. Lifted from SRS Section 3 + 4 + 5 + 9 (Traceability Matrix). FRs always have a parent Story; NFRs may not (they trace to BUCs without going through Stories).

### 5.3 — Description

One paragraph: what behaviour or quality this Test Case verifies. Synthesised from the parent FR/NFR Description and the AC. Do not duplicate the AC's Given/When/Then verbatim — Section 5 does that.

### 5.4 — Test Type and Test Level (deterministic heuristic)

The skill auto-assigns these fields. The heuristic is **published**, not hidden:

| AC source | Type | Level | Sub-type |
|-----------|------|-------|----------|
| FR AC (`AC-FR-###-NN`) | Functional | Acceptance | Behavioural (Given/When/Then) |
| NFR AC, parent NFR Category = Performance | Performance | System | Threshold-based |
| NFR AC, parent NFR Category = Security | Security | System | Threshold-based |
| NFR AC, parent NFR Category = Usability | Usability | System | Threshold-based |
| NFR AC, parent NFR Category = Reliability | Reliability | System | Threshold-based |
| NFR AC, parent NFR Category = Scalability | Scalability | System | Threshold-based |
| NFR AC, parent NFR Category = Maintainability | Maintainability | System | Threshold-based |
| NFR AC, parent NFR Category = Compliance | Compliance | System | Audit |

The team may override Type or Level during sprint planning — these are AI estimates, like the Story-points heuristic in `/create-stories`. The TC always carries the note `**AI assignment — confirm with QA team.**` Sub-type is informational.

### 5.5 — Preconditions, Steps, Expected Result

- **Preconditions** (Section 6 of the TC file): Lift the **Given** clause of the parent AC verbatim. For NFR ACs, the precondition is the system in its baseline state (note this explicitly).
- **Test Steps** (Section 7): Lift the **When** clause and break it into numbered steps. For multi-action When clauses, one step per discrete action. Do not invent additional steps — if the When clause is one sentence, the test has one step.
- **Expected Result** (Section 8): Lift the **Then** clause verbatim. For NFR ACs, the Expected Result is the Criterion field copied verbatim from the AC (which is itself a verbatim copy of the parent NFR's Measurable Target).

### 5.6 — Test Data

For FR ACs that mention specific data (e.g., "valid email", "100 contacts", "30-day-old record"): list the data inputs the test needs. For ACs that don't reference specific data: write `(none required beyond the system's baseline state)`.

### 5.7 — Test Environment

Driven by parent NFR's Measurable Target (e.g., "p99 < 200ms under 500 concurrent users" implies a load-test environment). For FR ACs without specific environment requirements: write `(any functional test environment: staging or local)`.

### 5.8 — Pass/Fail Criteria

For FR ACs: pass = Then clause observed within the timeout the team sets at sprint planning; fail = anything else. For NFR ACs: pass = Measurable Target met under the specified conditions; fail = Target not met. Do not invent thresholds beyond what the AC states.

### 5.9 — Owner and Acceptance fields

- **Owner:** parent FR/NFR Stakeholder (SH-###); default `Accepted By` to the same.
- **Status:** `Pending` (the human QA lead changes it).
- **Accepted Date:** `—`.
- **Source:** `SRS Section 8 (AC-###); cross-checked against elicit Section 6.`

---

## Step 6 — Generate / refresh `test-concept.md`

The Test Concept is a single strategy document (regenerated in place every run when the SRS is Accepted). It does **not** contain individual test cases — those live in `test-case-NNN.md` files. It contains the team-facing test strategy synthesised from the SRS.

Sections of `test-concept.md`:

1. **Purpose** — what this test concept covers (the Accepted SRS version it derives from)
2. **Test Strategy** — levels (Acceptance, System, Integration, Unit), types (Functional, Performance, Security, etc.), how the heuristic in Step 5.4 maps ACs to those
3. **Coverage Targets** — every AC has at least one TC; every Must-Have FR has at least one Acceptance-level TC; every Performance/Security NFR has at least one System-level TC at its measurable threshold
4. **Risk-Based Prioritisation** — TCs inherit Priority from parent FR/NFR. Must-Have first, then Should-Have, then Could-Have / Won't
5. **Test Environments** — listed by NFR exposure (local / staging / load-test) with a note that team confirms specifics
6. **Tools and Frameworks** — placeholder; `(team to define during sprint planning)`
7. **Entry Criteria** — SRS Accepted; TCs reviewed and Accepted by the QA lead
8. **Exit Criteria** — every Critical AC has a passing TC run; every High AC has a passing TC run; documented exceptions for Could-Have ACs
9. **Roles & Responsibilities** — TC owner per Section 5.9; QA lead reviews and accepts the TC set; team executes
10. **Reporting** — Pass/fail per TC; aggregate per FR/NFR/Epic; tracked in the team's CI/CD or test-management tool

The Test Concept itself has frontmatter `status: Pending` initially. The human reviewer types APPROVED to mark it Accepted (the skill updates frontmatter on APPROVED).

---

## Step 7 — Validation (Pending TCs only)

Run every check; add OQs at the indicated severity.

1. **AC coverage:** every AC in the SRS canonical list has exactly one TC. Orphan AC → `Critical`. Duplicate (two TCs with same parent-ac) → `Critical`.
2. **TC owner:** every Pending TC has Owner = SH-###. Missing → `Critical`.
3. **Type/Level set:** every Pending TC has Type and Level populated per Step 5.4. Missing → `Critical`.
4. **Preconditions / Steps / Expected:** every Pending TC has all three sections non-empty. Empty Then clause for an FR AC, or empty Criterion for an NFR AC → `Critical`.
5. **AC drift OQs from Step 3:** ensure each is recorded.
6. **Coverage targets from test-concept.md Section 3:** every Must-Have FR has at least one Acceptance-level TC; every Performance/Security NFR has at least one System-level TC. Missing → `High`.

Add a one-line summary to `index.md` Section 9: `"Validation: [N] OQs added across coverage / owner / drift checks."`

---

## Step 8 — Build `index.md`

Always rebuilt from the current state of all `test-case-*.md` files. Never merged.

Sections:

1. **Project Overview** — counts (Pending / Accepted / Rejected), source SRS version + Approved date, total ACs in SRS canonical list, total TCs minted
2. **Test Map** — Mermaid `flowchart LR` with FRs/NFRs as parent nodes branching to TCs. Numeric-only node IDs (`FR001`, `TC001`)
3. **TC List** — table: TC-ID, Title, Parent AC, Parent FR/NFR, Owner, Priority, Type, Level, Status, file path
4. **AC Coverage Matrix** — every AC in SRS canonical list with its TC and `Status` of `Covered` / `Orphan` / `Duplicate`
5. **Type / Level Distribution** — count of TCs per Type, per Level (informational; the team decides if the distribution matches their pyramid)
6. **FR/NFR Coverage Summary** — each FR/NFR with TC count and Priority (helps the QA lead spot under-tested Must-Have requirements)
7. **Open Questions across all TCs** — sorted by Severity (Critical → High → Medium → Low)
8. **Acceptance Status Overview** — TC-ID, Title, Owner, Status, Accepted Date
9. **Revision History** — append-only; one row per run with summary

---

## Step 9 — Write outputs

1. For each Pending TC with changes: rewrite `artifacts/05-test-concept/test-case-NNN.md`. Update `last-updated` frontmatter.
2. For each Accepted/Rejected TC with appended review notes: write only Section 13; leave Sections 1–12 untouched.
3. For each newly-minted TC: create from `skills/create-tests/templates/test-case.md`.
4. Always rewrite `artifacts/05-test-concept/test-concept.md` (unless its own status is Accepted, in which case append review note only and refresh Section 9 Reporting; keep Sections 1–8 untouched).
5. Always rewrite `artifacts/05-test-concept/index.md` from scratch using Step 8 data.

Do not delete files — even Rejected TCs persist so the TC-### is auditable.

---

## Step 10 — Review gate

Present to the user:

> **Changes in this run:**
> - **ADDED:** [list new TC-IDs with parent AC]
> - **REFINED:** [list Pending TCs updated, with reason]
> - **UNCHANGED:** [list Pending TCs with no new info, or omit if long]
> - **PROTECTED:** [list Accepted/Rejected TCs that received review notes only]
> - **DRIFT:** [list AC-### IDs where SRS and elicit doc disagree, with the OQ-### filed]
> - **COVERAGE:** [N ACs in SRS canonical list; M TCs minted or refined; orphans: list AC-IDs]
> - **TYPE/LEVEL DISTRIBUTION:** [Functional/Acceptance N; Performance/System M; Security/System K; ...]

If any OQs remain Open:
> **Warning — Unresolved Open Questions:** [table with Severity column]

Then give your **Professional Assessment** — cite specific element IDs:

**Blocking — APPROVED is invalid until resolved:**
- Critical OQs Open: list OQ-### IDs.
- Pending TCs with no Owner: list TC-### IDs.
- Pending TCs with empty Preconditions / Steps / Expected: list TC-### IDs.
- Orphaned ACs (in SRS canonical list, no TC): list AC-### IDs.
- Duplicate parent-ac across TCs: list TC-### pairs.

**Advisory — flag before approval:**
- AC drift OQs (High-severity from Step 3): list AC-IDs and recommend reconciling upstream.
- Must-Have FRs without an Acceptance-level TC: list FR-IDs.
- Performance/Security NFRs without a System-level TC: list NFR-IDs.

If none of these issues exist: state `"No quality concerns — Test set is ready for approval."`

> Review `artifacts/05-test-concept/index.md` first, then `test-concept.md`, then drill into each `test-case-NNN.md`.
> Type **APPROVED** to mark the Test Concept and TC set as ready for execution (and proceed to `/trace`), or provide corrections.
> **Approval is invalid if any Critical OQ is Open or any coverage gap remains.**

On APPROVED: update `test-concept.md` frontmatter `status: Accepted`. State `"Test phase complete. You may now run /trace to verify forward+backward traceability across the full pipeline."` Do not invoke `/trace` automatically.

---

## ID Reference

| Artifact | Format | Example | Source |
|----------|--------|---------|--------|
| Test Case | TC-### | TC-001 | minted by this skill |
| Open Question | OQ-### | OQ-024 | continues from elicit + epic + story + srs namespaces |
| Acceptance Criterion | AC-FR-###-NN / AC-NFR-###-NN | AC-FR-001-01 | inherited from elicit Section 6 via SRS Section 8 (not minted by this skill) |

TC-### IDs are never reused, even after deletion or rejection. OQ-### IDs are never reused across the entire pipeline namespace.

---

## Edge Cases

| Situation | Action |
|-----------|--------|
| `artifacts/04-srs/srs.md` does not exist | Stop in Step 0. "Run `/create-srs` first." |
| SRS exists but `status` is not Accepted | Stop in Step 0. State the current status. |
| Elicit doc has regressed (status no longer Approved) | Stop. Tell the user to re-Approve in `/elicit`. |
| AC text differs between SRS and elicit doc | OQ Severity=High; treat SRS as authoritative for TC generation. |
| AC in elicit doc but missing from SRS Section 8 | OQ Severity=Medium; skip TC generation. |
| AC in SRS but missing from elicit doc | OQ Severity=Critical; skip TC generation; tells the user the upstream lift was wrong. |
| All canonical ACs already have TCs and nothing has changed | Run completes; index.md rebuilt; review gate reports `UNCHANGED` for every TC. |
| Existing TC references AC-### no longer in SRS canonical list | Append review note + OQ Severity=High; do not modify the TC otherwise. |
| Human edited a TC file manually between runs | Read current state as truth; on Pending status, regenerate per Step 9 — manual edits in regenerated sections are overwritten and the user is warned in the review gate. On Accepted status, only Section 13 is touched; manual edits to Sections 1–12 preserved. |
| Two Pending TCs with identical parent-ac (defensive) | Pick the lower TC-ID; mark the higher Rejected with note "duplicate of TC-### — superseded". OQ Severity=High asks the human to confirm. |
