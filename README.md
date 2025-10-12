# Flow (Claude Code Plugin)

Namespaced Flow commands for conventional commits, safe pushes, and CI triage in Claude Code.

## Commands

- `/flow:commit` — Create emoji conventional commits with intelligent splitting and lint checks (`/flow:commit [topic]`).
- `/flow:push` — Guard pushes by reviewing unpushed commits for risky content (`/flow:push`).
- `/flow:ci` — Summarize GitHub Actions runs and analyze failures (`/flow:ci [workflow=<file|id>|all]`).

## Installation

1. Add the marketplace (ships in `.claude-plugin/marketplace.json`):
   - Local path: `/plugin marketplace add ./path/to/claude-commands`
   - GitHub repo: `/plugin marketplace add owner/claude-commands`
2. Install the plugin: `/plugin install flow@dev-flow-tools`
3. Restart Claude Code and run `/help` to confirm the commands are available.

Quick check: in a git repo, try `/flow:commit`, `/flow:push`, and `/flow:ci`.

## Development

Project layout

- `commands/*.md` — Command specs with frontmatter (Goal, Context, Plan, Execution, Now do it).
- `.claude-plugin/plugin.json` — Plugin metadata (name `flow`).
- `.claude-plugin/marketplace.json` — Marketplace bundle (`dev-flow-tools`).
- `AGENTS.md` — Contributor guidelines for this repo.

Tasks (requires Bun for `bunx`)

- `just install` — Print in-app install steps.
- `just fix` — Format `*.md` and Justfile via Prettier.
- `just lint` — Check formatting.

Notes

- `/flow:ci` relies on the GitHub CLI; run `gh auth login` before use.
- Avoid destructive actions in commands; prefer read-only defaults and explicit confirmation.
