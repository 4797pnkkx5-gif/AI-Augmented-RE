#!/usr/bin/env bash
# AI-Augmented RE — Project Setup Script
# Usage:
#   Template mode (inside a cloned template repo):  ./setup.sh
#   Standalone mode (create a new project anywhere): ./setup.sh <target-directory>

set -e

# ── Colours ──────────────────────────────────────────────────────────────────
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

info()    { echo -e "${BOLD}$*${RESET}"; }
success() { echo -e "${GREEN}✓ $*${RESET}"; }
warn()    { echo -e "${YELLOW}⚠ $*${RESET}"; }
error()   { echo -e "${RED}✗ $*${RESET}" >&2; exit 1; }

# ── Determine script location (works even when run as standalone) ─────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OBSIDIAN_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/SecondBrain"

# ── Banner ────────────────────────────────────────────────────────────────────
echo
echo -e "${BOLD}══════════════════════════════════════════${RESET}"
echo -e "${BOLD}   AI-Augmented RE — Project Setup        ${RESET}"
echo -e "${BOLD}══════════════════════════════════════════${RESET}"
echo

# ── Mode detection ────────────────────────────────────────────────────────────
STANDALONE=false
TARGET_DIR=""

if [[ -n "$1" ]]; then
  STANDALONE=true
  TARGET_DIR="$(realpath "$1" 2>/dev/null || echo "$1")"
  info "Mode: standalone → creating project at $TARGET_DIR"
else
  TARGET_DIR="$(pwd)"
  info "Mode: template → initializing current directory"
fi

echo

# ── Standalone: copy framework files into new directory ──────────────────────
if [[ "$STANDALONE" == true ]]; then
  if [[ -e "$TARGET_DIR" ]]; then
    error "Target directory already exists: $TARGET_DIR\nChoose a path that does not exist yet."
  fi

  info "Copying framework files to $TARGET_DIR ..."
  mkdir -p "$TARGET_DIR"

  rsync -a --exclude='.git' --exclude='.DS_Store' --exclude='docs' \
    "$SCRIPT_DIR/" "$TARGET_DIR/"

  # Replace CLAUDE.md with the project template
  cp "$SCRIPT_DIR/setup/CLAUDE.md.template" "$TARGET_DIR/CLAUDE.md"

  cd "$TARGET_DIR"

  info "Initialising git repository ..."
  git init -q
  git branch -M main
  success "Git repository initialised"
  echo

else
  # ── Template: idempotency check ───────────────────────────────────────────
  if ! grep -q '<!-- PROJECT_NAME -->' CLAUDE.md 2>/dev/null; then
    warn "This project appears to be already initialised (no PROJECT_NAME placeholder found in CLAUDE.md)."
    warn "Run setup.sh <target-directory> to create a new project instead."
    exit 0
  fi
fi

# ── Project name ──────────────────────────────────────────────────────────────
while true; do
  read -r -p "$(echo -e "${BOLD}Project display name${RESET} (e.g. My Banking App): ")" PROJECT_DISPLAY_NAME
  if [[ -n "$PROJECT_DISPLAY_NAME" ]]; then
    break
  fi
  warn "Project name cannot be empty."
done

# Derive slug: lowercase, spaces and underscores → hyphens, strip non-alphanumeric
PROJECT_SLUG="$(echo "$PROJECT_DISPLAY_NAME" | tr '[:upper:]' '[:lower:]' | tr ' _' '-' | tr -cd 'a-z0-9-')"

echo
info "Project:  $PROJECT_DISPLAY_NAME"
info "Slug:     $PROJECT_SLUG"
echo

# ── CLAUDE.md ─────────────────────────────────────────────────────────────────
info "Configuring CLAUDE.md ..."
# macOS sed requires -i '' for in-place editing
sed -i '' "s/<!-- PROJECT_NAME -->/$PROJECT_DISPLAY_NAME/g" CLAUDE.md
sed -i '' "s/<!-- PROJECT_SLUG -->/$PROJECT_SLUG/g" CLAUDE.md
success "CLAUDE.md configured"

# ── AGENTS.md ─────────────────────────────────────────────────────────────────
info "Creating AGENTS.md ..."
cp setup/AGENTS.md.template AGENTS.md
sed -i '' "s/<!-- PROJECT_NAME -->/$PROJECT_DISPLAY_NAME/g" AGENTS.md
success "AGENTS.md created"

# ── GitHub Copilot instructions ───────────────────────────────────────────────
info "Creating .github/copilot-instructions.md ..."
mkdir -p .github
cp AGENTS.md .github/copilot-instructions.md
success ".github/copilot-instructions.md created"

# ── .gitignore ────────────────────────────────────────────────────────────────
if [[ ! -f ".gitignore" ]]; then
  info "Creating .gitignore ..."
  cat > .gitignore << 'EOF'
# Obsidian vault symlink — machine-specific, recreated by setup.sh
docs

# macOS
.DS_Store

# Input manifest — tracks processed files per project (commit if you want history)
# inputs/manifest.md

# Editor
.vscode/
.idea/
EOF
  success ".gitignore created"
fi

# ── Artifact folders ──────────────────────────────────────────────────────────
info "Creating artifact folders ..."
for folder in artifacts/02-epics artifacts/03-user-stories artifacts/04-srs artifacts/05-test-concept; do
  mkdir -p "$folder"
  touch "$folder/.gitkeep"
done
success "Artifact folders ready (01 through 05)"

# ── Obsidian vault integration ────────────────────────────────────────────────
echo
read -r -p "$(echo -e "${BOLD}Set up Obsidian vault integration?${RESET} (y/n): ")" OBSIDIAN_CHOICE

if [[ "$OBSIDIAN_CHOICE" =~ ^[Yy]$ ]]; then
  if [[ -d "$OBSIDIAN_VAULT" ]]; then
    VAULT_PROJECT="$OBSIDIAN_VAULT/10-Projects/$PROJECT_DISPLAY_NAME"
    info "Creating vault project folder: 10-Projects/$PROJECT_DISPLAY_NAME ..."

    mkdir -p "$VAULT_PROJECT/Documentation"
    mkdir -p "$VAULT_PROJECT/Learning"
    mkdir -p "$VAULT_PROJECT/Plans"
    mkdir -p "$VAULT_PROJECT/Specification"

    # Project index
    cat > "$VAULT_PROJECT/$PROJECT_DISPLAY_NAME.md" << EOF
---
title: $PROJECT_DISPLAY_NAME
aliases: ["$PROJECT_DISPLAY_NAME"]
created: $(date +%Y-%m-%d)
tags: [type/project, status/active, topic/requirements-engineering]
status: active
---

## Goal

> Requirements Engineering project using the AI-Augmented RE framework.

## RE Pipeline

| Phase | Skill | Status |
|-------|-------|--------|
| Elicitation | \`/elicit\` | Pending |
| Epics | \`/create-epics\` | Pending |
| User Stories | \`/create-stories\` | Pending |
| SRS | \`/create-srs\` | Pending |
| Test Cases | \`/create-tests\` | Pending |
| Traceability | \`/trace\` | Pending |

## Open Tasks

\`\`\`dataview
TASK FROM "10-Projects/$PROJECT_DISPLAY_NAME"
WHERE !completed
\`\`\`

## Key Paths

- **Repo:** \`~/projects/$PROJECT_SLUG/\`

## Links

- [[$PROJECT_DISPLAY_NAME-Log]] — activity log

## Related

- [[AI-Augmented-RE]] — framework documentation

## Status

Last updated: $(date +%Y-%m-%d)
EOF

    # Activity log
    cat > "$VAULT_PROJECT/$PROJECT_DISPLAY_NAME-Log.md" << EOF
---
title: $PROJECT_DISPLAY_NAME — Log
aliases: ["$PROJECT_DISPLAY_NAME Log"]
created: $(date +%Y-%m-%d)
tags: [type/log, topic/requirements-engineering]
---

# $PROJECT_DISPLAY_NAME — Activity Log

EOF

    success "Vault folder created: 10-Projects/$PROJECT_DISPLAY_NAME/"

    # docs/ symlink
    if [[ -L "docs" ]]; then
      warn "docs/ symlink already exists — skipping"
    else
      ln -s "$VAULT_PROJECT" docs
      success "docs/ symlink created → vault project folder"
    fi

  else
    warn "Obsidian vault not found at: $OBSIDIAN_VAULT"
    warn "Skipping vault integration."
  fi
else
  info "Obsidian vault integration skipped."
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo
echo -e "${BOLD}══════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}   Setup complete: $PROJECT_DISPLAY_NAME   ${RESET}"
echo -e "${BOLD}══════════════════════════════════════════${RESET}"
echo
echo -e "${BOLD}Next steps:${RESET}"
echo "  1. Drop your input documents into inputs/"
echo "     (meeting notes, specs, briefs — any format)"
echo
echo "  2. Start the elicitation phase:"
echo "     Claude Code:      /elicit"
echo "     GitHub Copilot:   \"Run the elicit skill\""
echo
echo "  3. Review the Elicitation Document and type APPROVED"
echo
echo "  4. Continue with /create-epics"
echo
if [[ "$STANDALONE" == true ]]; then
  echo -e "${BOLD}Project location:${RESET} $TARGET_DIR"
  echo -e "${BOLD}Push to GitHub:${RESET}"
  echo "  git remote add origin <your-repo-url>"
  echo "  git add -A && git commit -m \"chore: initialise RE project\""
  echo "  git push -u origin main"
  echo
fi
