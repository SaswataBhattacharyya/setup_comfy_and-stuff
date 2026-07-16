---
name: security-review
description: Review code for secrets, unsafe shell execution, injection risks, insecure IPC, auth problems, and dangerous permissions.
compatibility: opencode
---

## Goal

Find security risks before they become bugs.

## Workflow

1. Inspect changed files or security-sensitive areas.
2. Look for hardcoded secrets, tokens, unsafe exec, SQL injection, XSS, insecure IPC, and overbroad permissions.
3. Report issues with severity.
4. Suggest safe fixes.

## Rules

- Do not expose secrets in output.
- Do not run suspicious code.
- Prefer read-only inspection unless asked.
