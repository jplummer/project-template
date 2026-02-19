# Agent Configuration

Unified agent rules for Cursor, Claude Code, Codex, and Gemini. One source of truth, shared via symlinks.

## Structure

```
cursor-config/
  AGENTS.md                  # Global agent rules (source of truth)
  bin/
    setup-global.sh          # Set up ~/.agents/ and symlinks to all tools
    new-project.sh           # Scaffold agent config into a new project
  template/                  # Project-level template files
    AGENTS.md                # Project rules template (name, principles, @imports)
    .agents/rules/           # Domain-specific rules (canonical location)
      web-frontend.mdc       # Semantic HTML, vanilla CSS, a11y, design tokens
      javascript.mdc         # JS/Node.js standards
      markdown.mdc           # Markdown formatting rules
      content.mdc            # Content authoring guidelines
      testing.mdc            # Testing philosophy and requirements
      memory.mdc             # Cross-session agent memory scaffold
  reference/                 # Research material (gitignored)
```

In each project, `.cursor/rules` is a symlink to `../.agents/rules`, so Cursor reads the same files without duplication.

## How it works

### Global rules (all projects, all tools)

`AGENTS.md` at the repo root contains the core protocol: behavioral rules, communication style, code standards. It gets deployed to every AI tool via `bin/setup-global.sh`.

The setup script:

1. Copies `AGENTS.md` to `~/.agents/AGENTS.md`
2. Symlinks tool-specific files to it:
   - `~/.claude/CLAUDE.md` -> `~/.agents/AGENTS.md`
   - `~/.codex/instructions.md` -> `~/.agents/AGENTS.md`
   - `~/.gemini/GEMINI.md` -> `~/.agents/AGENTS.md`
3. Copies content to clipboard for Cursor User Rules (manual paste required — Cursor has no file-based global config)

```bash
./bin/setup-global.sh
```

Run this whenever you edit `AGENTS.md`.

### Project rules (per-project)

Each project gets its own `AGENTS.md` (from the template) plus `.agents/rules/*.mdc` files for domain-specific rules. Cursor reads the `.mdc` files via a `.cursor/rules` symlink that points to `.agents/rules`. Claude Code reads `AGENTS.md` natively, which `@`-imports the same `.mdc` files.

```bash
./bin/new-project.sh /path/to/your/project
```

The script:
1. Copies `template/AGENTS.md` and `.agents/rules/*.mdc` into the project (skips existing)
2. Creates `CLAUDE.md` as a symlink to `AGENTS.md`
3. Creates `.cursor/rules` as a symlink to `../.agents/rules`

Then customize:
1. Edit `AGENTS.md` — update project name, description, key principles
2. Add project-specific rules to `.agents/rules/` as needed
3. Add `@` imports to `AGENTS.md` for project docs

### Shared memory

`.agents/rules/memory.mdc` is the cross-session memory file. Both Cursor and Claude Code read and write to it. Keep entries concise; remove anything outdated.

## Updating rules

1. Edit `AGENTS.md` in this repo
2. Run `bin/setup-global.sh` to deploy globally
3. Paste into Cursor User Rules when prompted
4. For project-level template changes, edit files in `template/` and re-run `bin/new-project.sh` on active projects
