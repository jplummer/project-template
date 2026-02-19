#!/usr/bin/env bash
# Sets up agent configuration for a new project.
# Usage: ./new-project.sh /path/to/project
#
# Creates:
#   AGENTS.md           — project-level agent rules (from template)
#   CLAUDE.md           — symlink to AGENTS.md
#   .agents/rules/      — domain-specific rule files (from template)
#   .cursor/rules       — symlink to ../.agents/rules

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$REPO_DIR/template"

if [ -z "$1" ]; then
  echo "Usage: ./new-project.sh /path/to/project"
  echo ""
  echo "Copies agent configuration template into a project directory."
  echo "Safe to run on existing projects — will not overwrite existing files."
  exit 1
fi

TARGET="$1"

if [ ! -d "$TARGET" ]; then
  echo "Error: $TARGET is not a directory"
  exit 1
fi

echo "Setting up agent config in: $TARGET"
echo ""

# --- Copy template files (skip existing) ---

copied=0
skipped=0

copy_if_missing() {
  local src="$1"
  local rel="${src#$TEMPLATE_DIR/}"
  local dest="$TARGET/$rel"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  mkdir -p "$dest_dir"

  if [ -f "$dest" ]; then
    echo "  skip: $rel (already exists)"
    skipped=$((skipped + 1))
  else
    cp "$src" "$dest"
    echo "  copy: $rel"
    copied=$((copied + 1))
  fi
}

for src_file in $(find "$TEMPLATE_DIR" -type f | sort); do
  copy_if_missing "$src_file"
done

# --- Create symlinks ---

echo ""
echo "Symlinks:"

# CLAUDE.md -> AGENTS.md
if [ -L "$TARGET/CLAUDE.md" ]; then
  echo "  skip: CLAUDE.md (symlink already exists)"
elif [ -f "$TARGET/CLAUDE.md" ]; then
  echo "  skip: CLAUDE.md (regular file exists — remove manually to switch to symlink)"
else
  ln -s AGENTS.md "$TARGET/CLAUDE.md"
  echo "  link: CLAUDE.md -> AGENTS.md"
fi

# .cursor/rules -> ../.agents/rules
mkdir -p "$TARGET/.cursor"
if [ -L "$TARGET/.cursor/rules" ]; then
  echo "  skip: .cursor/rules (symlink already exists)"
elif [ -d "$TARGET/.cursor/rules" ]; then
  echo "  skip: .cursor/rules (directory exists — remove manually to switch to symlink)"
else
  ln -s ../.agents/rules "$TARGET/.cursor/rules"
  echo "  link: .cursor/rules -> ../.agents/rules"
fi

echo ""
echo "Done: $copied copied, $skipped skipped"
echo ""
echo "Next steps:"
echo "  1. Edit AGENTS.md — update project name, description, and key principles"
echo "  2. Add project-specific rules to .agents/rules/ as needed"
echo "  3. Add @imports to AGENTS.md for any project docs"
