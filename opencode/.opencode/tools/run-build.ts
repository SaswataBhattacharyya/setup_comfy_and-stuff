import { exec } from "node:child_process";

export default async function runBuild() {
  return new Promise((resolve) => {
    exec("npm run build --silent", (err, stdout, stderr) => {
      resolve({
        ok: !err,
        output: stdout.trim(),
        error: err ? err.message : stderr.trim()
      });
    });
  });
}
