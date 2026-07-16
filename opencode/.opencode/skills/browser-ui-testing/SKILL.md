---
name: browser-ui-testing
description: Use Playwright/browser automation to inspect, test, and debug frontend UI.
compatibility: opencode
---

## Goal

Verify frontend behavior in a real browser-like environment.

## Workflow

1. Check available dev/start scripts.
2. Ask before starting a dev server.
3. Use Playwright MCP when available.
4. Navigate pages, inspect accessibility tree, interact with UI, and check forms/navigation.
5. Report console/runtime issues if available.
6. Suggest minimal code fixes.

## Rules

- Prefer accessibility locators.
- Do not rely only on screenshots.
- Ask before destructive UI actions.
