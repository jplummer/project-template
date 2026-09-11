# project-template

Scaffolding for per-project AI agent configuration. Global rules live elsewhere — in the [dotagents](https://github.com/jplummer/dotagents) repo at `~/.agents/`. This repo handles the per-project piece.

## Structure

```
project-template/
  AGENTS.md                  # Thin pointer — explains what this repo is for
  bin/
    setup-global.sh          # Clone/pull dotagents, create the per-tool entry points
    new-project.sh           # Scaffold agent config into a new project
    sync-voice.sh            # Generate a project's voice.mdc from ~/.agents/writing-rules.md
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
        memory.mdc           # Short pointer to docs/agent-memory.md
    docs/
      agent-memory.md        # Where agents append learnings (read on demand, not every session)
```

Generated per project, not in the template: `.agents/rules/voice.mdc`, a copy of `~/.agents/writing-rules.md` with Cursor frontmatter. `bin/sync-voice.sh` writes it; `new-project.sh` calls that as its last step.

In each project:
- `.cursor/rules` symlinks to `../.agents/rules` — Cursor reads the same rule files without duplication
- `.claude/commands` symlinks to `../.agents/commands` — Claude Code picks them up as `/slash` commands

## How it works

### Global rules

Global rules — behavioral protocol, writing style, code standards, personal context — live in `~/.agents/` (the `dotagents` repo). Each tool reaches them through a thin entry point. This table is the one place the wiring is written down; the dotagents README links here.

| Tool | Entry point | Created by |
|------|-------------|------------|
| Claude Code CLI, Claude desktop app | `~/.claude/CLAUDE.md` → symlink to `~/.agents/AGENTS.md` | `setup-global.sh` |
| Codex CLI | `~/.codex/instructions.md` → same symlink | `setup-global.sh` |
| Gemini CLI | `~/.gemini/GEMINI.md` → same symlink | `setup-global.sh` |
| Cowork | `~/Documents/Claude/CLAUDE.md` — asks for `~/.agents/` at session start, then defers to `AGENTS.md` | `setup-global.sh` (written if missing) |
| Cursor | a User Rule (Cursor Settings → Rules → User) holding only the pointer text below; plus per-project `.agents/rules/voice.mdc`, which puts the writing rules in context deterministically – the pointer depends on the agent choosing to read the file | by hand (User Rules live in Cursor's settings database, not a file); `sync-voice.sh` for `voice.mdc` |

None of the entry points list rule files. `~/.agents/AGENTS.md` has the only list (its Reference Files section), so a new global file is added there and nowhere else.

The Cursor User Rule, verbatim (verified 2026-09-11: the agent reads the file unprompted at session start):

```
Before doing anything else in a session, read ~/.agents/AGENTS.md and follow its Reference Files section – load each file it lists, at the times it says to. If the file-read tool refuses a path outside the workspace, run `cat ~/.agents/AGENTS.md` in the terminal instead. These are Jon's global rules; the project's own rules load separately.
```

To set up global config on a new machine:

```bash
./bin/setup-global.sh
```

This clones `dotagents` into `~/.agents/` (or pulls if it already exists), creates the symlinks above, and writes the Cowork pointer if it isn't there.

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
5. Runs `sync-voice.sh` to generate `.agents/rules/voice.mdc`

Then customize:
1. Edit `AGENTS.md` — fill in project name, description, key principles. Keep it project-specific; don't duplicate global rules.
2. Add `@` imports for project docs worth loading by default
3. Trim `.agents/rules/` to match the project's tech stack — but leave `voice.mdc` alone; it's generated

### Commands

`.agents/commands/` contains reusable agent workflows. Claude Code exposes these as slash commands (e.g. `/COMMIT`, `/FIX`) via the `.claude/commands` symlink.

- **COMMIT** — reviews changes, drafts a commit message, waits for confirmation before committing
- **FIX** — systematic debugging: reproduce, hypothesize, isolate, fix, verify

To add a command: create a `.md` file in `template/.agents/commands/` and re-run `bin/new-project.sh` on active projects.

## Updating global rules

Edit files in `~/.agents/` directly (it's a git repo). Changes take effect immediately for Claude Code, Codex, Gemini, and Cowork. Cursor only sees the generated copy, so after editing `writing-rules.md` re-run `bin/sync-voice.sh` on each project that has a `voice.mdc`. See the [dotagents README](https://github.com/jplummer/dotagents) for the full maintenance guide.

## Updating project template

Edit files in `template/` and re-run `bin/new-project.sh` on active projects (it skips existing files, so only new additions propagate; `voice.mdc` is regenerated every time).

To move an older project onto this layout — one where `.cursor/rules/` and `.claude/commands/` are real directories — move them into `.agents/` and symlink back:

```bash
mkdir -p .agents
mv .cursor/rules .agents/rules
mv .claude/commands .agents/commands
ln -s ../.agents/rules .cursor/rules
ln -s ../.agents/commands .claude/commands
```

Then repoint any `@.cursor/rules/...` imports in `AGENTS.md` or `CLAUDE.md` to `@.agents/rules/...` and run `bin/sync-voice.sh` on it.
