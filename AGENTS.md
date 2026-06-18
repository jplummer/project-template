# project-template

Starter template for new projects. Copy `template/AGENTS.md` into your project root when starting something new, then fill in the project-specific sections.

## Global agent rules

Global rules (protocol, writing, code style, persona) live in a separate repo and are not duplicated here:
https://github.com/jplummer/dotagents

Each tool loads them from `~/.agents/` at session start. Your project AGENTS.md should contain only project-specific context.

## Reference

`reference/agent-rules/` contains an older versioned snapshot of global rules (pre-dotagents). It is no longer maintained Ñ use dotagents instead.
