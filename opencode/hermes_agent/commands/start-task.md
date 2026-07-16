# Command: start-task

Purpose: start a long coding task with persistent state.

Agent role: `orchestrator`

Workflow:

1. Create or overwrite `opencode/hermes_agent/state/current-task.md`.
2. Fill in goal, constraints, files touched, completed, remaining, check status, last error, and next action.
3. Begin work immediately unless the user asked only for planning.
4. Update the state file after each meaningful batch.
5. Verify before marking items complete.
