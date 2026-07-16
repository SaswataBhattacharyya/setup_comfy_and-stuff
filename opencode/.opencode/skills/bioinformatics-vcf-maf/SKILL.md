---
name: bioinformatics-vcf-maf
description: Work on VCF, MAF, BED, GTF, variant annotation, Funcotator/VEP-style exports, and mutation table conversion.
compatibility: opencode
---

## Goal

Safely edit bioinformatics variant-processing code.

## Workflow

1. Inspect input formats and expected output columns.
2. Check header handling, INFO parsing, chromosome formats, and missing values.
3. Preserve exact output schema unless requested.
4. Add small test examples if possible.
5. Validate with sample VCF/BED/MAF data if available.
6. Summarize format assumptions and edge cases.

## Rules

- Do not silently drop variants.
- Be careful with coordinates and 0-based/1-based conversions.
- Preserve sample and gene identifiers.
