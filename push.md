---
description: Check whether the commits are ready to be pushed 
argument-hint: 
allowed-tools: Bash[git log, git diff, git show, git status, git branch, git remote, just pre-commit, git push], Read, Grep 
---

# Goal

Review the commits that are not published to the remote. Check for any information that might leak when pushing.

# Inputs

None

# Plan

1) **Get changes in the commits**
  - If there are no unpushed commits, inform the user showing the current branch and remote branch that was compared, then STOP here

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
  - If you have found no issues in 2) and 4) then run the `git push`.
     
# Execution details

  - If there is a long list of issues, present the concise summary.

# Now do it

1. Gather data about the commits.
2. Analyze them and run `just pre-commit` 
3. If no issues, push. 
