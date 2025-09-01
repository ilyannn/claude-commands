---
description: Review the latest GitHub Actions runs, surface results, and analyze issues.
argument-hint: [workflow=<file|id>|all]
allowed-tools: Edit, mcp__github__list_workflows, mcp__github__list_workflow_runs, mcp__github__get_workflow_run, mcp__github__list_workflow_jobs, mcp__github__get_job_logs, mcp__github__get_workflow_run_usage, mcp__github__list_workflow_run_artifacts, Bash(git rev-parse --is-inside-work-tree:*), Bash(git remote get-url:*), Bash(git config --get remote.origin.url:*)
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
   - Find out and remember the current commit SHA.

2. **Select workflows**
   - If `workflow` not provided or set to `all`, call `mcp__github__list_workflows` to enumerate available workflows.
   - When calling `/ci` next time, remember what those workflows are; no need to repeat unless explicitly prompted.
   - Otherwise, constrain to the specified workflow file name or numeric ID.

3. **Fetch latest runs**
   - For each selected workflow, call `mcp__github__list_workflow_runs` with filters:
     - `branch` if provided
     - `perPage = min(count, 20)` (default 3)
   - For each run returned, check if it referes to the current commit SHA.
   - For each that does and that is completed, use these to get more info:
     - `mcp__github__get_workflow_run` (to capture status, conclusion, timings, HTML URL)
   - If for a given workflow the run for the current commit has not yet completed, remember that but also examine the most recent completed run.

4. **Deep-dive on failures**
   - For any run that has completed but with `conclusion` not `success`:
     - Call `mcp__github__get_job_logs` with `failed_only=true`, `return_content=true`, and `tail=tail` (default 200).
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

- Prefer _read-only_ MCP operations; do **not** cancel or rerun jobs in this command.
- Be resilient to:
  - Missing workflows (empty list)
  - Private repos or insufficient PAT scopes (report and stop gracefully)
  - Very large logs (respect the `tail` limit)
- If the GitHub MCP server is not connected or `actions` toolset unavailable, briefly inform the user and suggest enabling it, then stop.

# Now do it

1. Gather data using the MCP tools listed above.
2. Analyze failures and suggest possible steps to mitigate.
3. Present the report to the user in the nice visual format.
