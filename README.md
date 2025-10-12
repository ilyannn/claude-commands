# Flow (Claude Code Plugin)

Namespaced Flow commands for conventional commits, safe pushes, and CI triage in Claude Code.

## Commands

- `/flow:commit` — Create emoji conventional commits with intelligent splitting and lint checks (`/flow:commit [topic]`).
- `/flow:push` — Guard pushes by reviewing unpushed commits for risky content (`/flow:push`).
- `/flow:ci` — Summarize GitHub Actions runs and analyze failures (`/flow:ci [workflow=<file|id>|all]`).

## Installation

1. Add the marketplace (ships in `.claude-plugin/marketplace.json`):
   - Local path: `/plugin marketplace add ./` from this repo, or
   - GitHub repo: `/plugin marketplace add ilyannn/claude-commands`
2. Install the plugin: `/plugin install flow@dev-flow-tools`
3. Restart Claude Code and start typing `/flow:` to confirm the commands are available.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for project layout, tasks, and contributor notes.
