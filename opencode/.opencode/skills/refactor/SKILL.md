---
name: refactor
description: Improve structure, readability, or maintainability without changing behavior.
compatibility: opencode
---

## Goal

Refactor safely while preserving behavior.

## Workflow

1. Identify the refactor target.
2. Read all affected files and references.
3. Explain the intended behavior-preserving change.
4. Make small incremental edits.
5. Run tests/lint/build if available.
6. Summarize changed structure and risk areas.

## Rules

- Preserve external behavior.
- Avoid large rewrites unless requested.
- Do not combine refactor with unrelated feature work.
