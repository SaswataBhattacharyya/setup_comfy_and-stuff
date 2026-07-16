---
description: Fix current build/compile errors only, without doing new feature work.
agent: debugger
---

The project currently has build or dev-server errors.

Task:
$ARGUMENTS

Rules:
1. Do not redesign.
2. Do not add features.
3. Do not edit unrelated files.
4. Run or inspect the failing command output.
5. Fix only the first compile/build error.
6. Rerun the failed command.
7. Repeat until build passes or blocked.
8. Then run git diff and summarize.

For React/Vite/Tailwind:
- JSX parse errors usually mean mismatched tags or broken conditional blocks.
- PostCSS errors usually mean malformed CSS, missing braces, or invalid Tailwind config.
- Tailwind config errors usually mean invalid object syntax.

Final answer must say whether `npm run build` passed.
