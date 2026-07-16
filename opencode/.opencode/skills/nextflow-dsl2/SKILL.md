---
name: nextflow-dsl2
description: Build and debug Nextflow DSL2 bioinformatics pipelines with config separation, channels, processes, and HPC compatibility.
compatibility: opencode
---

## Goal

Work safely on Nextflow DSL2 pipelines.

## Workflow

1. Inspect main.nf, modules, nextflow.config, sample sheets, and params.
2. Understand channel inputs and process outputs before editing.
3. Keep tool paths and conda environments in config where possible.
4. Preserve HPC/no-sudo assumptions.
5. Run nextflow config or a dry run when available.
6. Summarize affected processes and outputs.

## Rules

- Prefer DSL2 modules.
- Keep outputs organized and explicit.
- Ask before running full pipelines.
