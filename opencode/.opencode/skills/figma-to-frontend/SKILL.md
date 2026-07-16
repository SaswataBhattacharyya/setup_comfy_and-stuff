---
name: figma-to-frontend
description: Convert Figma frames/components into frontend code using Figma MCP design context.
compatibility: opencode
---

## Goal

Translate Figma design context into accurate frontend implementation.

## Workflow

1. Get Figma frame link or current selection.
2. Use Figma MCP if available.
3. Extract layout, spacing, typography, color tokens, assets, and component structure.
4. Map to existing project components and styles.
5. Implement with React/Vite/CSS/Tailwind conventions.
6. Verify with build/browser where possible.

## Rules

- Prefer existing design system components.
- Do not invent assets if Figma provides them.
- Note deviations from design.
