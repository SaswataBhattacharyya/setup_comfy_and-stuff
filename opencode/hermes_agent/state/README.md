# Hermes State

`current-task.md` is the persistent task state file for long Hermes tasks.

Hermes must update it:

- before starting multi-file work
- after each meaningful edit batch
- after verification commands
- before stopping or handing off

It is the source of truth for `continue-task` and `task-status`.
