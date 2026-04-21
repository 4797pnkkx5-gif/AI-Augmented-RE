# AI-Augmented RE Framework

AI-Augmented Requirements Engineering — a portable framework that uses AI agents and skills to guide teams through the full RE lifecycle: from raw stakeholder inputs to traceable, implementation-ready artifacts.

> **For new projects:** run `./setup.sh` (or `./setup.sh <target-dir>` for standalone mode). That script creates a project-specific `CLAUDE.md` from `setup/CLAUDE.md.template`. This file is the framework's own agent definition.

See `AGENTS.md` for shared context that both Claude Code and GitHub Copilot read.

---

## RE Pipeline

```
Raw Inputs → Elicitation Document → Epics → User Stories → SRS → Test Cases
               ↑ review gate        ↑ gate   ↑ gate       ↑ gate   ↑ gate
```

Each artifact requires explicit human approval before the next is generated.

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
└── /trace skill          — generates traceability matrix, detects gaps
```

## Traceability ID Chain

Every artifact element carries a unique ID linking forward through the pipeline:

```
SH-001 → BUC-001 → FR-001 → EP-001 → US-001 → TC-001
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
├── setup/
│   ├── CLAUDE.md.template       — project-facing CLAUDE.md (created by setup.sh)
│   └── AGENTS.md.template       — AGENTS.md template (created by setup.sh)
├── skills/
│   └── elicit/
│       ├── skill.md             — /elicit skill definition
│       └── templates/
│           └── elicitation-document.md
├── inputs/                      — drop raw documents here
│   └── README.md
└── artifacts/                   — generated RE artifacts (version-controlled)
    ├── 01-elicitation/
    ├── 02-epics/
    ├── 03-user-stories/
    ├── 04-srs/
    └── 05-test-concept/
```
