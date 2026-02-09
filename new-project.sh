#!/usr/bin/env bash
# Sets up agent configuration for a new project.
# Usage: ./new-project.sh /path/to/project

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"

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

# Copy template files, skipping any that already exist
copied=0
skipped=0

copy_if_missing() {
  local src="$1"
  local rel="${src#$TEMPLATE_DIR/}"
  local dest="$TARGET/$rel"
  local dest_dir="$(dirname "$dest")"

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

echo ""
echo "Done: $copied copied, $skipped skipped"
echo ""
echo "Next steps:"
echo "  1. Edit CLAUDE.md — update project name, description, and key principles"
echo "  2. Add project-specific rules to .cursor/rules/ as needed"
echo "  3. Add @imports to CLAUDE.md for any project docs"
echo "  4. On first Claude Code session, it will create MEMORY.md automatically."
echo "     Set its content to:"
echo ""
echo '     # Project Memory'
echo '     Shared with Cursor — write learnings to `.cursor/rules/memory.mdc`, not here.'
echo '     @.cursor/rules/memory.mdc'
