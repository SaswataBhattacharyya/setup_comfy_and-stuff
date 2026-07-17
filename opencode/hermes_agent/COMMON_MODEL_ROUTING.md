# Common Model Routing

Hermes uses one local Qwen model by default and paid GLM-5.2 only for justified huge-context work.

## Unified Local Model

Environment:

- `HERMES_AGENT_MODEL`
- fallback: `OLLAMA_REASONING_MODEL`
- compatibility coding aliases: `HERMES_AGENT_CODER_MODEL`, `OLLAMA_CODER_MODEL`
- compatibility vision aliases: `HERMES_AGENT_VISION_MODEL`, `OLLAMA_VISION_MODEL`

Use for:

- planning
- artifact generation and review
- language tasks
- general web/search synthesis
- failure diagnosis when code edits are not the main task
- deciding whether a specialist is needed
- codebase questions
- stack traces
- implementation plans
- patch design
- tests
- refactors
- multi-file code diagnosis
- image inputs
- generated candidate review
- screenshot inspection
- visual regression checks
- UI layout inspection when pixels matter

Default in this repo is expected to be `qwen3.6:35b` unless local config says otherwise. The coder and vision environment names are retained only as compatibility aliases and should point to the same model.

## Web/Search Tasks

Use the unified local model to synthesize search results. Use web/search tools only when current facts are needed, the user asks for latest information, or source attribution matters.

## GLM-5.2 Optional Route

Use GLM-5.2 only when all are true:

- the task needs very large context or project-wide reasoning
- local Qwen context compression is insufficient
- the user has allowed paid model usage or configured the route for this class of task
- the prompt has passed the cost gate in `COMMON_GLM52_COST_GATE.md`

Good GLM-5.2 tasks:

- read entire codebase architecture and answer a cross-cutting question
- plan an IDE-like multi-file repair
- diagnose an error that crosses frontend, backend, config, and tests
- produce a migration/refactor plan from large repo context

Poor GLM-5.2 tasks:

- simple code edits
- small bugs with stack traces
- routine artifact generation
- summarizing a single file
