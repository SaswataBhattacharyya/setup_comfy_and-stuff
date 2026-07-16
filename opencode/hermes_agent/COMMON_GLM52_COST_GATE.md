# GLM-5.2 Cost Gate

GLM-5.2 is optional and paid. Hermes must use it deliberately.

## Current Public Facts To Verify Before Use

As of 2026-07-16, Z.ai documentation describes:

- OpenAI-compatible endpoint: `https://api.z.ai/api/paas/v4/`
- model name: `glm-5.2`
- context length: 1M tokens
- maximum output: 128K tokens
- API pricing: `$1.40 / 1M input tokens`, `$4.40 / 1M output tokens`
- GLM Coding Plan support for OpenCode-like tools starting around `$18/month`, with quota limits

Sources:

- `https://docs.z.ai/guides/overview/quick-start`
- `https://docs.z.ai/guides/llm/glm-5.2`
- `https://docs.z.ai/guides/overview/pricing`
- `https://docs.z.ai/devpack/overview`

Pricing and subscription terms can change. Re-check before enabling spend.

## Subscription vs API Key Guidance

Use the GLM Coding Plan if Hermes is operating through supported coding tools and the quota is enough. Use direct Z.ai API billing if Hermes needs predictable API calls outside the coding-plan gateway.

Do not assume an OpenCode-provided key automatically works for arbitrary backend API calls. Test the exact endpoint and quota class before wiring Hermes to it.

## Mandatory Pre-GLM Filter

Before sending anything to GLM-5.2:

1. Confirm the task qualifies as huge-context or project-wide.
2. Remove secrets and irrelevant generated files.
3. Use Graphify or file outlines first when available.
4. Compress context.
5. Estimate token class: small, medium, huge.
6. Log why local Qwen was insufficient.
7. Ask for session-scoped approval unless it has already been granted in the current Hermes CLI session.

## Permission Policy

GLM-5.2 usage must be permissioned because it is paid.

When Hermes wants to use GLM-5.2, ask:

```text
GLM-5.2 is paid. This task appears to need huge-context reasoning because: <reason>.
Allow GLM-5.2 for this request?
Choices: allow once, allow always for this session, deny.
```

Behavior:

- `allow once`: use GLM-5.2 for the current request only; ask again next time.
- `allow always for this session`: use GLM-5.2 for future qualifying requests in the current CLI process only.
- `deny`: do not use GLM-5.2; continue with local Qwen models and compressed context.

Session approvals are in-memory only. They must not be written to disk. When Hermes CLI exits and restarts, ask again.

Never make GLM-5.2 the default model. The default remains local Qwen.

## Compression Strategy

Preferred reference implementation:

- Microsoft LLMLingua / LLMLingua-2: `https://github.com/microsoft/LLMLingua`

Fallback without installing compressors:

- repo tree plus selected files
- symbol outlines
- API contracts
- failing logs
- changed diff
- Graphify query output
- explicit constraints
- concise question

Preserve exact raw errors and exact public API signatures. Compress prose, repeated docs, generated assets, and unrelated implementation bodies.

## GLM Output Rules

Ask GLM for:

- architecture map
- impact scope
- repair/refactor plan
- exact files likely needing changes
- risks and verification plan

Avoid asking GLM to emit huge patches directly unless Hermes has already narrowed the affected files.
