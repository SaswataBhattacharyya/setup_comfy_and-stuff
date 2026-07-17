# Hermes Agent Pack

This folder is the Hermes instruction pack for Agentic Art Bare Minimum.

## Assumptions Made

- This folder is a markdown instruction pack, not a complete Hermes runtime by itself.
- The existing repo scripts remain the supported setup path on ARM64 NVIDIA DGX Spark.
- Hermes should use one local Ollama/Qwen model first for reasoning, coding, and vision.
- GLM-5.2 is optional and paid, so it must be routed through a cost gate.
- The existing top-level `hermes/*.md` files are still the active backend instruction source unless the backend loader or sync step is changed.
- Every repo should have its own repo-specific Hermes guide layered on top of the common Hermes guides.
- The original `.opencode/agents` and `.opencode/skills` folders are source material only. They are not required at runtime by this pack because `COMMON_AGENTS.md` and `COMMON_SKILLS.md` now restate the roles and procedures directly.

## Does This Folder Alone Suffice?

Yes for the standalone markdown/CLI onboarding pack, with one caveat: Hermes must be started through this folder's installer or explicitly instructed to load it.

This folder now contains the transferred OpenCode material as Hermes-readable equivalents:

- agents: `COMMON_AGENTS.md`
- skills: `COMMON_SKILLS.md`
- commands: `commands/*.md`
- tools: `tools/*.md`
- persistent state: `state/current-task.md`
- plugin behavior: `plugins/graphify.md`
- MCP setup guidance: `mcp/README.md`
- model routing and GLM cost gate: `COMMON_MODEL_ROUTING.md`, `COMMON_GLM52_COST_GATE.md`
- repo-specific Agentic Art flow/runtime/acceptance files: `REPO_AGENTIC_ART_*.md`

It is not a binary Hermes runtime by itself. Hermes will obey it when one of these integration paths is used:

1. Copy or sync these files into Hermes CLI memory, usually under `$HERMES_HOME/memories/<repo_name>/`.
2. Update this repo's backend loader in `api_server/services/hermes_supervisor.py` to also read `opencode/hermes_agent/*.md`.
3. Start Hermes CLI from this repo and explicitly tell it to read this folder before work.
4. Run `./opencode/hermes_agent/install_and_start_hermes_cli.sh`, which syncs this folder to Hermes memory before launching the CLI.

Current runtime fact: `api_server/services/hermes_supervisor.py` reads the top-level `hermes/*.md` files. The existing `setup_hermes_agent.sh` script syncs top-level `hermes/*.md` into `$HERMES_HOME/memories/agentic_art/`, not this folder.

The standalone script already syncs this folder into `$HERMES_HOME/memories/agentic_art/hermes_agent/`. A later backend integration can still teach `api_server/services/hermes_supervisor.py` to read this folder directly for website-driven runtime prompts.

It has two layers:

- `COMMON_*.md`: portable Hermes agent, model-routing, tool, swarm, and skill rules.
- `REPO_AGENTIC_ART_*.md`: rules specific to this repository's story-to-image/video/TTS runtime.

The current backend runtime reads the existing top-level `hermes/*.md` files from `api_server/services/hermes_supervisor.py`. Files in this folder are therefore a source pack for Hermes CLI setup, future sync, and review. They do not change runtime behavior until they are copied into the active Hermes memory path or the backend loader is updated.

## Recommended Load Order

1. `COMMON_ORCHESTRATOR.md`
2. `COMMON_AGENTS.md`
3. `COMMON_SKILLS.md`
4. `COMMON_CONTEXT_PROTOCOL.md`
5. `COMMON_MODEL_ROUTING.md`
6. `COMMON_TOOLS_MCPS.md`
7. `COMMON_GRAPHIFY.md`
8. `COMMON_LOGGING.md`
9. `COMMON_GLM52_COST_GATE.md`
10. `commands/*.md`
11. `tools/*.md`
12. `state/README.md`
13. `plugins/*.md`
14. `mcp/README.md`
15. `REPO_AGENTIC_ART_FLOW.md`
16. `REPO_AGENTIC_ART_RUNTIME.md`
17. `REPO_AGENTIC_ART_ACCEPTANCE.md`

## Runtime Position

Hermes is the orchestrator. It should route tasks to bounded specialist roles, keep visible logs, preserve context between roles, and prefer the local Qwen stack before any paid model.

Default local model:

- reasoning/language/coding/vision: `HERMES_AGENT_MODEL` or `OLLAMA_REASONING_MODEL`
- compatibility aliases: `HERMES_AGENT_CODER_MODEL`, `OLLAMA_CODER_MODEL`, `HERMES_AGENT_VISION_MODEL`, `OLLAMA_VISION_MODEL`

Optional paid route:

- GLM-5.2 via Z.ai OpenAI-compatible API for huge-context repository ingestion and project-wide debugging only.

## Current Important Caveat

`opencode/graphify-out/` was generated for another repository. Keep the Graphify method, but do not treat that existing graph as truth for Agentic Art until Graphify is regenerated against this repo.

## ARM64 NVIDIA DGX Spark Setup

Run these commands from the repo root:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
```

First-time full setup:

```bash
./bootstrap_vm.sh
```

Hermes CLI setup and local Ollama configuration:

```bash
./setup_hermes_agent.sh
```

Self-contained setup for this Hermes pack, including syncing these docs into Hermes memory and starting the CLI:

```bash
./opencode/hermes_agent/install_and_start_hermes_cli.sh
```

The standalone script can install Ollama if missing, start Ollama, prompt for one unified local model, pull that model once, install Hermes CLI, configure Hermes for local Qwen via Ollama, sync this pack into Hermes memory, and start the CLI.

Normal startup after setup:

```bash
./run_hermes_pipeline.sh
```

The normal startup should expose:

- ComfyUI on port `3008`
- Hermes agent console on port `3009`
- website/backend on port `3010`
- Ollama on port `11434`

Open the live Hermes/background log surface:

```bash
http://127.0.0.1:3009
```

Open the website/project log surface:

```bash
http://127.0.0.1:3010
```

If Ollama was started by the script, inspect its process log:

```bash
tail -f /tmp/ollama.log
```

## Starting Hermes CLI

Check the CLI is installed:

```bash
hermes --version
```

Run Hermes setup wizard only when interactive setup is needed:

```bash
hermes setup
```

Configure Hermes CLI to use local Ollama through the OpenAI-compatible endpoint:

```bash
hermes config set model.provider custom
```

```bash
hermes config set model.base_url http://127.0.0.1:11434/v1
```

```bash
hermes config set model.api_key ollama
```

```bash
hermes config set model.api_mode chat_completions
```

Set the default model to the repo-selected unified model:

```bash
hermes config set model.default qwen3.6:35b
```

Start Hermes CLI from the repo root and tell it to load this pack:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
```

```bash
hermes
```

Or run the bundled setup/start script:

```bash
./opencode/hermes_agent/install_and_start_hermes_cli.sh
```

To perform setup and sync without starting the CLI:

```bash
HERMES_START_CLI=0 ./opencode/hermes_agent/install_and_start_hermes_cli.sh
```

Initial Hermes instruction for this repo:

```text
Read opencode/hermes_agent/README.md first. Then read the COMMON_*.md files, commands/*.md, tools/*.md, state/README.md, plugins/*.md, mcp/README.md, and the REPO_AGENTIC_ART_*.md files in the documented load order. Treat those as your Hermes orchestration guide for this repository. Use the local Qwen model first, keep project logs visible, and follow the Agentic Art repo-specific flow.
```

## GLM-5.2 Permission Rule

Hermes must use the local Qwen model by default. GLM-5.2 is only for huge-context or project-wide reasoning.

Before the first GLM-5.2 use in a CLI session, Hermes must ask for permission:

```text
GLM-5.2 is paid. Allow GLM-5.2 for this request?
Choices: allow once, allow always for this session, deny.
```

- `allow once`: ask again next time.
- `allow always for this session`: do not ask again until this Hermes CLI process exits.
- after Hermes is closed and restarted, ask again.
- never persist GLM approval to disk.

## Per-Repo Hermes Pattern

For every repository, keep the same split:

- common reusable Hermes files: orchestration, model routing, logging, Graphify, MCPs, context protocol, cost gate
- repo-specific files: project purpose, runtime commands, ports, model defaults, artifact flow, acceptance checks, failure rules

Hermes must always load the repo-specific guide after the common guide. Repo-specific rules override common rules when they conflict.

Suggested folder shape for another repo:

```text
opencode/hermes_agent/
  README.md
  COMMON_ORCHESTRATOR.md
  COMMON_AGENTS.md
  COMMON_SKILLS.md
  COMMON_CONTEXT_PROTOCOL.md
  COMMON_MODEL_ROUTING.md
  COMMON_TOOLS_MCPS.md
  COMMON_GRAPHIFY.md
  COMMON_LOGGING.md
  COMMON_GLM52_COST_GATE.md
  REPO_<PROJECT_NAME>_FLOW.md
  REPO_<PROJECT_NAME>_RUNTIME.md
  REPO_<PROJECT_NAME>_ACCEPTANCE.md
```
