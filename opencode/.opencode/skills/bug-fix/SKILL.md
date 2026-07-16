---
name: bug-fix
description: Diagnose and fix bugs using minimal edits, logs, tests, and verification.
compatibility: opencode
---

## Goal

Fix bugs with the smallest safe change.

## Workflow

1. Reproduce or understand the error.
2. Read logs, stack traces, failing tests, or screenshots.
3. Locate the smallest relevant code path.
4. Check related definitions and references before editing.
5. Make a minimal patch.
6. Run targeted tests, lint, or build if available.
7. Summarize:
   - root cause
   - files changed
   - verification performed
   - remaining risks

## Rules

- Do not rewrite unrelated files.
- Do not change public APIs unless necessary.
- Ask before dependency installation.
