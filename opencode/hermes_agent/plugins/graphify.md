# Plugin Behavior: Graphify Reminder

OpenCode used a plugin to remind the agent about Graphify before bash calls. Hermes should reproduce the behavior as an internal preflight rule.

Before broad repository searches or architecture work:

1. Check whether a current Graphify graph exists for this repo.
2. Check whether the graph belongs to this exact repo and current code state.
3. If current, prefer:

```bash
graphify query "<question>"
```

```bash
graphify path "<A>" "<B>"
```

```bash
graphify explain "<concept>"
```

4. If no current graph exists, say so and use source inspection.

Do not rely on copied, bundled, or stale Graphify output.
