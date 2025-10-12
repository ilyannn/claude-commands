#!/usr/bin/env -S just --justfile
# All recipes use 4-space indentation and execute in their own shell; keep commands
# self-contained or add a bash shebang when state must persist across lines.

MARKDOWN_GLOBS := "*.md commands/*.md"
PRETTIER_TARGETS := MARKDOWN_GLOBS

@help:
    @just --list --unsorted --list-prefix ' · '

# Format repository files (Justfile + Markdown + JSON)
fmt:
    just --fmt --unstable
    bunx --bun @biomejs/biome format --write
    bunx --bun prettier --write {{ PRETTIER_TARGETS }}

# Check formatting only
check-fmt:
    just --fmt --check --unstable
    bunx --bun @biomejs/biome format
    bunx --bun prettier --check {{ PRETTIER_TARGETS }}

# Lint JSON, Markdown, and GitHub Actions workflows
lint:
    bunx --bun @biomejs/biome lint
    bunx --bun markdownlint-cli2 {{ MARKDOWN_GLOBS }}
    actionlint -color

# Fix lint issues
fix-lint:
    bunx --bun @biomejs/biome lint --write
    bunx --bun markdownlint-cli2 --fix {{ MARKDOWN_GLOBS }}

# Run all checks
check: check-fmt lint
    @echo "All checks passed."

# Fix as many issues as possible
fix: fix-lint fmt

# Git hooks
pre-commit: check

# Installation instructions
install:
    @echo "Inside Claude Code, run from this folder:"
    @echo "  /plugin marketplace add ./"
    @echo "  /plugin install flow@dev-flow-tools"
    @echo "Then restart Claude Code and type /flow: to confirm."
