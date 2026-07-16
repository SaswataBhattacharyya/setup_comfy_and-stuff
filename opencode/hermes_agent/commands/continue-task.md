# Command: continue-task

Purpose: resume a long task from `state/current-task.md`.

Agent role: `orchestrator`

Workflow:

1. Read `opencode/hermes_agent/state/current-task.md`.
2. Summarize completed items, remaining items, last error, and next action.
3. Resume from the first incomplete item or recorded next action.
4. Do not redo completed work unless needed to fix a verification failure.
5. Update the state file after every meaningful batch.
6. Run verification required by the touched subsystem.

Completion rule:

- Do not claim completion unless remaining items are complete and verification status is known.
