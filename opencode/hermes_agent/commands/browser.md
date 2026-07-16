# Command: browser

Purpose: inspect or debug the local UI using browser automation.

Agent role: `browser`

Input:

```text
Task: <what to inspect or debug>
URL: <optional local URL>
```

Workflow:

1. Confirm the app URL.
2. Ask before starting a dev server.
3. Use Playwright/browser MCP if available.
4. Inspect accessibility tree, console errors, navigation, forms, buttons, and visible state.
5. Report findings and minimal fixes.

Rules:

- Prefer accessibility locators.
- Do not perform destructive UI actions without approval.
- If code changes are made, run the relevant quality gate.
