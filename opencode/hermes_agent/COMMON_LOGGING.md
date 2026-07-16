# Common Logging and Visibility

Hermes must make background work visible.

## Required Log Surfaces

For this repo:

- website/project log: `http://127.0.0.1:3010`
- agent console: `http://127.0.0.1:3009`
- backend API logs from the process running `main.py`
- Ollama process log when launched by scripts: `/tmp/ollama.log`
- setup test outputs such as `/tmp/hermes-local-ollama-test.json`

## What Hermes Must Log

- run start and stop
- stage start and finish
- current model and endpoint
- prompt size or context size
- image batch start
- image selection decisions
- approvals, revisions, pauses
- tool calls that affect state
- failed dependency calls with raw error body when available
- retries and retry reasons
- heartbeats for long-running model calls

## Heartbeat Rule

For long calls, log periodic heartbeats with:

- stage or job id
- layer
- endpoint
- model
- waited seconds
- current action

Do not let a multi-minute model call look idle.

## Failure Log Format

Every failure should include:

```text
layer:
stage_or_job_id:
service_or_tool:
model_or_workflow:
error:
smallest_safe_next_action:
```

## Background CLI Rule

If Hermes uses its own CLI, CLI activity must still be mirrored into project-visible logs or a documented log file. A user should be able to answer: what is Hermes doing, which model is it waiting on, and what will it try next?
