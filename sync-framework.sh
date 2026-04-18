#!/usr/bin/env bash
# sync-framework.sh — Push framework updates to an existing project.
# Usage: ./sync-framework.sh <project-dir>
#
# Syncs framework-owned files (skills/, setup.sh, setup/) into a project
# created by setup.sh. Never touches project-owned files (AGENTS.md, CLAUDE.md,
# .github/, inputs/, artifacts/, README.md, LICENSE).

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────────────────
if [[ -t 1 ]]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; RESET='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; CYAN=''; RESET=''
fi

info()    { echo -e "${CYAN}→${RESET} $*"; }
success() { echo -e "${GREEN}✓${RESET} $*"; }
warn()    { echo -e "${YELLOW}!${RESET} $*"; }
error()   { echo -e "${RED}✗${RESET} $*" >&2; }

# ── Step 1: Validate arguments ────────────────────────────────────────────────
if [[ $# -ne 1 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
  echo "Usage: $(basename "$0") <project-dir>"
  echo ""
  echo "Syncs framework-owned files (skills/, setup.sh, setup/) into an existing"
  echo "project directory created by setup.sh."
  echo ""
  echo "Project-owned files are never touched:"
  echo "  AGENTS.md, CLAUDE.md, .github/, inputs/, artifacts/, README.md, LICENSE"
  exit 0
fi

FRAMEWORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(realpath "$1" 2>/dev/null || true)"

if [[ -z "$TARGET_DIR" ]] || [[ ! -d "$TARGET_DIR" ]]; then
  error "Target directory does not exist: $1"
  exit 1
fi

# ── Step 2: Pre-flight check ──────────────────────────────────────────────────
if [[ ! -f "$FRAMEWORK_DIR/skills/elicit/skill.md" ]]; then
  error "Cannot find skills/elicit/skill.md in $FRAMEWORK_DIR"
  error "Run this script from the AI-Augmented-RE framework directory."
  exit 1
fi

if [[ "$FRAMEWORK_DIR" == "$TARGET_DIR" ]]; then
  error "Source and target are the same directory. Aborting."
  exit 1
fi

if [[ ! -f "$TARGET_DIR/CLAUDE.md" ]] && [[ ! -d "$TARGET_DIR/artifacts" ]]; then
  warn "Target does not look like an AI-Augmented RE project (no CLAUDE.md or artifacts/)."
  warn "Proceeding anyway — press Ctrl-C to abort."
  sleep 2
fi

echo ""
info "Framework: $FRAMEWORK_DIR"
info "Target:    $TARGET_DIR"
echo ""

# ── Step 3: Dry-run preview ───────────────────────────────────────────────────
RSYNC_ARGS=(
  -a
  --include='skills'
  --include='skills/***'
  --include='setup.sh'
  --include='setup'
  --include='setup/***'
  --exclude='*'
)

DRY_OUTPUT=$(rsync "${RSYNC_ARGS[@]}" --dry-run --itemize-changes \
  "$FRAMEWORK_DIR/" "$TARGET_DIR/" | grep -v '^\.' || true)

if [[ -z "$DRY_OUTPUT" ]]; then
  success "Nothing to sync — target is already up to date."
  exit 0
fi

echo "Files that will be updated:"
echo "$DRY_OUTPUT" | sed 's/^[^ ]* /  /'
echo ""

read -r -p "Proceed? (y/n): " CONFIRM
if [[ "$CONFIRM" != "y" ]] && [[ "$CONFIRM" != "Y" ]]; then
  echo "Sync cancelled."
  exit 0
fi

# ── Step 4: Sync ──────────────────────────────────────────────────────────────
echo ""
rsync "${RSYNC_ARGS[@]}" "$FRAMEWORK_DIR/" "$TARGET_DIR/"

# ── Step 5: Post-sync reminder ────────────────────────────────────────────────
echo ""
success "Framework files synced to $TARGET_DIR"
echo ""
echo "Next steps:"
echo "  1. cd $TARGET_DIR"
echo "  2. git diff                                  — review what changed"
echo "  3. git add -p                                — stage selectively if needed"
echo "  4. git commit -m \"chore: sync framework $(date +%Y-%m-%d)\""
