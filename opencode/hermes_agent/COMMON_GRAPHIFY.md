# Common Graphify Rules

Graphify is a repository knowledge graph. It is useful for architecture questions, dependency relationships, and impact analysis.

## Current Graph Requirement

Do not rely on bundled or copied Graphify output. Use Graphify only after a graph has been generated for the current repository state, or treat Graphify as unavailable and inspect source files directly.

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

For broad reports, use only a current report generated for this repository.

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
