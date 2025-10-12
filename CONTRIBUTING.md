# Contributing

## Project Layout

- `commands/*.md` — Command specs with frontmatter (Goal, Context, Plan, Execution, Now do it).
- `.claude-plugin/plugin.json` — Plugin metadata (name `flow`).
- `.claude-plugin/marketplace.json` — Marketplace bundle (`dev-flow-tools`).
- `AGENTS.md` — Contributor guidelines for this repo.

## Tasks

Requires Bun for `bunx`.

- `just install` — Print in-app install steps.
- `just fix` — Format `*.md` and Justfile via Prettier.
- `just lint` — Lint JSON, Markdown, and GitHub Actions workflows.

## Notes

- `/flow:ci` relies on the GitHub CLI; run `gh auth login` before use.
- Install [`actionlint`](https://github.com/rhysd/actionlint) locally (for example, `brew install actionlint`) so `just lint` succeeds.
- Avoid destructive actions in commands; prefer read-only defaults and explicit confirmation.
