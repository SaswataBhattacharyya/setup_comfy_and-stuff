# Tool Workflow: project-summary

Purpose: quickly summarize the current project.

Commands:

```bash
pwd
```

```bash
find . -maxdepth 2 -type f \( -name 'README*' -o -name 'package.json' -o -name 'pyproject.toml' -o -name '*.md' \) | sort
```

For Node projects:

```bash
node -e "try{const p=require('./package.json'); console.log(p.scripts||{})}catch(e){console.log('No package.json found')}"
```

Use read-only inspection first. Do not install dependencies from this workflow.
