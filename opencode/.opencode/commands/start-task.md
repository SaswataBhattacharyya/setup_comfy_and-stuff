---
description: Start a long coding task with persistent state tracking.
agent: build
---

Start a long coding task with persistent execution tracking.

User task:
$ARGUMENTS

Use the `persistent-execution-loop` skill.

First create or overwrite:

.opencode/state/current-task.md

The file must contain:

# Current Task

## Goal
Summarize the user task.

## Constraints
List all constraints and things not to break.

## Files touched
Initially empty.

## Completed
Initially empty.

## Remaining
Create a detailed checkbox plan.

## Current build/lint/test status
Not run yet.

## Last error
None.

## Next action
The first implementation action.

Then begin implementation immediately.

Hard rules:
- Do not stop after planning.
- Actually edit files.
- Update `.opencode/state/current-task.md` after every meaningful edit batch.
- Run `npm run build` after every meaningful edit batch.
- If build fails, fix the build before continuing feature work.
- If you need to stop, update `Next action` with the exact continuation step.
- Do not say complete unless all remaining items are done and build passes.
