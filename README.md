# Agent Configuration

Shared agent configuration for Cursor and Claude Code across projects.

## Structure

```
cursor-config/
  template/              # Copy into new projects
    .cursor/rules/
      web-frontend.mdc   # Semantic HTML, vanilla CSS, a11y, design tokens
      javascript.mdc     # JS/Node.js standards
      markdown.mdc       # Markdown formatting rules
      content.mdc        # Content authoring guidelines
      testing.mdc        # Testing philosophy and requirements
      memory.mdc         # Empty shared memory scaffold
    CLAUDE.md            # Template with @imports pre-wired
  global/                # Content for global tool configs
    user-rules-universal.md    # Cursor User Rules (Settings → Rules)
    user-rules-cleanup.md      # Tracks what moved from User to Project rules
    claude-code-global.md      # Reference for ~/.claude/CLAUDE.md
```

## How the layers work

Both tools support layered configuration: global rules that apply everywhere, plus project rules that apply to a specific project.

### Cursor

1. **User Rules** (all projects): Paste `global/user-rules-universal.md` into Cursor Settings → Rules → User Rules. Contains core protocol, communication style, coding standards.
2. **Project Rules** (per-project): `.cursor/rules/*.mdc` files. Each has `alwaysApply: true` to load automatically.

### Claude Code

1. **Global** (all projects): `~/.claude/CLAUDE.md`. Contains the same core protocol as Cursor User Rules.
2. **Project** (per-project): `CLAUDE.md` in the project root. Uses `@` imports to pull in `.cursor/rules/*.mdc` and project docs.
3. **Memory**: `~/.claude/projects/.../memory/MEMORY.md` — a pointer that imports `.cursor/rules/memory.mdc`.

### Shared memory

`.cursor/rules/memory.mdc` is the single source of truth for cross-session learnings. Both Cursor and Claude Code read and write to it. Claude Code's `MEMORY.md` imports it via `@` reference to avoid duplication.

## Starting a new project

```bash
/Users/jonplummer/Projects/cursor-config/new-project.sh /path/to/your/project
```

The script copies template files into your project, skipping any that already exist. It then tells you what to customize:

1. Edit `CLAUDE.md` — update project name, description, and key principles
2. Add project-specific rules to `.cursor/rules/` as needed (e.g., `eleventy.mdc` for 11ty projects)
3. Add `@` imports to `CLAUDE.md` for any project docs
4. On first Claude Code session, set `MEMORY.md` to point to the shared memory file (the script prints the exact content)

## Updating global rules

- **Cursor User Rules**: Update in Cursor Settings → Rules, then update `global/user-rules-universal.md` to match
- **Claude Code global**: Update `~/.claude/CLAUDE.md`, then update `global/claude-code-global.md` to match
- **Template rules**: Update in `template/.cursor/rules/`, then copy to active projects as needed
