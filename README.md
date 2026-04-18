# AI-Augmented Requirements Engineering

A portable RE framework that uses AI agents and skills to guide teams from raw stakeholder inputs to traceable, implementation-ready artifacts — with human review gates at every step.

Works identically in **Claude Code** and **GitHub Copilot**. No external dependencies.

---

## How It Works

```
Raw Inputs → Elicitation Document → Epics → User Stories → SRS → Test Cases
               ↑ review gate        ↑ gate   ↑ gate       ↑ gate   ↑ gate
```

A **Pipeline Agent** (defined in `CLAUDE.md` / `AGENTS.md`) orchestrates the full lifecycle and guards traceability. **Phase skills** (`skills/*/skill.md`) do the heavy lifting one artifact at a time.

| Skill | Invoke | Output |
|-------|--------|--------|
| Elicitation | `/elicit` | Elicitation Document (stakeholders, BUC diagram, requirements, ACs) |
| Epics | `/create-epics` | Epics |
| User Stories | `/create-stories` | User Stories |
| SRS | `/create-srs` | Software Requirements Specification |
| Test Cases | `/create-tests` | Test Concept + Test Cases |
| Traceability | `/trace` | Traceability Matrix |

Each skill presents a review gate. The next phase only starts after you type **APPROVED**.

---

## Quick Start

### Option 1 — GitHub Template (recommended)

1. Click **Use this template** → create a new repo in any GitHub org (personal or company)
2. Clone your new repo
3. Run the setup script:

```bash
./setup.sh
```

### Option 2 — Standalone Script

Create a new project anywhere on your machine without using the GitHub template feature:

```bash
# Clone the framework
git clone https://github.com/axelburkhardt/ai-augmented-re.git
cd ai-augmented-re

# Create a new project in a separate directory
./setup.sh ~/projects/my-new-project
```

The new project is a fully independent git repo — push it to any GitHub org.

### After Setup

```
1. Drop input documents into inputs/
   (meeting notes, specs, briefs — Markdown, PDF, Word, YAML, JSON)

2. Claude Code:     /elicit
   GitHub Copilot:  "Run the elicit skill"

3. Review the Elicitation Document → type APPROVED

4. Continue with /create-epics
```

---

## Repository Structure

```
ai-augmented-re/
├── CLAUDE.md                    # Pipeline Agent definition (Claude Code)
├── AGENTS.md                    # Shared AI context (both platforms)
├── setup.sh                     # Project bootstrap script
├── .gitignore
├── .github/
│   └── copilot-instructions.md  # Copilot equivalent of CLAUDE.md
├── setup/
│   ├── CLAUDE.md.template       # Project-facing CLAUDE.md (used by setup.sh)
│   └── AGENTS.md.template       # AGENTS.md template (used by setup.sh)
├── skills/
│   └── elicit/
│       ├── skill.md             # /elicit skill definition
│       └── templates/
│           └── elicitation-document.md
├── inputs/                      # Drop your raw documents here
│   └── README.md
└── artifacts/                   # Generated RE artifacts (version-controlled)
    ├── 01-elicitation/
    ├── 02-epics/
    ├── 03-user-stories/
    ├── 04-srs/
    └── 05-test-concept/
```

---

## Requirements

- **Claude Code** or **GitHub Copilot** (VS Code / JetBrains)
- **bash** — for `setup.sh` (macOS / Linux)
- **git**

For GitHub Copilot users: `.docx` and `.pdf` inputs require conversion to text before the skill can read them (`pandoc` or `pdftotext`). Claude Code reads these formats natively.

---

## Traceability

Every artifact element carries a unique ID. IDs link forward through the pipeline:

```
SH-001 → BUC-001 → FR-001 → EP-001 → US-001 → TC-001
```

IDs are never reused, even after deletion or resolution.

---

## License

MIT — see [LICENSE](LICENSE).
