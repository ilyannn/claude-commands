---
description: Review the pre-commit issues and create the commit
argument-hint: [topic]
allowed-tools: Bash(git:*)
---

# Claude Command: Commit

This command helps you create well-formatted commits with conventional commit messages and emoji.

## Usage

To review the pre-commit issues and create a commit, just type:

```
/commit
```

Or with hinting about a specific topic:

```
/commit VoiceSelector refactor
```

## Context

- Current git status: !`git status --short || true`
- Current git diff (staged and unstaged changes): !`git diff HEAD || true`
- Current branch: !`git branch --show-current || true`
- Latest commits: !`git log --oneline -20 || true`
- Pre-commit hook results from git: !`git hook run pre-commit || true`
- User-provided topic (can be empty): $ARGUMENTS

## What This Command Does

**Note:** This is a custom command. When being executed, Claude will see a "/commit is running" message indicating the command is being processed and your thinking should proceed as below.

0. If this is not a git repository, initiate one with `git init` and use `main` branch as default.
1. Check which files are staged from `git status` output; if none are staged, automatically add all modified and new files with `git add`.
2. Performs a `git diff` to understand what changes are being committed
3. Analyzes the diff to determine if multiple distinct logical changes are present
4. If multiple distinct changes are detected, break the commit into multiple smaller commits
5. For each commit (or the single commit if not split), create a commit message using emoji conventional commit format
6. Analyze the pre-commit hook output; if there are formatting issues, try to fix them with project-standard formatting tools, often `just format`.
7. For other issues, like linting or test failures, try to fix them yourself.
8. Run the git hook again after any changes.
9. If there are complex issues that are hard to fix then ask the user how to proceed: fix the issues, commit with `--no-verify` or continue other work.

## Best Practices for Commits

- **Verify before committing**: Ensure code is linted, builds correctly, and documentation is updated
- **Atomic commits**: Each commit should contain related changes that serve a single purpose
- **Split large changes**: If changes touch multiple concerns, split them into separate commits
- **Conventional commit format**: Use the format `<type>: <description>` where type is one of:
  - `feat`: A new feature
  - `fix`: A bug fix
  - `docs`: Documentation changes
  - `style`: Code style changes (formatting, etc)
  - `refactor`: Code changes that neither fix bugs nor add features
  - `perf`: Performance improvements
  - `test`: Adding or fixing tests
  - `chore`: Changes to the build process, tools, etc.
- **Present tense, imperative mood**: Write commit messages as commands (e.g., "add feature" not "added feature")
- **Concise first line**: Keep the first line under 72 characters
- **Only most important details**: make it clear what the commit touches (e.g. auth flow or /payments endpoint) but clarify the specifics only on a very high level, use brackets if helpful
- **Emoji**: Each commit type is paired with an appropriate emoji:
  - ✨ `feat`: New feature
  - 🐛 `fix`: Bug fix
  - 📝 `docs`: Documentation
  - 💄 `style`: Formatting/style
  - ♻️ `refactor`: Code refactoring
  - ⚡️ `perf`: Performance improvements
  - ✅ `test`: Tests
  - 🔧 `chore`: Tooling, configuration
  - 🚀 `ci`: CI/CD improvements
  - 🗑️ `revert`: Reverting changes
  - 🚨 `fix`: Fix compiler/linter warnings
  - 🔒️ `fix`: Fix security issues
  - 👥 `chore`: Add or update contributors
  - 🚚 `refactor`: Move or rename resources
  - 🏗️ `refactor`: Make architectural changes
  - 🔀 `chore`: Merge branches
  - 📦️ `chore`: Add or update compiled files or packages
  - ➕ `chore`: Add a dependency
  - ➖ `chore`: Remove a dependency
  - 🌱 `chore`: Add or update seed files
  - 🧑‍💻 `chore`: Improve developer experience
  - 🧵 `feat`: Add or update code related to multithreading or concurrency
  - 🔍️ `feat`: Improve SEO
  - 🏷️ `feat`: Add or update types
  - 💬 `feat`: Add or update text and literals
  - 🌐 `feat`: Internationalization and localization
  - 👔 `feat`: Add or update business logic
  - 📱 `feat`: Work on responsive design
  - 🚸 `feat`: Improve user experience / usability
  - 🩹 `fix`: Simple fix for a non-critical issue
  - 🥅 `fix`: Catch errors
  - 👽️ `fix`: Update code due to external API changes
  - 🔥 `fix`: Remove code or files
  - 🎨 `style`: Improve structure/format of the code
  - 🚑️ `fix`: Critical hotfix
  - 🎉 `chore`: Begin a project
  - 🔖 `chore`: Release/Version tags
  - 🚧 `wip`: Work in progress
  - 💚 `fix`: Fix CI build
  - 📌 `chore`: Pin dependencies to specific versions
  - 👷 `ci`: Add or update CI build system
  - 📈 `feat`: Add or update analytics or tracking code
  - ✏️ `fix`: Fix typos
  - ⏪️ `revert`: Revert changes
  - 📄 `chore`: Add or update license
  - 💥 `feat`: Introduce breaking changes
  - 🍱 `assets`: Add or update assets
  - ♿️ `feat`: Improve accessibility
  - 💡 `docs`: Add or update comments in source code
  - 🗃️ `db`: Perform database related changes
  - 🔊 `feat`: Add or update logs
  - 🔇 `fix`: Remove logs
  - 🤡 `test`: Mock things
  - 🥚 `feat`: Add or update an easter egg
  - 🙈 `chore`: Add or update .gitignore file
  - 📸 `test`: Add or update snapshots
  - ⚗️ `experiment`: Perform experiments
  - 🚩 `feat`: Add, update, or remove feature flags
  - 💫 `ui`: Add or update animations and transitions
  - ⚰️ `refactor`: Remove dead code
  - 🦺 `feat`: Add or update code related to validation
  - ✈️ `feat`: Improve offline support

## Guidelines for Splitting Commits

When analyzing the diff, consider splitting commits based on these criteria:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types of changes**: Mixing features, fixes, refactoring, etc.
3. **File patterns**: Changes to different types of files (e.g., source code vs documentation)
4. **Logical grouping**: Changes that would be easier to understand or review separately
5. **Size**: Very large changes that would be clearer if broken down

If unclear, ask the user how to proceed.

## Examples

Good commit messages:

- ✨ feat: add user authentication system
- 🐛 fix: resolve memory leak in rendering process
- 📝 docs: update API documentation with /user/... endpoints
- ♻️ refactor: simplify error handling logic in VoiceSelector
- 🚨 fix: resolve linter warnings in component files
- 🧑‍💻 chore: use just for developer tooling
- 👔 feat: implement business logic for transaction validation
- 🩹 fix: address minor styling inconsistency in header
- 🚑️ fix: patch critical security vulnerability in auth flow
- 🎨 style: reorganize VoiceSelector component for better readability
- 🔥 fix: remove deprecated legacy code in /v1/payment
- 🦺 feat: add input validation for user registration form
- 💚 fix: failing CI pipeline tests (CSS linting settings mismatch)
- 📈 feat: implement analytics tracking for user engagement
- 🔒️ fix: strengthen authentication password requirements (16 chars)
- ♿️ feat: improve login form accessibility for screen readers

Example of splitting commits:

- First commit: ✨ feat: add new solc version type definitions
- Second commit: 📝 docs: update documentation for new solc versions
- Third commit: 🔧 chore: update package.json dependencies
- Fourth commit: 🏷️ feat: add type definitions for /user endpoints
- Fifth commit: 🧵 feat: improve concurrency handling in worker threads
- Sixth commit: 🚨 fix: resolve linting issues in new solc code
- Seventh commit: ✅ test: add unit tests for new solc version features
- Eighth commit: 🔒️ fix: update dependencies with security vulnerabilities

## Important Notes

‼️ If no git repository exists, the command will initialize one with `main` as the default branch.
‼️ If specific files are already staged, the command will only commit those files.
‼️ If no files are staged, it will automatically stage all modified and new files.
‼️ The commit message will be constructed based on the changes detected, but using user-provided hints
‼️ Before committing, the command will review the diff to identify if multiple commits would be more appropriate.
‼️ If suggesting multiple commits, it will help you stage and commit the changes separately.
‼️ Always reviews the commit diff to ensure the message matches the changes.
‼️ This command can commit with --no-verify but ONLY if the user explicitly agreed to it when asked.
