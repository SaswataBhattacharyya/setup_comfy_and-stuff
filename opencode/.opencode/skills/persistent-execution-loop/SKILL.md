---
name: persistent-execution-loop
description: Continue long coding tasks across model stops by maintaining a persistent task state file.
compatibility: opencode
---

## Goal

Prevent long tasks from being abandoned when the model stops, hits output limits, loses focus, or finishes only part of a plan.

## Persistent state file

Always use:

.opencode/state/current-task.md

## Required state sections

The state file must contain:

1. Goal
2. Constraints
3. Files touched
4. Completed items
5. Remaining items
6. Current build/lint/test status
7. Last error
8. Next action

## Workflow

1. Before editing, create or update `.opencode/state/current-task.md`.
2. Convert the user's task into checkboxes.
3. Mark items complete only after edits and verification.
4. After every edit batch, update the state file.
5. Run build/lint/test as appropriate.
6. If build fails, stop feature work and record the error under `Last error`.
7. Fix the error before continuing feature work.
8. If stopping before completion, write the exact next action.
9. On `/continue-task`, read this state file first and resume from the first incomplete item.

## Rules

- Do not rely only on in-memory todo.
- Do not say the task is complete unless all remaining items are checked and build passes.
- If context gets large, summarize progress into the state file.
- The state file is the source of truth for resuming.
