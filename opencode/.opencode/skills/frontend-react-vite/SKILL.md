---
name: frontend-react-vite
description: Build and debug React, Vite, CSS, routing, state, and frontend UI workflows.
compatibility: opencode
---

## Goal

Work safely on React/Vite frontend code.

## Workflow

1. Inspect package.json, src, routes, components, CSS, and state files.
2. Identify existing component and styling patterns.
3. Make focused component/CSS/state changes.
4. Run lint/build/test if available.
5. Summarize changed files and any UI behavior not visually verified.

## Rules

- Avoid direct DOM hacks unless necessary.
- Keep components modular.
- Avoid rewriting unrelated CSS.
- Preserve existing routing and state structure.
