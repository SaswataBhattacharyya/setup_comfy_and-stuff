---
name: repo-onboarding
description: Inspect a repository safely, identify the tech stack, scripts, structure, risks, and recommended next steps.
compatibility: opencode
---

## Goal

Understand an unfamiliar repository before making changes.

## Workflow

1. Inspect top-level files and folders.
2. Check git status and recent commits.
3. Identify the tech stack from package.json, requirements.txt, pyproject.toml, nextflow.config, tsconfig, vite config, etc.
4. Find available test, lint, build, and typecheck commands.
5. Identify existing OpenCode config, skills, and tools.
6. Summarize:
   - project type
   - important folders
   - available scripts
   - missing setup
   - safe next steps

## Rules

- Do not edit files unless explicitly asked.
- Prefer read-only commands first.
- Ask before install, build, migration, docker, or destructive commands.
