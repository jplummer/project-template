#!/usr/bin/env bash
# Sets up global agent configuration from the dotagents repo.
# Clones ~/.agents/ if not present; pulls latest if it is.
# Creates OS-level symlinks for Claude Code, Codex, and Gemini CLI, and
# writes the Cowork pointer file if it doesn't exist.
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
COWORK_ENTRY="$HOME/Documents/Claude/CLAUDE.md"
if [ -f "$COWORK_ENTRY" ]; then
  echo "  exists: $COWORK_ENTRY (left alone — compare against the block in this script if in doubt)"
else
  mkdir -p "$(dirname "$COWORK_ENTRY")"
  cat > "$COWORK_ENTRY" <<'EOF'
# Cowork – global entry point

At the start of every session:

1. Request the folder `~/.agents/` (use `device_request_folder_access`) if it isn't already connected.
2. Read `~/.agents/AGENTS.md` and load the files its Reference Files section lists, at the times it says to.

This file deliberately lists nothing else. `AGENTS.md` is the only place the global rule files are enumerated, so adding a file there is enough.

Full picture: `~/.agents/README.md` or https://github.com/jplummer/dotagents
EOF
  echo "  created: $COWORK_ENTRY"
fi
echo ""
echo "Cursor:"
echo "  Global rules arrive through a User Rule (Cursor Settings > Rules > User)."
echo "  It can't be scripted — paste the pointer text from README.md, 'Global rules'."
echo "  Then run bin/new-project.sh on a new project, or bin/sync-voice.sh on an"
echo "  existing one, to generate its voice.mdc."
echo ""
echo "Done."
