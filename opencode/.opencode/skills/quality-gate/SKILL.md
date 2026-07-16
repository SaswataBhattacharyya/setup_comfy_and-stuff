---
name: quality-gate
description: Enforce build, lint, test, browser, and git-diff verification before declaring coding work complete.
compatibility: opencode
---

## Goal

Prevent broken code from being marked as complete.

## Mandatory workflow

For any code change, especially React/Vite/Tailwind/Electron/frontend work:

1. Inspect the existing file structure before editing.
2. Make the smallest safe patch.
3. After every meaningful edit, run the fastest relevant check:
   - TypeScript/JSX syntax check
   - npm run build
   - npm run lint if available
   - npm run test if available
4. If a check fails:
   - stop feature work
   - fix only the compile/build error
   - rerun the failed command
5. Review git diff before final response.
6. Only say "done" after verification passes or after clearly stating what still fails.

## Frontend-specific checks

For React/Vite/Tailwind:

- Never finalize with JSX syntax errors.
- Never finalize with CSS/PostCSS errors.
- Never finalize with Tailwind config errors.
- Preserve existing light/dark mode behavior unless explicitly changed.
- Preserve navigation, auth, cart, checkout, and existing routes unless explicitly changed.

## Final response must include

- Files changed
- Commands run
- Whether build passed
- Whether lint passed
- Whether browser check was done
- Remaining risks
