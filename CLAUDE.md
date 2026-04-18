# AI-Augmented-RE

AI-Augmented Requirements Engineering — a portable framework that uses AI agents and skills to guide teams through the full RE lifecycle: from raw stakeholder inputs to traceable, implementation-ready artifacts.

## Goal

> A self-contained, repo-based RE framework that works identically in Claude Code and GitHub Copilot, producing consistent, traceable artifacts from Elicitation Document through to Test Cases — with human review gates between every step.

## Architecture — Hybrid: Pipeline Agent + Phase Skills

```
RE Pipeline Agent (orchestrator + traceability guardian)
│
│  Knows: full artifact chain, cross-references, consistency rules, terminology
│  Does: guides human through pipeline, validates transitions, ensures traceability
│
├── /elicit skill        — reads inputs/, produces Elicitation Document
├── /create-epics skill  — transforms Elicitation Doc into Epics
├── /create-stories skill— decomposes Epics into User Stories
├── /create-srs skill    — compiles SRS from Stories + Epics
├── /create-tests skill  — derives Test Concept + Test Cases from SRS
└── /trace skill         — generates traceability matrix, detects gaps
```

**Artifact pipeline (sequential, human-reviewed):**
```
Raw Inputs → Elicitation Document → Epics → User Stories → SRS → Test Concept + Test Cases → Code
                 ↑ review gate      ↑ gate   ↑ gate       ↑ gate    ↑ gate
```

Each artifact requires explicit human approval before the next is generated.

## Design decisions (aligned with user)

| Decision | Choice | Rationale |
|---|---|---|
| Target users | Small team of RE engineers + developers | Not just personal — must work for a team |
| Runtime platforms | Claude Code AND GitHub Copilot | Project stays on whichever tool it started in |
| Portability | Standalone repo, no external dependencies | Must work at home (with Obsidian) AND at work (no Obsidian) |
| Architecture | Hybrid: Pipeline Agent + phase-specific skills | Agent maintains traceability; skills keep each phase focused and portable |
| Automation level | Fully guided, step-by-step | Human reviews and approves each artifact before next is generated |
| Input formats | Mixed: Markdown, Word (.docx), PDF, plain text | Team drops whatever they have into inputs/ |
| Artifact storage | In project repo under artifacts/ | Numbered folders reflect pipeline order |
| Private projects | Obsidian vault always involved | Artifacts start in vault, stabilize to GitHub repo |
| Work projects | No Obsidian, GitHub repos only | Copilot in VS Code/IntelliJ, all artifacts in repo |
| Agent vs Skills | Hybrid (Approach C) | Pipeline Agent orchestrates + guards traceability; skills do the heavy lifting per phase |

## Repository structure (agreed)

```
ai-augmented-re/
├── CLAUDE.md                    # Claude Code agent definition (Pipeline Agent)
├── .github/
│   └── copilot-instructions.md  # Copilot equivalent of CLAUDE.md
├── AGENTS.md                    # Shared agent context (both platforms read this)
├── skills/
│   ├── elicit/
│   │   ├── skill.md             # Skill definition + prompt
│   │   └── templates/
│   │       └── elicitation-document.md
│   ├── create-epics/
│   │   ├── skill.md
│   │   └── templates/
│   │       └── epic.md
│   ├── create-stories/
│   │   ├── skill.md
│   │   └── templates/
│   │       └── user-story.md
│   ├── create-srs/
│   │   ├── skill.md
│   │   └── templates/
│   │       └── srs.md
│   ├── create-tests/
│   │   ├── skill.md
│   │   └── templates/
│   │       ├── test-concept.md
│   │       └── test-case.md
│   └── trace/
│       └── skill.md
├── inputs/                      # Per-project: raw input documents
│   └── README.md
├── artifacts/                   # Per-project: generated artifacts
│   ├── 01-elicitation/
│   ├── 02-epics/
│   ├── 03-user-stories/
│   ├── 04-srs/
│   └── 05-test-concept/
└── docs/
    ├── methodology.md           # How to use the framework (team onboarding)
    └── superpowers/
        └── specs/               # Design specs for the framework itself
```

## Elicitation Document structure (agreed)

The Elicitation Document is the foundational artifact. It contains:
- **Stakeholders** — who was consulted, their roles, their concerns
- **Business Use Cases** — what the system must enable at a business level
- **Requirements List** — numbered, categorized (functional, non-functional, constraints)
- **Acceptance Criteria** — measurable conditions for each requirement
- **Open Questions** — everything unclear, with responsible party and deadline

Inputs that feed the Elicitation Document:
- Meeting notes / minutes from stakeholder talks
- Existing documentation (technical and non-technical)
- All organized in `inputs/` with sub-folders

## Platform portability

The same RE methodology works in both platforms:

| Concern | Claude Code | GitHub Copilot |
|---|---|---|
| Agent definition | `CLAUDE.md` | `.github/copilot-instructions.md` |
| Shared context | `AGENTS.md` (read by both) | `AGENTS.md` (read by both) |
| Skills | `skills/` folder with skill.md files | `skills/` folder (Copilot reads as instruction files) |
| Invocation | `/elicit`, `/create-epics`, etc. | Prompt: "run the elicit skill" or custom Copilot agents |
| Templates | Same markdown templates | Same markdown templates |

## Private vs Work integration

**At work:** The repo IS the complete system. No external tools needed. Copilot reads AGENTS.md and skills/ to understand the methodology. All artifacts live in the repo.

**At home (private projects):** Same repo structure, but additionally:
- Obsidian vault project page in `10-Projects/AI-Augmented-RE/` links to the repo
- Artifacts may start as vault notes during early ideation, then move to repo
- Knowledge base in `40-Knowledge/` provides background context
- Session logs route through the vault's logging system

The Obsidian layer is purely additive — removing it doesn't break anything.

## Design status

- [x] Target users defined (small RE + dev team)
- [x] Runtime platforms decided (Claude Code + GitHub Copilot)
- [x] Portability model decided (standalone repo, optional Obsidian layer)
- [x] Architecture decided (Hybrid: Pipeline Agent + phase skills)
- [x] Automation level decided (fully guided, step-by-step with review gates)
- [x] Repository structure agreed
- [x] Elicitation Document structure agreed
- [ ] Detailed skill definitions (prompts, templates) — next step
- [ ] AGENTS.md content — next step
- [ ] Traceability model details — next step
- [ ] Implementation plan — after spec is complete

## Spec document

See: `docs/superpowers/specs/2026-04-18-ai-augmented-re-design.md`
(`docs/` is a symlink to the Obsidian vault project folder)

## Key paths

- **Claude project:** `~/projects/AI-Augmented-RE/`
- **Vault project:** `10-Projects/AI-Augmented-RE/`
- **Vault root:** `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain/`

## Session log routing

Stop hook fires `project: $(basename $PWD)`. Starting Claude from `~/projects/AI-Augmented-RE/` routes logs to `10-Projects/AI-Augmented-RE/AI-Augmented-RE-Log.md`.

## Full runbook

See vault: `10-Projects/AI-Augmented-RE/AI-Augmented-RE.md`
