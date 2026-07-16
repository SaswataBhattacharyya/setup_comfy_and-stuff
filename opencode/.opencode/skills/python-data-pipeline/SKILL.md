---
name: python-data-pipeline
description: Build and debug Python scripts for data parsing, Excel/CSV processing, OCR, bioinformatics, and automation pipelines.
compatibility: opencode
---

## Goal

Improve Python data pipeline code safely.

## Workflow

1. Inspect input/output assumptions.
2. Identify important scripts and config files.
3. Check pandas/file-path/data-type logic carefully.
4. Add validation and clear errors where useful.
5. Run a small test or dry run if data is available.
6. Summarize changed logic and edge cases handled.

## Rules

- Do not hardcode user-specific paths unless requested.
- Preserve column names and output formats.
- Handle missing values robustly.
