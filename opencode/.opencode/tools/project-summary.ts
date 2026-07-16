import { exec } from "node:child_process";

export default async function projectSummary() {
  const command = "printf 'PWD:\n' && pwd && printf '\nTop-level files:\n' && ls -la && printf '\nPackage scripts:\n' && node -e \"try{const p=require('./package.json'); console.log(p.scripts||{})}catch(e){console.log('No package.json found')}\"";

  return new Promise((resolve) => {
    exec(command, (err, stdout, stderr) => {
      resolve({
        ok: !err,
        output: stdout.trim(),
        error: err ? err.message : stderr.trim()
      });
    });
  });
}
