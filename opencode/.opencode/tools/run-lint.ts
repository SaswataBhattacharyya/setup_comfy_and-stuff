import { exec } from "node:child_process";

export default async function runLint() {
  return new Promise((resolve) => {
    exec("npm run lint --silent", (err, stdout, stderr) => {
      resolve({
        ok: !err,
        output: stdout.trim(),
        error: err ? err.message : stderr.trim()
      });
    });
  });
}
