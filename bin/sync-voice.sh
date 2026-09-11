#!/usr/bin/env bash
# Generates a project-local Cursor rule from the global writing rules.
# Usage: ./sync-voice.sh /path/to/project
#
# Cursor has no global rules file and can't @-import from outside the
# project, so it needs a copy. This makes that copy a build product with
# one source (~/.agents/writing-rules.md) rather than a hand-maintained
# duplicate. Always overwrites – never edit the generated file.
#
# Writes to .agents/rules/voice.mdc when the project has .agents/rules/,
# otherwise to .cursor/rules/voice.mdc (projects not yet on the symlink
# layout). Claude Code already gets writing-rules.md through
# ~/.claude/CLAUDE.md, so don't @-import voice.mdc from the project's
# AGENTS.md or CLAUDE.md – it would load twice.

set -e

SOURCE="${AGENTS_DIR:-$HOME/.agents}/writing-rules.md"

if [ -z "$1" ]; then
  echo "Usage: ./sync-voice.sh /path/to/project"
  exit 1
fi

TARGET="$1"

if [ ! -d "$TARGET" ]; then
  echo "Error: $TARGET is not a directory"
  exit 1
fi

if [ ! -f "$SOURCE" ]; then
  echo "Error: $SOURCE not found"
  exit 1
fi

if [ -d "$TARGET/.agents/rules" ]; then
  DEST="$TARGET/.agents/rules/voice.mdc"
elif [ -d "$TARGET/.cursor/rules" ] && [ ! -L "$TARGET/.cursor/rules" ]; then
  DEST="$TARGET/.cursor/rules/voice.mdc"
else
  mkdir -p "$TARGET/.agents/rules"
  DEST="$TARGET/.agents/rules/voice.mdc"
fi

{
  cat <<'HEADER'
---
description: Writing voice and rules – generated from ~/.agents/writing-rules.md, do not edit
globs: ['**/*.md']
alwaysApply: true
---

<!-- GENERATED FILE. Source: ~/.agents/writing-rules.md (dotagents repo).
     Regenerate with: ~/Projects/project-template/bin/sync-voice.sh <project>
     Edits here are lost on the next sync. Edit the source instead. -->

HEADER
  cat "$SOURCE"
} > "$DEST"

echo "  wrote: ${DEST#$TARGET/} ($(wc -c < "$DEST" | tr -d ' ') bytes, from $SOURCE)"
