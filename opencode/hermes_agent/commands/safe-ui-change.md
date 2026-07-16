# Command: safe-ui-change

Purpose: make a frontend/UI change safely.

Agent role: `orchestrator`

Workflow:

1. Inspect relevant files and existing patterns.
2. Route implementation to `frontend`.
3. Use `animation` only if motion is explicitly needed.
4. Use `browser` for visual/UI verification when available.
5. Run `quality-gate`.
6. If build/lint fails, route repair to `debugger`.
7. Re-run `quality-gate`.
8. Inspect diff.

Hard rule:

- Do not claim completion unless `npm run build` passes when available.
