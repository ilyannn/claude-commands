---
description: Review the latest GitHub Actions runs, surface results, and analyze issues.
argument-hint: [workflow=<file|id>|all]
allowed-tools: Edit, Bash, Grep, Read
---

# Goal

Pull the most recent GitHub Actions workflow runs for a repo, summarize their status, and analyze failures with actionable diagnostics and next steps.

# Inputs

- `$ARGUMENTS` can be:
  - Optional flags:
    - `workflow=<file|id>|all` (e.g., `workflow=ci.yml` or `workflow=all`; default: all workflows)

# Plan

1. **Resolve repository coordinates**
   - You usually know what the current owner/repo are, owner is usually `ilyannn`, repo is usually folder name.
   - If `owner/repo` is unclear, infer from local git:
     - Verify repo: !`git rev-parse --is-inside-work-tree`
     - Remote URL: !`git remote get-url origin || git config --get remote.origin.url`
     - Parse `owner` and `repo` from `https://github.com/owner/repo(.git)?` or `git@github.com:owner/repo(.git)?`.
   - Find out and remember the current commit SHA using `git rev-parse HEAD`.

2. **Select workflows**
   - If `workflow` not provided or set to `all`, use `gh workflow list` to enumerate available workflows.
   - When calling `/flow:ci` next time, remember what those workflows are; no need to repeat unless explicitly prompted.
   - Otherwise, constrain to the specified workflow file name or numeric ID.

3. **Fetch latest runs**
   - For each selected workflow, use `gh run list --workflow=<workflow> --limit=<count> --json databaseId,headSha,status,conclusion,event,createdAt,updatedAt,url,name` with filters:
     - `--branch=<branch>` if provided
     - `--limit=<count>` (default 3, max 20)
   - For each run returned, check if it refers to the current commit SHA.
   - For each that does and that is completed, use `gh run view <run-id> --json status,conclusion,createdAt,updatedAt,url,event,jobs` to get more info:
     - Capture status, conclusion, timings, HTML URL, job details
   - If for a given workflow the run for the current commit has not yet completed, remember that but also examine the most recent completed run.

4. **Deep-dive on failures**
   - For any run that has completed but with `conclusion` not `success`:
     - Use `gh run view <run-id> --log-failed` to get logs for failed jobs.
     - Extract dominant error patterns (stack traces, test failures, exit codes, missing secrets, flaky steps, infra timeouts).
     - Map failing jobs to workflow graph where possible; note common failing steps across runs.

5. **Produce report**
   - Show commit SHA prominently in the header as well as whether all runs for this commit succeeded, some failed or are still ongoing.
   - **Overview table** (per workflow): run ID → commit SHA, status, conclusion, event, duration, started, link.
     - Again, show the runs for the current commit, except if they are not complete, in which case also show the most revent completed run.
   - **Failure summary**: frequency by job/step, top error signatures, first-seen vs. most-recent.
   - **Root-cause hypotheses** per failure cluster, with **concrete next actions**:
     - config fixes (matrix keys, permissions, cache keys)
     - environment/toolchain diffs (runner image, Node/Java versions)
     - flaky tests (test names, suggested quarantine patterns)
     - secret/permission issues (missing `GITHUB_TOKEN` scopes, OIDC, org secret visibility)
   - **Appendix**: tailed logs for failed jobs

6. **Output**
   - Show this to the user

# Execution details

- Prefer _read-only_ operations; do **not** cancel or rerun jobs in this command.
- Be resilient to:
  - Missing workflows (empty list)
  - Private repos or insufficient PAT scopes (report and stop gracefully)
  - Very large logs (use appropriate filtering)
- If `gh` CLI is not authenticated or configured, inform the user to run `gh auth login` first.

# Now do it

1. Gather data using the `gh` CLI commands listed above.
2. Analyze failures and suggest possible steps to mitigate.
3. Present the report to the user in the nice visual format.
