import { exec } from "node:child_process";

export default async function gitDiffSummary() {
  return new Promise((resolve) => {
    exec("git status --short && git diff --stat", (err, stdout, stderr) => {
      resolve({
        ok: !err,
        output: stdout.trim(),
        error: err ? err.message : stderr.trim()
      });
    });
  });
}
