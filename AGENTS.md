# Repository Guidelines

## Project Structure & Module Organization

- `commands/*.md` — Claude Code command definitions with YAML frontmatter (e.g., `description`, `argument-hint`, `allowed-tools`). Examples: `commands/ci.md`, `commands/commit.md`, `commands/push.md`.
- `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` — plugin and marketplace metadata.
- `Justfile` — dev tasks. See commands below.
- `README.md` — install, usage, and repo overview.

## Build, Test, and Development Commands

- No build step; this repo ships Markdown + JSON metadata.
- `just fix` — format repo (Justfile and `*.md`) via Prettier.
- `just lint` — check formatting only.
- Manual verify in Claude Code:
  - Add marketplace: `/plugin marketplace add ./`
  - Install: `/plugin install flow@dev-flow-tools`
  - Confirm with `/help`, then try `/flow:ci`, `/flow:commit`, `/flow:push` in a git repo.

## Coding Style & Naming Conventions

- Markdown: use ATX headings (`#`, `##`), short sentences, and fenced code blocks for commands.
- Filenames: lowercase, kebab-case where needed; extension `.md` (e.g., `new-command.md`).
- Frontmatter order: `description`, `argument-hint`, `allowed-tools` (match existing files).
- JSON: 2-space indent, trailing newline. Run `just fix` to format.

## Testing Guidelines

- Lint: `just lint` must pass.
- Smoke-test commands inside Claude Code as above; ensure frontmatter parses and the command renders.
- Commands should be non-destructive by default; prefer read-only tooling and explicit user confirmation for side effects (e.g., pushing).

## Commit & Pull Request Guidelines

- Use conventional commits with emoji. Examples:
  - `✨ feat: add <feature>`
  - `🐛 fix: resolve <issue>`
  - `📝 docs: update <area>`
- Keep commits atomic; update `README` and plugin metadata when adding or renaming commands.
- PRs: include a clear summary, linked issues, screenshots or CLI transcripts when useful, and note any behavioral changes. Ensure `just lint` passes.

## Security & Configuration Tips

- Never commit tokens, secrets, or personal paths. Do not widen `.claude/settings.local.json` permissions.
- The `/flow:ci` workflow relies on `gh` locally; document prerequisites but do not embed credentials.

## Agent-Specific Instructions

- Keep changes minimal and focused; avoid unrelated refactors.
- When adding a command, mirror the structure in existing files: Goal, Context, Plan, Execution details, Now do it.
- Run `just fix` before submitting.
