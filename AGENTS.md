# project-template

Scaffolding for per-project agent configuration. Run `bin/new-project.sh /path/to/project` when starting something new, then fill in the project-specific sections of the `AGENTS.md` it creates. See `README.md` for how the pieces fit.

## Global agent rules

Global rules (protocol, writing, code style, persona) live in a separate repo and are not duplicated here:
https://github.com/jplummer/dotagents

Each tool loads them from `~/.agents/` at session start. A project's `AGENTS.md` should contain only project-specific context.
