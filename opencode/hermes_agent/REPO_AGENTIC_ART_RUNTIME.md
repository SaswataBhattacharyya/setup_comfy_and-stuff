# Agentic Art Runtime

## Main Services

- FastAPI backend: `api_server/main.py`
- React website: `ai-art-generator-hub`
- ComfyUI: image/video workflow execution
- Hermes supervision: `api_server/services/hermes_supervisor.py`
- Hermes model client: `api_server/services/hermes_agent_client.py`
- Agent console: `agent_console/streamlit_app.py`
- Ollama: local OpenAI-compatible model server

## Ports

- ComfyUI: `3008`
- Agent console: `3009`
- Website/backend: `3010`
- Ollama: `11434`

## Entrypoints

- first setup/start: `./bootstrap_vm.sh`
- Hermes CLI setup: `./setup_hermes_agent.sh`
- normal pipeline start: `./run_hermes_pipeline.sh`

## Model Environment

Unified local model:

- `OLLAMA_REASONING_MODEL`
- `HERMES_AGENT_MODEL`

Compatibility coding aliases:

- `OLLAMA_CODER_MODEL`
- `HERMES_AGENT_CODER_MODEL`

Compatibility vision aliases:

- `OLLAMA_VISION_MODEL`
- `HERMES_AGENT_VISION_MODEL`

Endpoint:

- `HERMES_AGENT_BASE_URL`
- default local value: `http://127.0.0.1:11434/v1`

Timeouts:

- `HERMES_AGENT_TIMEOUT_SECONDS`
- `OLLAMA_TIMEOUT_SECONDS`

## Current Expected Local Stack

- reasoning/coding/vision: `qwen3.6:35b`

Inspect `config/hermes_agent.local.env` before assuming actual local values.

## Logging

The website and backend project state expose project logs. The agent console shows live project logs, dependency status, pending actions, and Hermes events.

Hermes must log stage starts, long-call heartbeats, approvals, revisions, pauses, image selections, dependency failures, and next actions.

## Existing Backend Loader

The active supervisor currently reads markdown from the top-level `hermes/` directory. This `opencode/hermes_agent/` pack is not automatically loaded by backend runtime unless a later implementation syncs or wires it in.
