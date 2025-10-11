# Commands (Claude Code Plugin)

Slash commands for CI triage, conventional commits, and safe pushes in Claude Code.

## Commands

- `/ci` — Inspect GitHub Actions runs and analyze failures (`/ci [workflow=<file|id>|all]`).
- `/commit` — Create emoji conventional commits with lint checks (`/commit [topic]`).
- `/push` — Review unpushed commits for risky content (`/push`).

## Installation

1. Add the marketplace (ships in `.claude-plugin/marketplace.json`):
   - Local path: `/plugin marketplace add ./path/to/claude-commands`
   - GitHub repo: `/plugin marketplace add owner/claude-commands`
2. Install the plugin: `/plugin install commands@dev-workflow-tools`
3. Restart Claude Code and run `/help` to confirm the commands are available.

Quick check: in a git repo, try `/ci`, `/commit`, and `/push`.

## Development

Project layout

- `commands/*.md` — Command specs with frontmatter (Goal, Context, Plan, Execution, Now do it).
- `.claude-plugin/plugin.json` — Plugin metadata (name `commands`).
- `.claude-plugin/marketplace.json` — Marketplace bundle (`dev-workflow-tools`).
- `AGENTS.md` — Contributor guidelines for this repo.

Tasks (requires Bun for `bunx`)

- `just install` — Print in-app install steps.
- `just fix` — Format `*.md` and Justfile via Prettier.
- `just lint` — Check formatting.

Notes

- `/ci` relies on the GitHub CLI; run `gh auth login` before use.
- Avoid destructive actions in commands; prefer read-only defaults and explicit confirmation.
