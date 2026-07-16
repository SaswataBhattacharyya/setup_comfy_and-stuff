---
name: feature-implementation
description: Implement a new feature using a plan, small patches, existing project patterns, and verification.
compatibility: opencode
---

## Goal

Add a feature without breaking existing behavior.

## Workflow

1. Understand the requested feature.
2. Inspect related files and existing patterns.
3. Create a short implementation plan.
4. Make focused edits.
5. Add or update tests if appropriate.
6. Run lint/build/test commands if available.
7. Summarize what changed and how it was verified.

## Rules

- Follow the existing architecture.
- Avoid unnecessary rewrites.
- Keep changes small and reviewable.
