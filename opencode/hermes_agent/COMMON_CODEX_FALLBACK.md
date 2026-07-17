# Codex Fallback Gate

Codex is the optional fallback for tasks that exceed the local Qwen context or need IDE-grade coding judgment.

## Default Route

Use local `qwen3.6:35b` through Ollama by default.

Do not use Codex for routine work, small edits, simple debugging, casual web lookup, normal ComfyUI/Krita operation, or tasks the local model can handle with source inspection and compressed context.

## When Codex Is Appropriate

Use Codex only when all are true:

- the task needs very large context, project-wide reasoning, or deep coding review
- local Qwen plus file outlines, `rg`, LSP, and Graphify-style summaries are insufficient
- the user has approved Codex use for this request or this session category
- the task is coding, architecture, review, debugging, migration, or security analysis

## Handoff Triggers

Hermes should consider Codex when one of these triggers is present:

- Failure loop: local Qwen attempts the same bug/fix/test loop three times and the same or equivalent error remains.
- Huge context: the task needs broad repo architecture, many files, or cross-cutting reasoning that compressed context cannot cover.
- Cross-system refactor: the task touches multiple decoupled systems such as runtime scripts, backend, frontend, config, tests, and docs together.
- Security-sensitive code: the task involves auth, secrets, shell scripts, installers, networking, public ports, dependency changes, MCP/plugin permissions, or credential handling.
- Complex migration/debugging: the task needs IDE-grade coding review, migration planning, or deep multi-file diagnosis.

Do not hand off to Codex just because a task mentions browser, Figma, GitHub, web search, image generation, or ComfyUI. Try local Qwen and local tools first.

Good Codex fallback tasks:

- project-wide architecture mapping
- complex multi-file repair planning
- code review of risky diffs
- migration/refactor planning
- security review of code or scripts
- diagnosing errors that cross frontend, backend, config, runtime, and docs

Poor Codex fallback tasks:

- ordinary chat
- single-file edits
- routine command lookup
- image generation
- ComfyUI workflow execution
- tasks involving secrets unless the user explicitly approves the exact redacted context

## Permission Policy

Codex usage must be permissioned.

When Hermes wants to use Codex, ask:

```text
Codex fallback may help because: <reason>.
It may use your authenticated Codex account/subscription and inspect the selected repo context.
Allow Codex for this request?
Choices: allow once, always allow for this category in this session, do not allow.
```

Behavior:

- `allow once`: use Codex for the current request only; ask again next time.
- `always allow for this category in this session`: use Codex for future qualifying requests in the current Hermes CLI process only.
- `do not allow`: continue with local Qwen, compressed context, source inspection, and browser/local tools.

Session approvals are in-memory only. Never write approvals to disk. When Hermes CLI exits and restarts, ask again.

## Manual Codex Auth Setup

Run these manually on the DGX machine:

```bash
codex --version
```

If `codex` is missing, install the OpenAI Codex CLI using the official OpenAI instructions for your account/surface.

Then authenticate:

```bash
codex login
```

If your installed Codex CLI uses a different command, run:

```bash
codex --help
```

and choose the documented login/auth command. Prefer ChatGPT/subscription login over raw OpenAI API keys when the goal is to use your existing subscription rather than direct API billing.

Verify:

```bash
codex status
```

or, if unavailable:

```bash
codex --help
```

Hermes should not store your Codex credentials in this repo. Keep Codex auth in Codex's own user-level credential store.

## Delegation Pattern

Before launching Codex:

1. Summarize the task and why local Qwen is insufficient.
2. Redact secrets and private tokens.
3. Identify exact files/directories Codex should inspect.
4. Ask the permission question.
5. If approved, launch Codex from the relevant repo root.
6. Keep Hermes as orchestrator: Codex returns findings, Hermes verifies and applies the user's final preference.

Codex should receive compact context, not raw full transcripts, unless the transcript is the artifact under review.

Installed Codex CLI command shape on this machine:

```bash
codex exec -C /home/saswata/web_dev/website_design/comfy_setup "$(cat .codex-task.md)"
```

For code review:

```bash
codex review -C /home/saswata/web_dev/website_design/comfy_setup
```

Avoid undocumented commands such as `codex run --file`. Do not use `codex cloud` unless the user explicitly approves cloud task handoff.
