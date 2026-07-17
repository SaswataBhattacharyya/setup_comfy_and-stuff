# Special Local DGX Spark Guide

This guide is for the ARM64 NVIDIA DGX Spark setup in this folder.

## Quick Verdict On The Hermes Script

The script at:

```bash
opencode/hermes_agent/install_and_start_hermes_cli.sh
```

is mostly ARM64-safe as a shell script. It does not hard-code x86 paths and it does not compile native code itself. It should run on the DGX Spark if the machine has the same basics that `dgx_doctor.sh` already confirmed: `curl`, `git`, `node`, `npm`, working NVIDIA runtime, and normal outbound internet access.

Important caveats:

- It installs Ollama from `https://ollama.com/install.sh`. Ollama supports Linux ARM64, so this part is expected to work on DGX Spark.
- It installs Hermes from live network install scripts. This is the riskiest part because it depends on the Hermes installer publishing an ARM64-compatible Linux binary or install path.
- It now uses one model by default: `qwen3.6:35b`. The old coder and vision environment variable names are kept as aliases to the same model, so the script should not pull `qwen3-coder:30b` or `qwen3-vl:30b`.
- It starts Ollama on `127.0.0.1:11434`, which is local-only.
- It does not expose Hermes or Ollama on public network ports.
- It configures Hermes to use the local Ollama OpenAI-compatible endpoint: `http://127.0.0.1:11434/v1`.
- The bundled `opencode/opencode.json` includes remote MCP definitions such as Figma at `https://mcp.figma.com/mcp`. Those are outbound remote connections, not public inbound ports.

Recommended first run:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
HERMES_START_CLI=0 ./opencode/hermes_agent/install_and_start_hermes_cli.sh
```

Then verify:

```bash
ollama list
curl http://127.0.0.1:11434/api/tags
hermes --version
```

Start Hermes after verification:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
hermes
```

## One-Model Hermes Setup

Use `qwen3.6:35b` as the single local model for reasoning, coding, and vision/image review.

The compatibility variables should all point to the same model:

```bash
OLLAMA_REASONING_MODEL=qwen3.6:35b
OLLAMA_CODER_MODEL=qwen3.6:35b
OLLAMA_VISION_MODEL=qwen3.6:35b
HERMES_AGENT_MODEL=qwen3.6:35b
HERMES_AGENT_CODER_MODEL=qwen3.6:35b
HERMES_AGENT_VISION_MODEL=qwen3.6:35b
HERMES_AGENT_BASE_URL=http://127.0.0.1:11434/v1
```

Hermes setup/config choices:

```text
provider: custom / OpenAI-compatible
base URL: http://127.0.0.1:11434/v1
API key: ollama
API mode: chat_completions
default model: qwen3.6:35b
```

Equivalent commands:

```bash
hermes config set model.provider custom
hermes config set model.base_url http://127.0.0.1:11434/v1
hermes config set model.api_key ollama
hermes config set model.api_mode chat_completions
hermes config set model.default qwen3.6:35b
```

## Local Port Map

Use loopback addresses unless you intentionally want LAN access.

```text
ComfyUI:  http://127.0.0.1:3008
Ollama:   http://127.0.0.1:11434
Hermes:   CLI process using Ollama at 127.0.0.1:11434/v1
Krita:    desktop app; connects to ComfyUI at 127.0.0.1:3008
```

Do not start local services with `--listen 0.0.0.0` unless you want other machines to reach them. For local-only use, prefer `127.0.0.1`.

## Start ComfyUI Locally

The bootstrap already prints the correct command. Use the same Python runtime that passed the CUDA Torch check.

If using an activated conda env:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
conda activate react
cd ComfyUI
python main.py --listen 127.0.0.1 --port 3008
```

If using an explicit Python:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup/ComfyUI
/path/to/python main.py --listen 127.0.0.1 --port 3008
```

Check it:

```bash
curl http://127.0.0.1:3008/system_stats
```

Open in browser on the DGX desktop:

```text
http://127.0.0.1:3008
```

ComfyUI must be running before Krita AI can use it as an external backend. Krita itself can open without ComfyUI, and the plugin can be installed without ComfyUI running, but image generation through the plugin needs a reachable ComfyUI server.

## Install Krita AI Diffusion Plugin

The bootstrap downloads the plugin zip into:

```bash
/home/saswata/web_dev/website_design/comfy_setup/downloads/
```

The expected version from this repo is:

```text
krita_ai_diffusion-1.52.1.zip
```

Install in Krita:

1. Open Krita.
2. Go to `Tools -> Scripts -> Import Python Plugin from File`.
3. Select the downloaded `krita_ai_diffusion-*.zip`.
4. Restart Krita.
5. Enable the docker if needed from `Settings -> Dockers -> AI Image Generation`.

If the plugin loads but websocket import fails, use the compatibility copy from the old notes:

```bash
mkdir -p ~/.local/share/krita/pykrita
cp -a ~/.local/share/krita/pykrita/ai_diffusion/websockets ~/.local/share/krita/pykrita/
```

Then restart Krita.

## Connect Krita To Local ComfyUI

Start ComfyUI first:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup/ComfyUI
python main.py --listen 127.0.0.1 --port 3008
```

In Krita:

1. Open the `AI Image Generation` docker.
2. Open the plugin settings/server connection area.
3. Choose external/local ComfyUI server.
4. Set the server URL to:

```text
http://127.0.0.1:3008
```

5. Connect.
6. Create or open an image document.
7. Use the plugin generation panel.

If Krita and ComfyUI are on the same DGX desktop session, `127.0.0.1` is correct.

If Krita runs on a different computer and ComfyUI runs on DGX, then `127.0.0.1` will point to the Krita computer, not the DGX. For your requested fully local DGX setup, keep both on the DGX and use `127.0.0.1`.

## Where Krita Workflows Go

Your old note says Krita AI workflows/styles can be copied here:

```bash
~/.local/share/krita/ai_diffusion/workflows
```

Create it if missing:

```bash
mkdir -p ~/.local/share/krita/ai_diffusion/workflows
```

This repo also copies ComfyUI workflows to:

```bash
ComfyUI/user/default/workflows
```

Those are for ComfyUI's own workflow UI.

## Fully Local Ollama And Hermes

Start Ollama local-only:

```bash
OLLAMA_HOST=127.0.0.1:11434 ollama serve
```

In another terminal:

```bash
curl http://127.0.0.1:11434/api/tags
ollama list
```

Hermes should be configured to use Ollama locally:

```bash
hermes config set model.provider custom
hermes config set model.base_url http://127.0.0.1:11434/v1
hermes config set model.api_key ollama
hermes config set model.api_mode chat_completions
hermes config set model.default qwen3.6:35b
```

The bundled Hermes script writes:

```bash
config/hermes_agent.local.env
```

with model settings and local base URL.

Example override before running the script:

```bash
mkdir -p config
cat > config/hermes_agent.local.env <<'EOF'
OLLAMA_REASONING_MODEL=qwen3.6:35b
OLLAMA_CODER_MODEL=qwen3.6:35b
OLLAMA_VISION_MODEL=qwen3.6:35b
HERMES_AGENT_MODEL=qwen3.6:35b
HERMES_AGENT_CODER_MODEL=qwen3.6:35b
HERMES_AGENT_VISION_MODEL=qwen3.6:35b
HERMES_AGENT_BASE_URL=http://127.0.0.1:11434/v1
EOF
```

Then run:

```bash
HERMES_START_CLI=0 ./opencode/hermes_agent/install_and_start_hermes_cli.sh
```

## Web Search, Figma, GitHub, And Local-Only Ports

"Completely local" has two different meanings:

1. Local inference: prompts and model inference run on your DGX through Ollama. This is local.
2. External tools: web search, Figma, GitHub, npm package downloads, model downloads, and remote MCPs require outbound internet. These do not require public inbound ports, but they are not offline.

Safe local-only rule:

- Bind servers to `127.0.0.1`.
- Allow outbound HTTPS only when you intentionally use web search, Figma, GitHub, npm, Hugging Face, or installers.
- Do not bind ComfyUI/Ollama/Hermes to `0.0.0.0`.
- Do not port-forward `3008`, `11434`, or any agent console port unless you intentionally want another device to connect.

The `opencode/opencode.json` file has:

```text
figma remote MCP: https://mcp.figma.com/mcp
figma desktop MCP: http://127.0.0.1:3845/mcp, disabled
playwright local MCP through npx
animotion local MCP through npx
```

So Figma cloud is not local. Figma Desktop MCP on `127.0.0.1:3845` would be local to the desktop, but it is disabled in this config and still depends on Figma Desktop/login behavior.

GitHub access is outbound HTTPS or SSH. It does not expose your DGX unless you run a server or create a tunnel.

## No-Reinstall Startup Scripts

These scripts do not install packages, create venvs, pull models, or edit conda environments. They activate the `react` conda env first and then start local services.

Start only ComfyUI:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
./opencode/hermes_agent/start_comfyui_local.sh
```

Start only ComfyUI in the background:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
COMFY_BACKGROUND=1 ./opencode/hermes_agent/start_comfyui_local.sh
```

Start Ollama, ComfyUI, and Hermes:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
./opencode/hermes_agent/start_local_ai_stack.sh
```

If Hermes is installed inside a venv and not on `PATH`, pass the exact executable:

```bash
HERMES_CMD=/path/to/hermes ./opencode/hermes_agent/start_local_ai_stack.sh
```

Logs:

```text
logs/ollama.log
logs/comfyui.log
logs/hermes.log
```

The full-stack script activates `react` before starting anything. Hermes may still internally run from its installer-managed venv if `HERMES_CMD` points there. That is acceptable because Hermes talks to Ollama over HTTP and does not need to import ComfyUI's CUDA/Torch packages. Do not merge the Hermes venv into the ComfyUI conda env unless Hermes itself proves it cannot run otherwise.

## Recommended Startup Order

Terminal 1, start Ollama:

```bash
OLLAMA_HOST=127.0.0.1:11434 ollama serve
```

Terminal 2, start ComfyUI:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
conda activate react
cd ComfyUI
python main.py --listen 127.0.0.1 --port 3008
```

Terminal 3, start Hermes:

```bash
cd /home/saswata/web_dev/website_design/comfy_setup
hermes
```

Desktop, start Krita:

```bash
krita
```

Then in Krita AI Diffusion, connect to:

```text
http://127.0.0.1:3008
```

## Health Checks

Check ComfyUI:

```bash
curl http://127.0.0.1:3008/system_stats
```

Check Ollama:

```bash
curl http://127.0.0.1:11434/api/tags
```

Check listening ports:

```bash
ss -ltnp | grep -E '(:3008|:11434)'
```

Good local-only output should show `127.0.0.1:3008` and `127.0.0.1:11434`, not `0.0.0.0:3008` or `0.0.0.0:11434`.

Check CUDA in the ComfyUI Python:

```bash
python - <<'PY'
import torch
print(torch.__version__)
print(torch.cuda.is_available())
if torch.cuda.is_available():
    print(torch.cuda.get_device_name(0))
PY
```

## Troubleshooting

If Krita cannot connect:

- Confirm ComfyUI is running.
- Confirm `curl http://127.0.0.1:3008/system_stats` works from the same user session.
- Confirm Krita is pointed at `http://127.0.0.1:3008`.
- Restart Krita after plugin installation.
- Apply the `websockets` copy workaround if the plugin fails during import.

If Hermes fails to install:

- Check whether `hermes` exists with `command -v hermes`.
- If the installer downloaded an unsupported binary, the script needs a Hermes ARM64 install path or a source-based install path.
- Keep Ollama separate; Ollama can still run locally even if Hermes install fails.

If Ollama model pull fails:

- Run `ollama list`.
- Use a known installed model in `config/hermes_agent.local.env`.
- Re-run the Hermes script with `HERMES_PULL_MODELS=0` if `qwen3.6:35b` is already installed or you want to pull manually.

```bash
HERMES_PULL_MODELS=0 HERMES_START_CLI=0 ./opencode/hermes_agent/install_and_start_hermes_cli.sh
```

If a service is accidentally public:

```bash
ss -ltnp | grep -E '(:3008|:11434)'
```

Stop it and restart with `127.0.0.1`, not `0.0.0.0`.
