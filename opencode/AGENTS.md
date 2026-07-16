# Agent Guidelines for Solrasa

## Graphify

This project has a knowledge graph at `graphify-out/` with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, invoke the `skill` tool with `skill: "graphify"` before doing anything else.

If the actual OpenCode skill is named `graphify-repo-map` instead of `graphify`, use `skill: "graphify-repo-map"`.

Rules:

* For codebase questions, first run:

```bash
graphify query "<question>"
```

when `graphify-out/graph.json` exists.

* Use:

```bash
graphify path "<A>" "<B>"
```

for relationships.

* Use:

```bash
graphify explain "<concept>"
```

for focused concepts.

* These commands return scoped subgraphs and are usually much smaller than reading all of `GRAPH_REPORT.md` or doing raw grep first.
* Dirty `graphify-out/` files are expected after hooks or incremental updates. Dirty graph files are not a reason to skip Graphify.
* Only skip Graphify if:

  * the task is about stale/incorrect graph output, or
  * the user explicitly says not to use Graphify.
* If `graphify-out/wiki/index.md` exists, use it for broad navigation instead of raw source browsing.
* Read `graphify-out/GRAPH_REPORT.md` only for broad architecture review or when query/path/explain do not surface enough context.
* After modifying code, run:

```bash
graphify update .
```

to keep the graph current.

## Project Goal

This repository is a Solrasa e-commerce/web app with a React/Vite frontend and Django backend.

Maintain and improve the Solrasa website while preserving:

* Cart flow
* Checkout flow
* Login/auth flow
* Settings/account flow
* Backend API contracts
* Product/catalog behavior
* Light/dark mode behavior
* Existing ecommerce functionality

UI and design may be changed only when requested, but core app behavior must not be broken.

## Build/Test Commands

Use these commands from the repository root.

### Development

Start full development mode:

```bash
RUN_NPM_AUDIT_FIX=yes START_BACKEND=yes START_FRONTEND=yes ./setup_dev.sh
```

Frontend dev server usually runs through the script. Do not start multiple dev servers unless checking ports first.

### Production

Build production frontend/server mode:

```bash
DOMAIN=solrasa.com WWW_DOMAIN=www.solrasa.com START_FRONTEND=yes ./setup_prod.sh
```

### Frontend checks

Run build after every meaningful frontend edit:

```bash
npm run build
```

Run lint if available:

```bash
npm run lint
```

Run tests if available:

```bash
npm run test
```

If Bun is used in this repo, equivalent commands may be:

```bash
bun run build
bun run lint
bun test
```

## Mandatory Coding Workflow

For any code-editing task:

1. Inspect relevant files before editing.
2. Create or update `.opencode/state/current-task.md` for multi-file or long tasks.
3. Make small patches.
4. After each meaningful edit batch, run `npm run build`.
5. If build fails:

   * stop feature work
   * fix only the build error
   * rerun `npm run build`
6. Run lint/test if available.
7. Inspect `git diff --stat` and relevant `git diff`.
8. Do not say “done”, “implemented”, or “fixed” unless build status is known.

For large tasks, use:

```text
/go <task>
```

If the agent stops midway, continue with:

```text
/go
```

or:

```text
/continue-task
```

## Frontend Rules

Frontend stack:

* React
* Vite
* TypeScript
* Tailwind
* shadcn-style components where present

Rules:

* Never leave broken JSX.
* Never leave malformed CSS/PostCSS.
* Never leave malformed Tailwind config.
* Preserve route behavior unless explicitly changing routes.
* Preserve API endpoint names and response assumptions.
* Prefer small reusable components.
* Keep dark mode working.
* Use `dark:` Tailwind classes where needed.
* Do not replace functioning cart/checkout/auth logic with mock data.

## UI Redesign Rules

For landing page or website redesign work:

1. Use browser/Playwright MCP to inspect reference pages when possible.
2. First capture structure:

   * sections
   * nav
   * hero
   * typography
   * colors
   * buttons
   * product cards
3. Implement in phases:

   * global theme/fonts
   * navbar/header
   * landing hero
   * collection/product listing
   * product detail
   * footer
   * polish/animations
4. Run build after every phase.
5. Use Playwright/browser checks after build passes.

Do not attempt a whole-site redesign as one giant patch.

## Persistent Task State

For long tasks, maintain:

```text
.opencode/state/current-task.md
```

This file must include:

* Goal
* Constraints
* Files touched
* Completed items
* Remaining items
* Current build/lint/test status
* Last error
* Next action

Update it before stopping.

## Agent Usage

Use these agents when appropriate:

* `frontend` for React/Vite/Tailwind/UI implementation
* `debugger` for build/runtime errors
* `tester` for lint/test/build verification
* `quality-gate` for final verification
* `reviewer` for read-only git diff review
* `browser` for Playwright MCP and local UI inspection
* `figma` for Figma MCP/design-to-code
* `animation` for CSS/GSAP/anime.js/WebGL/microinteractions
* `security` for secrets, unsafe commands, insecure IPC, injection risks
* `graph-navigator` for Graphify repo map output

For implementation-heavy tasks, prefer the `build` agent or `/go` command over pure planning.

## Commands

Useful OpenCode commands in this repo:

```text
/go <task>
/continue-task
/task-status
/fix-build
/safe-ui-change <task>
/review
/browser <task>
/figma <task>
/graphify <question>
```

## Safety Rules

Ask before:

* installing dependencies
* deleting files
* running migrations
* changing backend API contracts
* changing deployment scripts
* enabling Blender MCP
* using external asset generation tools

Never run:

```bash
sudo
rm -rf /
chmod -R
```

## Git Rules

Before large AI changes, prefer a checkpoint commit.

Always inspect:

```bash
git status
git diff --stat
git diff
```

Do not commit or push unless explicitly asked.
