#!/usr/bin/env bash
set -euo pipefail

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$PACK_DIR/../.." && pwd)"
COMFYUI_DIR="${COMFYUI_DIR:-$ROOT_DIR/ComfyUI}"
COMFY_CONDA_ENV="${COMFY_CONDA_ENV:-react}"
COMFYUI_HOST="${COMFYUI_HOST:-127.0.0.1}"
COMFYUI_PORT="${COMFYUI_PORT:-3008}"
OLLAMA_HOST="${OLLAMA_HOST:-127.0.0.1:11434}"
HERMES_MODEL="${HERMES_MODEL:-qwen3.6:35b}"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
LOG_DIR="$ROOT_DIR/logs"
OLLAMA_LOG="$LOG_DIR/ollama.log"
COMFYUI_LOG="$LOG_DIR/comfyui.log"
HERMES_LOG="$LOG_DIR/hermes.log"

log() {
  printf '%s\n' "$1"
}

fail() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

load_conda() {
  have_cmd conda || fail "conda is not on PATH."
  local conda_base
  conda_base="$(conda info --base 2>/dev/null)" || fail "Could not resolve conda base."
  # shellcheck disable=SC1091
  source "$conda_base/etc/profile.d/conda.sh"
  conda activate "$COMFY_CONDA_ENV"
}

port_has_public_listener() {
  local port="$1"
  ss -ltnH 2>/dev/null | awk -v suffix=":$port" '
    $4 ~ suffix "$" && ($4 ~ /^0\.0\.0\.0:/ || $4 ~ /^\[::\]:/ || $4 ~ /^\*:/ || $4 ~ /^:::/) { found=1 }
    END { exit found ? 0 : 1 }
  '
}

http_ok() {
  local url="$1"
  curl --max-time 5 -fsS "$url" >/dev/null 2>&1
}

wait_for_url() {
  local label="$1"
  local url="$2"
  local seconds="${3:-60}"
  local i
  for i in $(seq 1 "$seconds"); do
    if http_ok "$url"; then
      log "[READY] $label is reachable: $url"
      return
    fi
    sleep 1
  done
  fail "$label did not become reachable at $url"
}

start_ollama() {
  local tags_url="http://$OLLAMA_HOST/api/tags"
  if http_ok "$tags_url"; then
    log "[INFO] Ollama is already reachable at $tags_url"
    return
  fi
  have_cmd ollama || fail "ollama is not on PATH."
  log "[SETUP] Starting Ollama local-only on $OLLAMA_HOST"
  log "[INFO] Writing Ollama log to: $OLLAMA_LOG"
  nohup env OLLAMA_HOST="$OLLAMA_HOST" ollama serve >>"$OLLAMA_LOG" 2>&1 &
  log "[INFO] Ollama PID: $!"
  wait_for_url "Ollama" "$tags_url" 60
}

start_comfyui() {
  local stats_url="http://$COMFYUI_HOST:$COMFYUI_PORT/system_stats"
  [[ -f "$COMFYUI_DIR/main.py" ]] || fail "ComfyUI main.py not found at $COMFYUI_DIR/main.py"
  if http_ok "$stats_url"; then
    log "[INFO] ComfyUI is already reachable at $stats_url"
    return
  fi
  log "[SETUP] Starting ComfyUI local-only on $COMFYUI_HOST:$COMFYUI_PORT"
  log "[INFO] Writing ComfyUI log to: $COMFYUI_LOG"
  (
    cd "$COMFYUI_DIR"
    nohup python main.py --listen "$COMFYUI_HOST" --port "$COMFYUI_PORT" >>"$COMFYUI_LOG" 2>&1 &
    log "[INFO] ComfyUI PID: $!"
  )
  wait_for_url "ComfyUI" "$stats_url" 90
}

resolve_hermes_cmd() {
  if [[ -n "${HERMES_CMD:-}" ]]; then
    if [[ -x "$HERMES_CMD" || -n "$(command -v "$HERMES_CMD" 2>/dev/null)" ]]; then
      printf '%s\n' "$HERMES_CMD"
      return
    fi
    fail "HERMES_CMD is set but is not executable/on PATH: $HERMES_CMD"
  fi
  if have_cmd hermes; then
    command -v hermes
    return
  fi
  fail "Hermes is not on PATH. Set HERMES_CMD=/exact/path/to/hermes and rerun."
}

prepare_hermes_memory() {
  local target="$HERMES_HOME/memories/agentic_art/hermes_agent"
  local prompt_file="$HERMES_HOME/memories/agentic_art/CLI_ONBOARDING_PROMPT.md"
  log "[SETUP] Syncing Hermes markdown pack to $target"
  mkdir -p "$target" "$HERMES_HOME/memories/agentic_art"
  cp -R "$PACK_DIR/." "$target/"
  cat >"$prompt_file" <<EOF_PROMPT
# Hermes CLI Onboarding Prompt

You are Hermes for the local DGX ComfyUI setup.

Before doing any task:

1. Read \`opencode/hermes_agent/README.md\`.
2. Read all \`COMMON_*.md\` files in the README load order.
3. Read \`commands/*.md\`, \`tools/*.md\`, \`state/README.md\`, \`plugins/*.md\`, and \`mcp/README.md\`.
4. Read all \`REPO_AGENTIC_ART_*.md\` files in the README load order.
5. Treat repo-specific files as higher priority than common files.
6. Use \`$HERMES_MODEL\` as the unified local model for reasoning, coding, and vision.
7. Use GLM-5.2 only for huge-context or project-wide reasoning after the GLM cost gate.
8. Keep background work visible through logs or explicit CLI status updates.
9. Respect local-only service binding: ComfyUI on 127.0.0.1:3008 and Ollama on 127.0.0.1:11434.

Start by confirming that you loaded the Hermes agent pack and are using \`$HERMES_MODEL\` locally.
EOF_PROMPT
}

start_hermes() {
  local hermes_cmd
  hermes_cmd="$(resolve_hermes_cmd)"
  export OLLAMA_REASONING_MODEL="$HERMES_MODEL"
  export OLLAMA_CODER_MODEL="$HERMES_MODEL"
  export OLLAMA_VISION_MODEL="$HERMES_MODEL"
  export HERMES_AGENT_MODEL="$HERMES_MODEL"
  export HERMES_AGENT_CODER_MODEL="$HERMES_MODEL"
  export HERMES_AGENT_VISION_MODEL="$HERMES_MODEL"
  export HERMES_AGENT_BASE_URL="http://$OLLAMA_HOST/v1"

  local prompt_file="$HERMES_HOME/memories/agentic_art/CLI_ONBOARDING_PROMPT.md"
  prepare_hermes_memory
  log "[READY] Starting Hermes from $ROOT_DIR"
  log "[INFO] Writing Hermes log to: $HERMES_LOG"
  log "[INFO] Unified local model: $HERMES_MODEL"
  log "[INFO] If Hermes does not load memory automatically, paste this:"
  log "Read $prompt_file and follow it before doing any task."
  log "Then read opencode/hermes_agent/README.md and the COMMON_*.md, commands/*.md, tools/*.md, state/README.md, plugins/*.md, mcp/README.md, and REPO_AGENTIC_ART_*.md files in the documented load order."
  cd "$ROOT_DIR"
  "$hermes_cmd" 2>&1 | tee -a "$HERMES_LOG"
}

main() {
  mkdir -p "$LOG_DIR"
  port_has_public_listener "11434" && fail "Port 11434 is already bound publicly. Stop it and restart on 127.0.0.1."
  port_has_public_listener "$COMFYUI_PORT" && fail "Port $COMFYUI_PORT is already bound publicly. Stop it and restart on 127.0.0.1."
  load_conda
  log "[INFO] Activated conda env: $COMFY_CONDA_ENV"
  start_ollama
  start_comfyui
  start_hermes
}

main "$@"
