---
name: code-review
description: Review code changes for bugs, regressions, maintainability, security issues, and missing tests.
compatibility: opencode
---

## Goal

Review changes like a senior engineer.

## Workflow

1. Inspect git status and git diff.
2. Read changed files in context.
3. Look for bugs, missing edge cases, broken APIs, security risks, and missing tests.
4. Provide findings ordered by severity.
5. Suggest concrete fixes.

## Rules

- Do not edit unless asked.
- Be specific and cite files/functions.
- Distinguish real issues from optional improvements.
