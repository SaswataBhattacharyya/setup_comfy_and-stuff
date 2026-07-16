# Common Hermes Skills

This file is self-contained. Hermes must not need the original `.opencode/skills/*/SKILL.md` files to understand these procedures.

## repo-onboarding

Goal: understand an unfamiliar repository before changing it.

Use when:

- starting in a new repo
- answering broad architecture questions
- setting up Hermes for a repo
- choosing safe next files to inspect

Workflow:

1. Inspect README files, manifests, scripts, config, and entrypoints.
2. Identify stack, services, ports, generated outputs, and ignored folders.
3. Detect build, lint, test, typecheck, and run commands.
4. Check existing agent docs, skills, MCP config, and project-specific rules.
5. Summarize project purpose, important folders, commands, risks, and next inspection targets.

Rules:

- Prefer read-only commands first.
- Do not install, migrate, or run long services just for onboarding.
- Distinguish repo facts from assumptions.

## persistent-execution-loop

Goal: keep long tasks resumable.

Use when:

- task spans multiple files
- task may exceed one session
- build/test repair loops are likely
- user asks for autonomous continuation

State file sections:

- goal
- constraints
- files touched
- completed items
- remaining items
- current build/lint/test status
- last error
- next action

Workflow:

1. Create or update the state file before meaningful edits.
2. Convert the task into checkboxes.
3. Update state after each meaningful edit batch.
4. Record exact failed command and first actionable error.
5. Resume from the first incomplete item or recorded next action.

Rules:

- Do not rely only on chat memory.
- Do not mark complete unless remaining items are done and verification status is known.

## feature-implementation

Goal: add a feature without breaking existing behavior.

Workflow:

1. Understand desired behavior and success criteria.
2. Inspect existing patterns and relevant contracts.
3. Plan the smallest implementation slice.
4. Edit in focused batches.
5. Add tests when behavior risk justifies it.
6. Run relevant checks.
7. Review diff and summarize user-facing behavior.

Rules:

- Follow local architecture.
- Avoid unnecessary rewrites.
- Keep public API changes explicit.

## bug-fix

Goal: diagnose and fix a bug with the smallest safe change.

Workflow:

1. Capture the exact bug, stack trace, log, or reproduction.
2. Identify the failing layer.
3. Inspect the narrowest relevant code path.
4. Check definitions/references before editing shared APIs.
5. Make the smallest patch.
6. Re-run the failed check or closest available verification.
7. Report root cause, files changed, and residual risk.

Rules:

- Do not mix bug fixes with refactors.
- Do not install dependencies unless approved.
- Preserve raw error details in logs.

## performance-debugging

Goal: identify and improve slow or resource-heavy behavior.

Workflow:

1. Define the performance symptom and measurement.
2. Inspect hot paths, loops, network calls, model calls, and generated artifacts.
3. Prefer measurement over guesswork.
4. Make one change at a time.
5. Re-measure.

Rules:

- Do not reduce correctness to improve speed unless explicitly accepted.
- Record before/after metrics when available.

## refactor

Goal: improve structure while preserving behavior.

Workflow:

1. Define the target smell or complexity.
2. Inspect all references and public contracts.
3. Make behavior-preserving edits.
4. Keep renames and API changes explicit.
5. Run relevant tests/build.

Rules:

- Do not add features.
- Do not rename public APIs without explicit approval.
- Do not hide behavior changes inside cleanup.

## test-generation

Goal: add focused tests that protect behavior.

Workflow:

1. Identify behavior and failure mode to protect.
2. Inspect existing test style and fixtures.
3. Add the smallest meaningful test.
4. Run targeted test first, then broader checks if needed.

Rules:

- Avoid brittle snapshots unless UI output is intentionally fixed.
- Prefer tests that fail before the fix when practical.

## quality-gate

Goal: prevent broken work from being marked complete.

Mandatory checks for code edits:

1. Run the fastest relevant syntax/build check.
2. Run lint if configured and relevant.
3. Run tests if configured and relevant.
4. Inspect git diff.
5. Report skipped checks with reasons.

Frontend rule:

- For React/Vite/Tailwind changes, run `npm run build` when available.

Failure rule:

- If build/lint/test fails, stop new feature work and fix only the failure.

## code-review

Goal: review changes like a senior engineer.

Workflow:

1. Inspect git status and diff.
2. Read changed files in context.
3. Find bugs, regressions, missing tests, security risks, and maintainability issues.
4. Order findings by severity.
5. Provide concrete fixes.

Rules:

- Do not edit files unless the user asks for fixes.
- Cite file/function.
- Distinguish real issues from optional improvements.

## security-review

Goal: find security and permission risks.

Workflow:

1. Search for secrets, unsafe shell execution, injection, unsafe file access, and risky permissions.
2. Inspect suspicious paths manually.
3. Redact secret values.
4. Suggest safe fixes.

Rules:

- Do not print credentials.
- Do not run unknown scripts.
- Do not broaden permissions casually.

## browser-ui-testing

Goal: verify frontend behavior in a real browser-like environment.

Workflow:

1. Check run scripts and app URL.
2. Ask before starting a dev server.
3. Use Playwright/browser MCP.
4. Inspect accessibility tree and console.
5. Interact with UI paths.
6. Report reproduction and observed behavior.

Rules:

- Prefer accessibility locators.
- Do not rely only on screenshots.
- Avoid destructive actions.

## frontend-react-vite

Goal: work safely on React/Vite frontends.

Workflow:

1. Inspect `package.json`, `src`, routes, components, CSS, and config.
2. Identify design/component patterns.
3. Preserve API and state contracts.
4. Make focused edits.
5. Run build/lint/test as available.
6. Use browser checks for visual behavior.

Rules:

- Never leave JSX/CSS/Tailwind syntax errors.
- Keep components modular.
- Preserve route behavior unless explicitly changed.

## animation-frontend

Goal: create smooth, accessible animation.

Workflow:

1. Identify the exact interaction or scene.
2. Check existing animation dependencies.
3. Prefer CSS for simple transitions.
4. Use GSAP/anime.js only for timeline-heavy motion.
5. Respect reduced motion.
6. Verify build and browser behavior.

Rules:

- Avoid layout thrash.
- Do not add heavy libraries without approval.

## graphify-repo-map

Goal: use Graphify as a compact repo knowledge graph.

Workflow:

1. Check graph freshness and repo identity.
2. Use focused Graphify commands before broad source search.
3. Verify important graph conclusions from source.
4. Use `graphify update .` after meaningful code changes if Graphify is active.

Rules:

- Do not trust a graph generated from another repo.
- Do not regenerate unless asked or needed.

## documentation

Goal: produce accurate, maintainable docs.

Workflow:

1. Inspect source of truth first.
2. Separate facts from assumptions.
3. Include commands that work from the correct directory.
4. Avoid stale or repo-specific details in common docs.
5. Link or name relevant files.

Rules:

- Do not document behavior that is not implemented unless clearly labeled as planned.
