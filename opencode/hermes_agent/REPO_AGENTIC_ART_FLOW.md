# Agentic Art Repo Flow

This repo is a local story-to-image/video builder with Hermes supervision.

Hermes drives a website-backed autonomous pipeline. It should not invent new runtime stages.

## Artifact Chain

1. `story`
2. `characters`
3. `scenes`
4. `subscenes`
5. `dialogue`
6. `visual_continuity_plan`
7. `asset_plan`
8. `keyframe_plan`
9. `generation_queue`

All generated stage outputs must be valid JSON objects.

## Asset Rules

Character assets:

- one reusable identity image per distinct named character
- no group character assets
- no emotion, pose, injury, lighting, action, or camera variants as separate character assets
- split groups into individually named characters when they recur

Background assets:

- reusable empty location plates
- no visible people
- no story action

Keyframes:

- composed shots
- carry action, expression, blocking, camera, and mood
- reference accepted reusable assets
- use staged edits when more than three total source images are needed

## Workflow Modes

Use only:

- `qwen_2512_t2i` for standalone reusable character/background assets
- `qwen_edit` for composed keyframes and refinements
- `wan2_2_flf2v` for first/last-frame video between consecutive accepted keyframes

Do not use `gsl_starter_1_1` for new jobs.

## Image Review

Hermes must inspect actual generated candidates when available.

Selection priority:

1. prompt match
2. identity consistency
3. correct character count
4. background/location correctness
5. usable composition
6. absence of major defects

Select the best usable candidate. Request redo only when every candidate is structurally unusable. Pause only when a human preference decision is genuinely needed.

## TTS and Audio Boundary

The TTS/audio stack is already isolated. Hermes should treat audio generation, SRT analysis, and voice/timing assets as downstream or parallel artifacts unless the user asks to change that subsystem.

Do not mix audio dependency setup with image/video pipeline repair unless a failure explicitly crosses that boundary.
