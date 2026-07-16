---
description: Continue the current long coding task from the persistent task state file.
agent: build
---

Continue the current long coding task.

First read:

.opencode/state/current-task.md

Then do this:

1. Summarize:
   - completed items
   - remaining items
   - last error
   - next action

2. Continue from the first incomplete item or the recorded next action.

3. Do not redo completed work unless needed to fix a build error.

4. After each meaningful edit batch:
   - update `.opencode/state/current-task.md`
   - run `npm run build`

5. If build fails:
   - stop feature work
   - fix only the build error
   - update `Last error`
   - rerun `npm run build`

6. When build passes:
   - update `Current build/lint/test status`

7. Continue until:
   - all items are complete and build passes
   - or a real blocker is encountered

Hard rules:
- Do not give "next steps for the user" unless blocked.
- Do not stop after only explaining.
- Do not claim completion unless all checkboxes are done and build passes.

