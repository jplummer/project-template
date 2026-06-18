#!/usr/bin/env bash
# Sets up global agent configuration from the dotagents repo.
# Clones ~/.agents/ if not present; pulls latest if it is.
# Creates OS-level symlinks for Claude Code, Codex, and Gemini CLI.
#
# Run this on a new machine or after reinstalling tools.

set -e

AGENTS_DIR="$HOME/.agents"
AGENTS_REPO="git@github.com:jplummer/dotagents.git"

echo "Setting up global agent configuration..."
echo ""

# --- Ensure ~/.agents/ is a git repo ---
if [ -d "$AGENTS_DIR/.git" ]; then
  echo "  ~/.agents/ exists — pulling latest"
  git -C "$AGENTS_DIR" pull
else
  echo "  Cloning dotagents into ~/.agents/"
  git clone "$AGENTS_REPO" "$AGENTS_DIR"
fi

echo ""

# --- Create symlinks ---
create_symlink() {
  local target="$1"
  local link="$2"
  local link_dir
  link_dir="$(dirname "$link")"
  mkdir -p "$link_dir"

  if [ -L "$link" ]; then
    local current
    current="$(readlink "$link")"
    if [ "$current" = "$target" ]; then
      echo "  unchanged: $link -> $target"
      return
    fi
    rm "$link"
    ln -s "$target" "$link"
    echo "  relinked: $link -> $target"
  elif [ -f "$link" ]; then
    mv "$link" "${link}.bak"
    ln -s "$target" "$link"
    echo "  backed up and linked: $link -> $target"
  else
    ln -s "$target" "$link"
    echo "  created: $link -> $target"
  fi
}

echo "Symlinks:"
create_symlink "$AGENTS_DIR/AGENTS.md" "$HOME/.claude/CLAUDE.md"
create_symlink "$AGENTS_DIR/AGENTS.md" "$HOME/.codex/instructions.md"
create_symlink "$AGENTS_DIR/AGENTS.md" "$HOME/.gemini/GEMINI.md"

echo ""
echo "Cowork:"
echo "  ~/Documents/Claude/CLAUDE.md is the Cowork entry point."
echo "  It requests ~/.agents/ at session start. Update it manually if needed."
echo ""
echo "Cursor:"
echo "  Uses per-project .cursor/rules/*.mdc — no global setup needed."
echo "  Run bin/new-project.sh to scaffold Cursor rules for a project."
echo ""
echo "Done."
