# Command: fix-build

Purpose: fix current build or compile errors only.

Agent role: `debugger`

Workflow:

1. Run or inspect the failing command output.
2. Fix only the first actionable compile/build error.
3. Re-run the failed command.
4. Repeat until the command passes or a blocker is found.
5. Inspect diff.
6. Report whether build passed.

Rules:

- Do not redesign.
- Do not add features.
- Do not edit unrelated files.
