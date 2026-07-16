---
name: performance-debugging
description: Diagnose slow builds, slow frontend rendering, inefficient Python/data processing, memory issues, and bottlenecks.
compatibility: opencode
---

## Goal

Identify and improve performance bottlenecks.

## Workflow

1. Identify the slow operation.
2. Inspect relevant code paths.
3. Look for repeated work, large memory copies, blocking calls, and inefficient loops.
4. Propose measurement before optimization when possible.
5. Make targeted improvements.
6. Summarize before/after expectations.

## Rules

- Do not optimize blindly.
- Preserve correctness.
- Prefer measurable improvements.
