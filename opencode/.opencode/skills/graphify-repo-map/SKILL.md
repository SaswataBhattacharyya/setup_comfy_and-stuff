---
name: graphify-repo-map
description: Use Graphify outputs to understand repository architecture, major modules, dependencies, and important files.
compatibility: opencode
---

## Goal

Use Graphify as a persistent repository knowledge graph.

## Workflow

1. Check whether `graphify-out/GRAPH_REPORT.md` exists.
2. If it exists, read it before doing large repo exploration.
3. If `graphify-out/graph.json` exists, use it to understand module relationships.
4. Use normal file reads only for files that need detailed inspection.
5. Summarize:
   - main modules
   - important files
   - dependency relationships
   - risky or central components
   - recommended next files to inspect

## Rules

- Do not regenerate Graphify output unless asked.
- Do not treat Graphify output as perfect; verify important conclusions from source files.
- Prefer Graphify for architecture questions, not small one-file bug fixes.

