help:
    @just --list --unsorted --list-prefix '  ·'

# Format repository files (Justfile + Markdown + JSON)
fmt:
    just --fmt --unstable
    bunx prettier -w AGENTS.md README.md "commands/*.md" \
        ".claude-plugin/*.json"

alias fix := fmt

# Check formatting only
lint:
    just --fmt --check --unstable
    bunx prettier --check AGENTS.md README.md "commands/*.md" \
        ".claude-plugin/*.json"

alias check := lint

# Git hooks
pre-commit: lint

# Local installation instructions for Claude Code
install:
    @echo "Inside Claude Code, run:"
    @echo "  /plugin marketplace add ./"
    @echo "  /plugin install flow@dev-flow-tools"
    @echo "Then restart Claude Code and run /help to confirm."
