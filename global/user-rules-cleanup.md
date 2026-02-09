# User Rules Cleanup Reference

This document tracks what has been moved from User Rules to project-specific `.cursor/rules/` and what should be removed from User Rules.

## Removed from User Rules (Moved to Project Rules)

### ✅ Web Front-End Code Rules
**Moved to:** `.cursor/rules/web-frontend.mdc`

Remove from User Rules:
- "Prefer semantic HTML with as few non-semantic elements as possible"
- "Prefer vanilla CSS with common values pulled out into custom properties"
- "ALWAYS use design tokens (CSS custom properties) if present"
- "Include alt text for all non-decorative images"
- "Consider accessibility, but add ARIA attributes sparingly"
- "Prefer as little JavaScript as possible"
- "Use mobile-first responsive design"
- "Ask me if color contrast seems insufficient"

### ✅ Markdown Formatting Rules
**Moved to:** `.cursor/rules/markdown.mdc`

Remove from User Rules:
- "When proposing an edit to a markdown file, indent any code snippets inside it with two spaces. Indentation levels 0 and 4 are not allowed."
- "If a markdown code block is indented with any value other than 2 spaces, automatically fix it."

### ✅ Content Guidelines
**Moved to:** `.cursor/rules/content.mdc`

Remove from User Rules:
- "Write clear, engaging titles"
- "Use descriptive image filenames"
- "Include meta descriptions for SEO (50-160 characters)"
- "Use proper markdown syntax"
- "Keep paragraphs concise and scannable"

## Keep in User Rules (Universal)

These should remain in User Rules as they apply to all projects:

- Core Protocol (Rule 0, checkpoints, verification)
- Agent Identity & Communication
- Request Interpretation (plan vs discussion vs implement)
- Role Definition
- General Coding Style (2 spaces, const/let, arrow functions, etc.)
- "When writing or planning code" principles
- Rules for comments ("never use powerful/flexible/simple/easy")
- Testing Requirements (if universal principles, not project-specific commands)

## How to Update User Rules

1. Open Cursor Settings → Rules → User Rules
2. Or: Command Palette → "Preferences: Open User Settings (JSON)" and look for `cursor.aiRules`
3. Remove the sections listed above under "Removed from User Rules"
4. Keep everything under "Keep in User Rules"

