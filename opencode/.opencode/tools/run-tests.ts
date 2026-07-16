import { exec } from "node:child_process";

export default async function runTests() {
  return new Promise((resolve) => {
    exec("npm run test --silent", (err, stdout, stderr) => {
      resolve({
        ok: !err,
        output: stdout.trim(),
        error: err ? err.message : stderr.trim()
      });
    });
  });
}
