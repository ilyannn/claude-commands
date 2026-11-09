---
description: Guard pushes by reviewing commits for risky or sensitive changes
argument-hint:
allowed-tools: Bash, Read, Grep
---

# Goal

Review the commits that are not published to the remote. Check for any information that might leak when pushing.

# Context

- List remotes: !`git remote -v`
- Current branch and its upstream: !`git status --short --branch`
- Commits on the current branch that are on no remote branch yet: !`git log --ignore-missing HEAD --not --remotes`
- Pre-push hook results from git: !`git hook run --ignore-missing pre-push || true`

# Plan

1. **Get changes in the commits**

- If there are no unpushed commits, inform the user showing the current branch and that it was compared with every remote branch, then STOP here
- Examine the commits provided as part of the context.
- Get every commit's changes with `git log -p --ignore-missing HEAD --not --remotes` to review them all, unless you expect it to be too large.
  Review each commit, not only the end result: a secret added in one commit and removed in a later one is still pushed.

2. **Review the changes**

- Check the output of the pre-commit hook, if any.
- Look for any things that provide information about my system, e.g. the string `/Users/` referencing the home folder.
- Check that no passwords, secret strings or similar are included in the code, except if clearly intended to be public.
- Check the text files for any descriptions that should not be public, e.g. implementation plans for other repos.

3. **Present your review**

- If something that should not be published is found, display the information to the user and STOP here.
- If any pre-push hook issues that would prevent a push are found STOP and ask the user whether they should be fixed.

4. **Do the push**

- If you have found no issues in 2) and 4) then run `git push`
- If the push requires setting upstream, use `git push -u <remote-name> <branch-name>`
- If you work in a worktree of your own whose commits belong on another branch (the user's or the repository's instructions say which), push with `git push <remote-name> HEAD:<branch-name>` instead
- If there are multiple remotes and it is unclear which one the user intends to push to, ask the user before pushing.
- If there is not a remote configured, ask the user if they want to create a new private GitHub repo with `gh` and then push to it. Only create it as public if the user explicitly requests it.
- If the issues that prohibit push exist but the user directs you to push without fixing them, push with `--no-verify`

# Execution safety

Run each git operation as a single, simple command. Never use compound
shell commands: no `cd ... && git ...`, no chaining with `&&` or `;`.
If the repo is not the current working directory, use `git -C <path>`
instead of `cd`.

Don't use the `@{...}` revision syntax, such as `@{upstream}` or `@{u}`.
In a background session that works in a worktree, Claude Code refuses
git commands such as `git log @{upstream}..HEAD`. Name the remote branch
instead, as in `origin/main`.

# Execution details

- If there is a long list of issues, present the concise summary.

# Now do it

1. Gather data about the unpushed commits from the context (`git log --ignore-missing HEAD --not --remotes`)
2. Analyze the changes with `git log -p --ignore-missing HEAD --not --remotes` and run `just pre-commit`
3. If no issues found, execute `git push`
4. If issues found then ONLY if the user explicitly agrees execute `git push --no-verify`
