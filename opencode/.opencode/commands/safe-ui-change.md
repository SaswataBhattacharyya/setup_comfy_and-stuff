---
description: Make a frontend/UI change safely with build, lint, browser, and diff verification.
agent: orchestrator
---

Use the safe UI workflow.

User task:
$ARGUMENTS

Rules:
1. Do not directly jump into large edits.
2. First inspect relevant files and existing patterns.
3. Use `frontend` for React/Vite/CSS/Tailwind implementation.
4. Use `animation` only if animation is explicitly needed.
5. Use `browser` with Playwright MCP if browser inspection is available.
6. Use `quality-gate` after implementation.
7. If build/lint fails, stop new design work and use `debugger` to fix only the failure.
8. Run `quality-gate` again.
9. Review git diff.
10. Final answer must include:
   - files changed
   - commands run
   - build status
   - lint status
   - browser verification status
   - remaining issues

Hard rule:
Do not say the task is complete unless `npm run build` passes.
