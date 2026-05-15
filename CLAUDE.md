# AI-Augmented RE Framework

AI-Augmented Requirements Engineering — a portable framework that uses AI agents and skills to guide teams through the full RE lifecycle: from raw stakeholder inputs to traceable, implementation-ready artifacts.

> **For new projects:** run `./setup.sh` (or `./setup.sh <target-dir>` for standalone mode). That script creates a project-specific `CLAUDE.md` from `setup/CLAUDE.md.template`. This file is the framework's own agent definition.

See `AGENTS.md` for shared context that both Claude Code and GitHub Copilot read.

---

## RE Pipeline

```
Raw Inputs → Elicitation → Epics → Stories → SRS → Tests → Traceability → Implementation Tasks
               ↑ gate      ↑ gate  ↑ gate    ↑ gate ↑ gate   (audit)         ↑ gate
```

Each generative artifact requires explicit human approval before the next is generated. `/trace` is a read-only auditor and has no gate.

## Skills

| Phase | Skill | Artifact |
|-------|-------|----------|
| 1 | `/elicit` | Elicitation Document |
| 1b | `/arch-diagrams` | Section 4 — Component + Sequence Diagrams |
| 2 | `/create-epics` | Epics |
| 3 | `/create-stories` | User Stories |
| 4 | `/create-srs` | Software Requirements Specification |
| 5 | `/create-tests` | Test Concept + Test Cases |
| 6 | `/trace` | Traceability Matrix |
| 7 | `/create-tasks` | Implementation Tasks (Dev-Team handoff) |

## Architecture — Hybrid: Pipeline Agent + Phase Skills

```
RE Pipeline Agent (orchestrator + traceability guardian)
│
│  Knows: full artifact chain, cross-references, consistency rules, terminology
│  Does: guides human through pipeline, validates transitions, ensures traceability
│
├── /elicit skill         — reads inputs/, produces Elicitation Document
├── /create-epics skill   — transforms Elicitation Doc into Epics
├── /create-stories skill — decomposes Epics into User Stories
├── /create-srs skill     — compiles SRS from Stories + Epics
├── /create-tests skill   — derives Test Concept + Test Cases from SRS
├── /trace skill          — generates traceability matrix, detects gaps
└── /create-tasks skill   — decomposes Accepted Stories into codebase-agnostic implementation Tasks (Dev-Team handoff)
```

## Traceability ID Chain

Every artifact element carries a unique ID linking forward through the pipeline:

```
SH-001 → BUC-001 → FR-001 → EP-001 → US-001 → AC-FR-001-01 → TC-001 → TASK-001
```

IDs are never reused, even after deletion or resolution.

## Platform Portability

| Concern | Claude Code | GitHub Copilot |
|---------|------------|----------------|
| Agent definition | `CLAUDE.md` | `.github/copilot-instructions.md` |
| Shared context | `AGENTS.md` | `AGENTS.md` |
| Skill invocation | `/elicit` (slash command) | "Run the elicit skill" |
| Binary file reading | Native (PDF, DOCX) | Convert to text first |

## Repository Structure

```
ai-augmented-re/
├── CLAUDE.md                    — this file (framework agent definition)
├── AGENTS.md                    — shared context (both platforms)
├── setup.sh                     — project bootstrap script
├── sync-framework.sh            — push framework updates to existing projects
├── AUDIT-PROTOCOL-ELICITATION.md  — quality audit protocol (AP-ELIC-001)
├── AUDIT-REPORT-ELICITATION.md    — initial audit findings (2026-04-22)
├── setup/
│   ├── CLAUDE.md.template       — project-facing CLAUDE.md (created by setup.sh)
│   └── AGENTS.md.template       — AGENTS.md template (created by setup.sh)
├── skills/
│   ├── GOVERNANCE.md            — canonical governance rules (synced to projects)
│   ├── elicit/
│   │   ├── skill.md             — /elicit skill definition
│   │   └── templates/
│   │       └── elicitation-document.md
│   ├── arch-diagrams/
│   │   └── skill.md             — /arch-diagrams skill definition
│   ├── create-epics/
│   │   ├── skill.md             — /create-epics skill definition
│   │   ├── templates/
│   │   │   ├── epic.md          — per-Epic file template
│   │   │   └── index.md         — Epics aggregator/index template
│   │   └── evals/
│   │       └── evals.json       — skill-creator iteration-1 test prompts
│   ├── create-stories/
│   │   ├── skill.md             — /create-stories skill definition
│   │   ├── templates/
│   │   │   ├── story.md         — per-Story file template
│   │   │   └── index.md         — Stories aggregator/index template
│   │   └── evals/
│   │       └── evals.json       — skill-creator iteration-1 test prompts
│   ├── create-srs/
│   │   ├── skill.md             — /create-srs skill definition
│   │   ├── templates/
│   │   │   └── srs.md           — Software Requirements Specification template
│   │   └── evals/
│   │       └── evals.json       — skill-creator iteration-1 test prompts
│   ├── create-tests/
│   │   ├── skill.md             — /create-tests skill definition
│   │   ├── templates/
│   │   │   ├── test-concept.md  — Test Concept (strategy) template
│   │   │   ├── test-case.md     — per-Test-Case template
│   │   │   └── index.md         — Tests aggregator/index template
│   │   └── evals/
│   │       └── evals.json       — skill-creator iteration-1 test prompts
│   ├── trace/
│   │   ├── skill.md             — /trace skill definition (pipeline auditor)
│   │   ├── templates/
│   │   │   └── traceability-matrix.md  — Traceability Matrix template
│   │   └── evals/
│   │       └── evals.json       — skill-creator iteration-1 test prompts
│   └── create-tasks/
│       ├── skill.md             — /create-tasks skill definition (Phase 7 — Dev-Team handoff)
│       ├── templates/
│       │   ├── task.md          — per-Task file template
│       │   └── index.md         — Tasks aggregator/index template
│       └── evals/
│           └── evals.json       — skill-creator iteration-1 test prompts
├── examples/
│   ├── 01-elicitation/
│   │   └── elicitation-document-example.md  — benchmark artifact (PocketPing elicit doc)
│   ├── 02-epics/
│   │   ├── index.md
│   │   ├── epic-001.md
│   │   ├── epic-002.md
│   │   └── epic-003.md          — benchmark Epic set derived from PocketPing
│   ├── 03-user-stories/
│   │   ├── index.md
│   │   └── story-001..008.md    — benchmark Story set derived from those Epics
│   ├── 04-srs/
│   │   └── srs.md               — benchmark SRS compiled from elicit + epics + stories
│   ├── 05-test-concept/
│   │   ├── test-concept.md
│   │   ├── test-case-001..014.md
│   │   └── index.md             — benchmark Test Concept + 14 Test Cases derived from the SRS
│   ├── 06-traceability/
│   │   └── traceability-matrix.md  — benchmark traceability matrix produced by /trace
│   └── 07-implementation-tasks/
│       ├── index.md
│       └── task-001..NNN.md     — benchmark Task set derived from the PocketPing chain
├── docs/                        — framework documentation and specifications
├── inputs/                      — drop raw documents here
│   └── README.md
└── artifacts/                   — generated RE artifacts (version-controlled)
    ├── 01-elicitation/
    ├── 02-epics/
    ├── 03-user-stories/
    ├── 04-srs/
    ├── 05-test-concept/
    ├── 06-traceability/
    └── 07-implementation-tasks/
```
