#!/usr/bin/env bash
# Sets up OS-level agent configuration.
# Creates ~/.agents/ with AGENTS.md and symlinks for Claude Code, Codex, and Gemini.
# Cursor User Rules require manual paste (no file-based config available).

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SOURCE="$REPO_DIR/AGENTS.md"

AGENTS_DIR="$HOME/.agents"
AGENTS_FILE="$AGENTS_DIR/AGENTS.md"

if [ ! -f "$SOURCE" ]; then
  echo "Error: $SOURCE not found."
  exit 1
fi

echo "Setting up global agent configuration..."
echo ""

# --- Create ~/.agents/ and copy AGENTS.md ---

mkdir -p "$AGENTS_DIR"

if [ -f "$AGENTS_FILE" ]; then
  if diff -q "$SOURCE" "$AGENTS_FILE" > /dev/null 2>&1; then
    echo "  unchanged: $AGENTS_FILE"
  else
    cp "$SOURCE" "$AGENTS_FILE"
    echo "  updated: $AGENTS_FILE"
  fi
else
  cp "$SOURCE" "$AGENTS_FILE"
  echo "  created: $AGENTS_FILE"
fi

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
    echo "  backed up and linked: $link -> $target (original at ${link}.bak)"
  else
    ln -s "$target" "$link"
    echo "  created: $link -> $target"
  fi
}

echo ""
echo "Symlinks:"
create_symlink "$AGENTS_FILE" "$HOME/.claude/CLAUDE.md"
create_symlink "$AGENTS_FILE" "$HOME/.codex/instructions.md"
create_symlink "$AGENTS_FILE" "$HOME/.gemini/GEMINI.md"

# --- Cursor reminder ---

echo ""
echo "Cursor User Rules:"
if command -v pbcopy > /dev/null 2>&1; then
  cat "$AGENTS_FILE" | pbcopy
  echo "  Copied AGENTS.md content to clipboard."
  echo "  Paste into: Cursor Settings > General > Rules for AI"
else
  echo "  Manually copy the contents of $AGENTS_FILE"
  echo "  into: Cursor Settings > General > Rules for AI"
fi

echo ""
echo "Done."
