# Contributing

## Project Layout

- `commands/*.md` — Command specs with frontmatter (Goal, Context, Plan, Execution, Now do it).
- `.claude-plugin/plugin.json` — Plugin metadata (name `flow`).
- `.claude-plugin/marketplace.json` — Marketplace bundle (`dev-flow-tools`).
- `AGENTS.md` — Contributor guidelines for this repo.

## Tooling

| Tool                                              | Purpose                                                      | Install                                                            |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------ |
| [just](https://github.com/casey/just)             | Task runner for linting, formatting, and automation recipes. | `brew install just` or follow project docs.                        |
| [Bun](https://bun.sh/)                            | Provides `bunx` to run Biome, Prettier, and other tooling.   | Follow the [installation guide](https://bun.sh/docs/installation). |
| [actionlint](https://github.com/rhysd/actionlint) | Lints GitHub Actions workflows via `just lint`.              | `brew install actionlint` or download a release binary.            |

## Tasks

- `just install` — Print in-app install steps.
- `just fix` — Format `*.md` and Justfile via Prettier.
- `just lint` — Lint JSON, Markdown, and GitHub Actions workflows.

See the complete list with `just`.

## Writing commands

- Avoid destructive actions in commands; prefer read-only defaults and explicit confirmation.
