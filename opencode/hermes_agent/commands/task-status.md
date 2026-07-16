# Command: task-status

Purpose: report current persistent task status.

Agent role: `orchestrator`

Workflow:

1. Read `opencode/hermes_agent/state/current-task.md`.
2. Report goal, completed items, remaining items, current check status, last error, and next action.
3. Do not edit files.
4. Do not run build/test unless the user asks.
