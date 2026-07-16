---
description: Execute a coding task fully with edits, build checks, fixes, and final verification.
agent: build
---

You are not planning. You are executing.

User task:
$ARGUMENTS

Use the `persistent-execution-loop` skill.

Hard rules:
- Do not stop after making only partial edits.
- Do not give "next steps for the user".
- Create or update `.opencode/state/current-task.md`.
- Keep a TODO list and continue until all TODO items are done or blocked.
- Make small edits.
- After each meaningful edit batch, run `npm run build`.
- If build fails, stop feature work and fix the build error.
- Repeat build/fix until `npm run build` passes.
- Then run `npm run lint` if available.
- Then run `git diff --stat` and inspect changed files.
- Final response must include:
  - TODO items completed
  - files changed
  - commands run
  - build result
  - lint result
  - remaining issues

Important:
Do not say "done", "implemented", or "completed" unless `npm run build` passes.
