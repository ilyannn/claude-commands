---
description: Check whether the commits are ready to be pushed 
argument-hint: 
allowed-tools: Bash, Read, Grep 
---

# Goal

Review the commits that are not published to the remote. Check for any information that might leak when pushing.

# Inputs

None

# Plan

1) **Get changes in the commits**
  - Use `git log @{upstream}..HEAD` to check for unpushed commits
  - If there are no unpushed commits, inform the user showing the current branch and remote branch that was compared, then STOP here
  - Get the full diff with `git diff @{upstream}..HEAD` to review all changes

2) **Review the changes**
  - Look for any things that provide information about my system, e.g. the string `/Users/in` 
  - Check that no passwords, secret strings or similar are included in the code, except if clearly intended to be public
  - Check the text files for any descriptions that should not be public, e.g. implementation plans for other repos

3) **Present your review**
  - If something that should not be published is found, display the information to the user and STOP here  

4) **Run last-minute checks**
  - Do a quick `just pre-commit` check
  - If any issues are found STOP and ask the user whether they should be fixed.

5) **Do the push**
  - If you have found no issues in 2) and 4) then run `git push`
  - If the push requires setting upstream, use `git push -u origin <branch-name>`
     
# Execution details

  - If there is a long list of issues, present the concise summary.

# Now do it

1. Gather data about the unpushed commits using `git log @{upstream}..HEAD`
2. Analyze the changes with `git diff @{upstream}..HEAD` and run `just pre-commit`
3. If no issues found, execute `git push` 
