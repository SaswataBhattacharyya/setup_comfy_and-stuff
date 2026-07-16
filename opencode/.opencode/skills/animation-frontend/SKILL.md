---
name: animation-frontend
description: Implement high-quality frontend animations using CSS, GSAP, anime.js, SVG, WebGL, and performance-safe patterns.
compatibility: opencode
---

## Goal

Create smooth, accessible, maintainable frontend animation.

## Workflow

1. Understand the desired interaction or scene.
2. Check existing animation libraries before adding dependencies.
3. Prefer CSS transform/opacity for simple animations.
4. Use GSAP/anime.js only when timeline control is needed.
5. Use WebGL/Three.js only for canvas/3D-heavy effects.
6. Respect prefers-reduced-motion.
7. Verify build/lint and browser behavior when possible.

## Rules

- Do not add heavy dependencies without approval.
- Avoid layout-thrashing properties.
- Keep animation reusable.
