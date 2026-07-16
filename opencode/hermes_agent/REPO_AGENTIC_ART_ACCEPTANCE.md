# Agentic Art Acceptance Rules

Hermes may claim a stage is complete only when the relevant acceptance checks are known.

## JSON Artifacts

- output is one valid JSON object
- required stage fields are present
- upstream story intent is preserved
- no invented workflow stages
- no invalid asset references
- no group character assets
- no expression-state character assets

## Generation Queue

- jobs are dependency ordered
- character/background assets use `qwen_2512_t2i`
- keyframes use `qwen_edit`
- video segments use `wan2_2_flf2v`
- `gsl_starter_1_1` is absent
- `qwen_edit` jobs use no more than three total source images per pass
- staged edit jobs are used when more sources are needed

## ComfyUI Submission

Before submission, rely on backend preflight for:

- referenced model filenames
- active `links.md` downloads
- missing model diagnosis
- free VRAM checks
- ComfyUI memory release

If preflight fails, treat it as a dependency failure and report the exact missing filename, workflow mode, job id, and next action.

## Image Decisions

For accepted candidates, record:

- selected candidate id
- job id
- rationale
- major tradeoff if any
- whether identity, character count, background, and composition passed

For redo or pause, record the structural reason.

## Code Changes

If Hermes changes code:

- inspect relevant files first
- keep edits scoped
- run build/lint/test commands appropriate to the touched subsystem
- inspect git diff
- report commands and results

For `ai-art-generator-hub`, run `npm run build` when available after meaningful frontend edits.

## Final Status

Final status must include:

- completed stages or files
- verification performed
- logs to inspect
- failures or skipped checks
- smallest safe next action if incomplete
