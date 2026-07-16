# Plugin Behavior: Graphify Reminder

OpenCode used a plugin to remind the agent about Graphify before bash calls. Hermes should reproduce the behavior as an internal preflight rule.

Before broad repository searches or architecture work:

1. Check whether `graphify-out/graph.json` exists.
2. Check whether the graph belongs to the current repo.
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

4. If the graph is stale or belongs to another repo, say so and use source inspection.

For Agentic Art, the bundled `opencode/graphify-out` was generated for another repo, so it must not be used as truth until regenerated.
