# Command: execute-until-done

Purpose: execute a coding task fully with state tracking and verification.

Agent role: `orchestrator`

Input:

```text
Task: <user task>
```

Workflow:

1. Use `persistent-execution-loop`.
2. Create or update `state/current-task.md`.
3. Inspect relevant files before edits.
4. Make small patches.
5. After each meaningful edit batch, run the fastest relevant check.
6. If a check fails, stop feature work and fix the check.
7. Run quality gate.
8. Inspect git diff.
9. Final response includes completed items, files changed, commands run, build/lint/test status, and remaining risk.
