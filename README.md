# project-template

Scaffolding for per-project AI agent configuration. Global rules live elsewhere — in the [dotagents](https://github.com/jplummer/dotagents) repo at `~/.agents/`. This repo handles the per-project piece.

## Structure

```
project-template/
  AGENTS.md                  # Thin pointer — explains what this repo is for
  bin/
    setup-global.sh          # Clone/pull dotagents and create OS-level symlinks
    new-project.sh           # Scaffold agent config into a new project
  template/                  # Per-project template files
    AGENTS.md                # Project rules template (name, principles, @imports)
    .agents/
      commands/              # Agent commands (slash commands for Claude Code)
        COMMIT.md            # Structured commit workflow
        FIX.md               # Systematic debugging workflow
      rules/                 # Domain-specific rules
        web-frontend.mdc     # Semantic HTML, vanilla CSS, a11y, design tokens
        javascript.mdc       # JS/Node.js standards
        markdown.mdc         # Markdown formatting rules
        content.mdc          # Content authoring guidelines
        testing.mdc          # Testing philosophy and requirements
        memory.mdc           # Cross-session memory scaffold
```

In each project:
- `.cursor/rules` symlinks to `../.agents/rules` — Cursor reads the same rule files without duplication
- `.claude/commands` symlinks to `../.agents/commands` — Claude Code picks them up as `/slash` commands

## How it works

### Global rules

Global rules — behavioral protocol, writing style, code standards, personal context — live in `~/.agents/` (the `dotagents` repo). Each AI tool loads them via its own entry point:

| Tool | Entry point |
|------|-------------|
| Claude Code CLI | `~/.claude/CLAUDE.md` → symlink to `~/.agents/AGENTS.md` |
| Claude desktop app | same symlink |
| Cowork | `~/Documents/Claude/CLAUDE.md` — requests `~/.agents/` at session start |
| Cursor | per-project `.cursor/rules/*.mdc` — no global file |

To set up global config on a new machine:

```bash
./bin/setup-global.sh
```

This clones `dotagents` into `~/.agents/` (or pulls if it already exists) and creates the OS-level symlinks above.

### Project rules

Each project gets its own `AGENTS.md` with project-specific context only — what the project is, key constraints, links to relevant docs. No global rules; those load automatically from the tool's entry point.

```bash
./bin/new-project.sh /path/to/your/project
```

The script:
1. Copies `template/AGENTS.md`, `.agents/rules/*.mdc`, and `.agents/commands/*.md` into the project (skips existing files)
2. Creates `CLAUDE.md` as a symlink to `AGENTS.md`
3. Creates `.cursor/rules` as a symlink to `../.agents/rules`
4. Creates `.claude/commands` as a symlink to `../.agents/commands`

Then customize:
1. Edit `AGENTS.md` — fill in project name, description, key principles. Keep it project-specific; don't duplicate global rules.
2. Add `@` imports for project docs worth loading by default
3. Trim `.agents/rules/` to match the project's tech stack

### Commands

`.agents/commands/` contains reusable agent workflows. Claude Code exposes these as slash commands (e.g. `/COMMIT`, `/FIX`) via the `.claude/commands` symlink.

- **COMMIT** — reviews changes, drafts a commit message, waits for confirmation before committing
- **FIX** — systematic debugging: reproduce, hypothesize, isolate, fix, verify

To add a command: create a `.md` file in `template/.agents/commands/` and re-run `bin/new-project.sh` on active projects.

## Updating global rules

Edit files in `~/.agents/` directly (it's a git repo). Changes take effect immediately for Claude Code and Cowork. See the [dotagents README](https://github.com/jplummer/dotagents) for the full maintenance guide.

## Updating project template

Edit files in `template/` and re-run `bin/new-project.sh` on active projects (it skips existing files, so only new additions propagate).
