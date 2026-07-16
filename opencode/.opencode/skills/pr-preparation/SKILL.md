---
name: pr-preparation
description: Prepare a clean pull request summary, testing notes, and risk list from the current diff.
compatibility: opencode
---

## Goal

Turn current changes into a reviewable PR.

## Workflow

1. Inspect git status and git diff.
2. Summarize changed files.
3. Generate a PR title.
4. Generate PR description:
   - What changed
   - Why
   - Testing performed
   - Risks or follow-ups
5. Suggest commit grouping if needed.

## Rules

- Do not commit or push unless explicitly asked.
- Do not invent tests that were not run.
