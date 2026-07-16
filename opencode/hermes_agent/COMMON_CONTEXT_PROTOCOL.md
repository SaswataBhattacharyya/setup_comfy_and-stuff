# Common Context Protocol

Hermes must move context between models without losing critical facts or wasting tokens.

## Context Pack Shape

Every handoff should include:

- task goal
- current state
- constraints
- relevant files or artifacts
- decisions already made
- errors and raw snippets
- open questions
- exact next action

Use structured JSON when the receiver is a programmatic model call. Use compact markdown when the receiver is a human or CLI agent.

## Model Handoff Rules

- Reasoning model receives product intent, repo summaries, artifact summaries, and decisions.
- Coder model receives exact files, stack traces, symbols, APIs, tests, and diff constraints.
- Vision model receives images/screenshots plus concise visual criteria and relevant artifact context.
- Paid huge-context model receives only after local context gathering and compression.

## Ping-Pong Control

When a task moves from one model to another:

1. Hermes writes a transition summary.
2. The receiver returns findings plus confidence and missing context.
3. Hermes decides whether to continue, ask another model, or pause.
4. Hermes records the decision in logs.

Do not pass raw full transcripts unless the transcript itself is the artifact under review.

## Compression Defaults

Before sending long context:

- prefer Graphify query/path/explain over full repo dumps
- include file outlines before full files
- include call chains and symbols instead of entire directories
- include diffs instead of whole changed files when reviewing edits
- summarize prior model responses into decisions and evidence
- keep raw error bodies intact when they are diagnostic

## Required Handoff Footer

Every specialist handoff should end with:

```text
Status:
Files/artifacts used:
Decision:
Verification:
Next action:
Risks:
```
