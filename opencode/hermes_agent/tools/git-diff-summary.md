# Tool Workflow: git-diff-summary

Purpose: summarize the current worktree changes.

Command:

```bash
git status --short
```

Then:

```bash
git diff --stat
```

Use when:

- before final response
- before review
- after edit batches

Output must include changed files, untracked files, and whether changes look related to the task.
