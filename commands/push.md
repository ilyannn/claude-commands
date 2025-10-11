---
description: Check whether the commits are ready to be pushed
argument-hint:
allowed-tools: Bash, Read, Grep
---

# Goal

Review the commits that are not published to the remote. Check for any information that might leak when pushing.

# Context

- !`git log @{upstream}..HEAD || true`
- !`git hook run pre-push || true`

# Plan

1. **Get changes in the commits**

- If there are no unpushed commits, inform the user showing the current branch and remote branch that was compared, then STOP here
- Examine the commits provided as part of the context.
- Try to get the full diff with `git diff @{upstream}..HEAD` to review all changes, unless you expect it to be too large.

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
- If the push requires setting upstream, use `git push -u origin <branch-name>`
- if there is not a remote configured, ask the user if they want to create a new private GitHub repo with `gh` and then push to it. Only create it as public if the user explicitly requests it.
- If the issues that prohibit push exist but the user directs you to push without fixing them, push with `--no-verify`

# Execution details

- If there is a long list of issues, present the concise summary.

# Now do it

1. Gather data about the unpushed commits using `git log @{upstream}..HEAD`
2. Analyze the changes with `git diff @{upstream}..HEAD` and run `just pre-commit`
3. If no issues found, execute `git push`
4. If issues found then ONLY if the user explicitly agrees execute `git push --no-verify`
