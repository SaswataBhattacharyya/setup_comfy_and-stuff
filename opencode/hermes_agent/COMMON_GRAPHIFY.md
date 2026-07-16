# Common Graphify Rules

Graphify is a repository knowledge graph. It is useful for architecture questions, dependency relationships, and impact analysis.

## Important Agentic Art Warning

The current `opencode/graphify-out/` content was generated for another repository. Do not use that graph as factual evidence for Agentic Art.

Before relying on Graphify in this repo, regenerate or point Graphify at the current Agentic Art codebase.

## Preferred Commands

For focused codebase questions:

```bash
graphify query "<question>"
```

For relationships between two concepts:

```bash
graphify path "<A>" "<B>"
```

For a concept explanation:

```bash
graphify explain "<concept>"
```

For broad reports, read `graphify-out/GRAPH_REPORT.md` only after query/path/explain are insufficient.

## When To Use

Use Graphify for:

- broad repo onboarding
- architecture maps
- central modules
- dependency relationships
- impact scope before refactors
- unfamiliar codebase questions

Skip Graphify for:

- one-file bugs
- tasks about stale graph output
- cases where no current graph exists
- user requests that explicitly say not to use it

## After Code Changes

If Graphify is active for the current repo, update it after meaningful code changes:

```bash
graphify update .
```

Dirty graph files after hooks or incremental updates are not by themselves a failure.
