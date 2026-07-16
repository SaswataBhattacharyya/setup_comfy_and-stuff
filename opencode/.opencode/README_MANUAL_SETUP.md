# Manual steps to finish OpenCode setup

The files and directories created by the automated script are only the skeleton. You must run the following commands and create the indicated files before the agent can be used.

## 1. Install required npm packages for tooling (optional but recommended)
```bash
# From the project root
npm install -D @types/node @types/react @types/react-dom typescript-language-server
```

## 2. Verify LSP works in your editor
- Open any `.tsx` file.
- Ensure the TypeScript language server starts (usually shown in the status bar).
- If not, configure your editor to run `typescript-language-server --stdio`.

## 3. Add core skill markdown files
Create a `SKILL.md` in each of the skill directories you see under `.opencode/skills/`. Below are minimal templates you can copy‑paste.

### Example: repo‑onboarding/SKILL.md
```md
---
name: repo-onboarding
description: Initialise OpenCode for a new repository – create config, generate project summary, and verify basic commands.
---

## Workflow
1. Read `package.json` and `tsconfig*.json`.
2. Run `npm install` if dependencies are missing (ask permission).
3. Execute `npm run lint` and `npm run test` to confirm the project builds.
4. Summarise the project structure.
```

Repeat the same pattern for the other skills (`bug-fix`, `feature-implementation`, `refactor`, `test-generation`, `code-review`, `pr-preparation`, `documentation`, `frontend-react-vite`, `electron-app`, `python-data-pipeline`, `nextflow-dsl2`, `bioinformatics-vcf-maf`, `security-review`, `performance-debugging`). You can keep the body short – the agent only needs the YAML front‑matter and a brief description.

## 4. Add custom tool stubs (TypeScript)
Create the following files under `.opencode/tools/` and implement the simple exec wrappers:
- `run-tests.ts`
- `run-lint.ts`
- `run-build.ts`
- `git-diff-summary.ts`
- `project-summary.ts`

Each file should export a default async function that runs the corresponding npm script via `child_process.exec` and returns an object `{ok:boolean, output:string, error?:string}`. Example for `run-tests.ts`:
```ts
import { exec } from "node:child_process";
export default async function runTests() {
  return new Promise(resolve => {
    exec("npm run test --silent", (err, stdout, stderr) => {
      resolve({ ok: !err, output: stdout.trim(), error: err?.message ?? stderr.trim() });
    });
  });
}
```

## 5. Configure the IDE UI (outside the repo)
- Launch OpenCode in ACP mode: `opencode acp --model=gpt-4o-mini` (or your preferred model).
- Wire the following panels in your editor:
  * **Diff viewer** – shows patches before applying.
  * **Terminal** – runs approved bash commands.
  * **Approval queue** – prompts for any `edit` or `bash` action marked as `ask`.
  * **Problems panel** – shows LSP diagnostics.
  * **Test panel** – displays the result of `run-tests`.
- Ensure the approval queue respects the permission matrix in `.opencode/opencode.json`.

## 6. (Optional) Deploy MCP servers
If you want extra capabilities, start any of the MCP servers listed in the plan (GitHub, Playwright, etc.) and add their endpoint URLs to the OpenCode configuration under a new `mcp` field.

## 7. Verify the setup
1. Start the ACP backend.
2. In the chat panel, ask the agent to `run a simple edit`: e.g., add a comment to `src/App.tsx`.
3. Approve the edit when the diff appears.
4. Run `npm run test` via the `run-tests` tool and confirm all tests pass.

Once these steps are completed, OpenCode will be fully configured and ready to act as a Codex‑like coding assistant for this repository.
