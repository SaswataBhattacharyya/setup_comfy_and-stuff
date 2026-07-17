#!/usr/bin/env bash
set -euo pipefail

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$PACK_DIR/../.." && pwd)"
CONFIG_FILE="$ROOT_DIR/config/hermes_agent.env"
LOCAL_OVERRIDE_FILE="$ROOT_DIR/config/hermes_agent.local.env"

if [[ -f "$CONFIG_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_FILE"
fi
if [[ -f "$LOCAL_OVERRIDE_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$LOCAL_OVERRIDE_FILE"
fi

OLLAMA_REASONING_MODEL_EXPLICIT=0
[[ -n "${OLLAMA_REASONING_MODEL+x}" ]] && OLLAMA_REASONING_MODEL_EXPLICIT=1

HERMES_INSTALL_URL="${HERMES_INSTALL_URL:-https://hermes-agent.nousresearch.com/install.sh}"
HERMES_INSTALL_FALLBACK_URL="${HERMES_INSTALL_FALLBACK_URL:-https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh}"
OLLAMA_INSTALL_URL="${OLLAMA_INSTALL_URL:-https://ollama.com/install.sh}"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
HERMES_LOCAL_OLLAMA_BASE_URL="${HERMES_LOCAL_OLLAMA_BASE_URL:-http://127.0.0.1:11434/v1}"
HERMES_LOCAL_OLLAMA_API_KEY="${HERMES_LOCAL_OLLAMA_API_KEY:-ollama}"
HERMES_LOCAL_OLLAMA_API_MODE="${HERMES_LOCAL_OLLAMA_API_MODE:-chat_completions}"
OLLAMA_REASONING_MODEL="${OLLAMA_REASONING_MODEL:-qwen3.6:35b}"
OLLAMA_CODER_MODEL="${OLLAMA_CODER_MODEL:-$OLLAMA_REASONING_MODEL}"
OLLAMA_VISION_MODEL="${OLLAMA_VISION_MODEL:-$OLLAMA_REASONING_MODEL}"
HERMES_AGENT_MODEL="${HERMES_AGENT_MODEL:-$OLLAMA_REASONING_MODEL}"
HERMES_AGENT_CODER_MODEL="${HERMES_AGENT_CODER_MODEL:-$OLLAMA_REASONING_MODEL}"
HERMES_AGENT_VISION_MODEL="${HERMES_AGENT_VISION_MODEL:-$OLLAMA_REASONING_MODEL}"
HERMES_START_CLI="${HERMES_START_CLI:-1}"
HERMES_RUN_DOCTOR="${HERMES_RUN_DOCTOR:-1}"
HERMES_SKIP_OLLAMA_START="${HERMES_SKIP_OLLAMA_START:-0}"
HERMES_PULL_MODELS="${HERMES_PULL_MODELS:-1}"
HERMES_PROMPT_MODELS="${HERMES_PROMPT_MODELS:-1}"

log() {
  printf '%s\n' "$1"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

require_cmd() {
  if ! have_cmd "$1"; then
    printf '[ERROR] %s is required.\n' "$1" >&2
    exit 1
  fi
}

install_hermes() {
  if have_cmd hermes; then
    log "[INFO] hermes command is already installed."
    hermes --version || true
    return
  fi

  log "[SETUP] Installing Hermes Agent CLI"
  if curl -fsSL "$HERMES_INSTALL_URL" | bash -s -- --skip-setup; then
    return
  fi

  log "[WARN] Primary Hermes installer failed. Trying fallback installer."
  curl -fsSL "$HERMES_INSTALL_FALLBACK_URL" | bash -s -- --skip-setup
}

install_ollama() {
  if have_cmd ollama; then
    log "[INFO] ollama command is already installed."
    ollama --version || true
    return
  fi

  log "[SETUP] Installing Ollama for local Qwen models"
  curl -fsSL "$OLLAMA_INSTALL_URL" | sh
}

ensure_local_bin_path() {
  export PATH="$HOME/.local/bin:$PATH"
}

start_ollama_if_needed() {
  if [[ "$HERMES_SKIP_OLLAMA_START" == "1" ]]; then
    log "[INFO] Skipping Ollama startup because HERMES_SKIP_OLLAMA_START=1."
    return
  fi
  if ! have_cmd ollama; then
    log "[WARN] Ollama is not installed. Hermes is configured for local Ollama, so install/start Ollama before model use."
    return
  fi
  if curl --max-time 5 -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
    log "[INFO] Ollama is already reachable at http://127.0.0.1:11434."
    return
  fi

  log "[SETUP] Starting Ollama in background. Log: /tmp/hermes-agentic-art-ollama.log"
  (
    cd /tmp
    nohup ollama serve >/tmp/hermes-agentic-art-ollama.log 2>&1 &
  )

  for _ in $(seq 1 45); do
    if curl --max-time 5 -fsS http://127.0.0.1:11434/api/tags >/dev/null 2>&1; then
      log "[INFO] Ollama API is reachable."
      return
    fi
    sleep 1
  done

  log "[WARN] Ollama did not become reachable. Inspect /tmp/hermes-agentic-art-ollama.log."
}

select_reasoning_model() {
  if [[ "${OLLAMA_REASONING_MODEL_EXPLICIT:-0}" == "1" ]]; then
    printf '%s\n' "$OLLAMA_REASONING_MODEL"
    return
  fi
  if [[ "$HERMES_PROMPT_MODELS" != "1" || ! -t 0 ]]; then
    printf '%s\n' "$OLLAMA_REASONING_MODEL"
    return
  fi

  printf '\nSelect Hermes unified local model:\n' >&2
  printf '  1) qwen3.6:35b (recommended single model for reasoning, coding, and vision)\n' >&2
  printf '  2) qwen3.6:27b (smaller fallback)\n' >&2
  printf '  3) gemma4:latest (fallback)\n' >&2
  printf '  4) gemma4:31b (larger fallback)\n' >&2
  printf '  5) hf.co/Jiunsong/supergemma4-26b-uncensored-gguf-v2:Q4_K_M\n' >&2
  read -r -p "Enter 1-5 [1]: " choice
  case "${choice:-1}" in
    2) printf '%s\n' "qwen3.6:27b" ;;
    3) printf '%s\n' "gemma4:latest" ;;
    4) printf '%s\n' "gemma4:31b" ;;
    5) printf '%s\n' "hf.co/Jiunsong/supergemma4-26b-uncensored-gguf-v2:Q4_K_M" ;;
    *) printf '%s\n' "qwen3.6:35b" ;;
  esac
}

select_models() {
  OLLAMA_REASONING_MODEL="$(select_reasoning_model)"
  OLLAMA_CODER_MODEL="$OLLAMA_REASONING_MODEL"
  OLLAMA_VISION_MODEL="$OLLAMA_REASONING_MODEL"
  HERMES_AGENT_MODEL="$OLLAMA_REASONING_MODEL"
  HERMES_AGENT_CODER_MODEL="$OLLAMA_REASONING_MODEL"
  HERMES_AGENT_VISION_MODEL="$OLLAMA_REASONING_MODEL"
  export OLLAMA_REASONING_MODEL OLLAMA_CODER_MODEL OLLAMA_VISION_MODEL
  export HERMES_AGENT_MODEL HERMES_AGENT_CODER_MODEL HERMES_AGENT_VISION_MODEL
}

pull_model_if_missing() {
  local model="$1"
  if [[ -z "$model" ]]; then
    return
  fi
  if ! have_cmd ollama; then
    log "[WARN] Cannot pull $model because ollama is unavailable."
    return
  fi
  if ollama show "$model" >/dev/null 2>&1; then
    log "[INFO] Ollama model already present: $model"
    return
  fi
  log "[SETUP] Pulling Ollama model: $model"
  ollama pull "$model"
}

pull_selected_models() {
  if [[ "$HERMES_PULL_MODELS" != "1" ]]; then
    log "[INFO] Skipping model pulls because HERMES_PULL_MODELS=0."
    return
  fi
  local pulled_models=" "
  for model in "$OLLAMA_REASONING_MODEL" "$OLLAMA_CODER_MODEL" "$OLLAMA_VISION_MODEL"; do
    if [[ "$pulled_models" == *" $model "* ]]; then
      continue
    fi
    pull_model_if_missing "$model"
    pulled_models="$pulled_models$model "
  done
}

write_local_env() {
  local env_file="$ROOT_DIR/config/hermes_agent.local.env"
  mkdir -p "$ROOT_DIR/config"
  cat >"$env_file" <<EOF_ENV
OLLAMA_REASONING_MODEL=$OLLAMA_REASONING_MODEL
OLLAMA_CODER_MODEL=$OLLAMA_CODER_MODEL
OLLAMA_VISION_MODEL=$OLLAMA_VISION_MODEL
HERMES_AGENT_MODEL=$HERMES_AGENT_MODEL
HERMES_AGENT_CODER_MODEL=$HERMES_AGENT_CODER_MODEL
HERMES_AGENT_VISION_MODEL=$HERMES_AGENT_VISION_MODEL
HERMES_AGENT_BASE_URL=$HERMES_LOCAL_OLLAMA_BASE_URL
EOF_ENV
  log "[INFO] Wrote local Hermes model config: $env_file"
}

configure_hermes_qwen() {
  if ! have_cmd hermes; then
    log "[WARN] hermes command is unavailable; cannot configure CLI."
    return
  fi

  log "[SETUP] Configuring Hermes CLI for local Qwen via Ollama"
  log "[INFO] Endpoint: $HERMES_LOCAL_OLLAMA_BASE_URL"
  log "[INFO] Unified reasoning/coding/vision model: $HERMES_AGENT_MODEL"

  hermes config set model.provider custom
  hermes config set model.default "$HERMES_AGENT_MODEL"
  hermes config set model.base_url "$HERMES_LOCAL_OLLAMA_BASE_URL"
  hermes config set model.api_key "$HERMES_LOCAL_OLLAMA_API_KEY"
  hermes config set model.api_mode "$HERMES_LOCAL_OLLAMA_API_MODE"
}

sync_hermes_pack() {
  local target="$HERMES_HOME/memories/agentic_art/hermes_agent"
  log "[SETUP] Syncing Hermes agent pack to $target"
  mkdir -p "$target"
  cp -R "$PACK_DIR/." "$target/"

  mkdir -p "$HERMES_HOME/memories/agentic_art"
  if [[ -d "$ROOT_DIR/hermes" ]]; then
    find "$ROOT_DIR/hermes" -maxdepth 1 -type f -name '*.md' -print0 | while IFS= read -r -d '' doc_path; do
      cp "$doc_path" "$HERMES_HOME/memories/agentic_art/$(basename "$doc_path")"
    done
  fi
}

write_onboarding_prompt() {
  local prompt_file="$HERMES_HOME/memories/agentic_art/CLI_ONBOARDING_PROMPT.md"
  cat >"$prompt_file" <<EOF_PROMPT
# Hermes CLI Onboarding Prompt

You are Hermes for Agentic Art Bare Minimum.

Before doing any task:

1. Read \`opencode/hermes_agent/README.md\`.
2. Read all \`COMMON_*.md\` files in the README load order.
3. Read \`commands/*.md\`, \`tools/*.md\`, \`state/README.md\`, \`plugins/*.md\`, and \`mcp/README.md\`.
4. Read all \`REPO_AGENTIC_ART_*.md\` files in the README load order.
5. Treat the repo-specific files as higher priority than common files.
6. Use one local Qwen model by default for reasoning, coding, and vision:
   - unified/default: \`$HERMES_AGENT_MODEL\`
   - compatibility coder alias: \`$HERMES_AGENT_CODER_MODEL\`
   - compatibility vision alias: \`$HERMES_AGENT_VISION_MODEL\`
7. Use Codex fallback only for huge-context or IDE-grade coding work after the Codex fallback gate.
8. Codex permission is session-scoped:
   - ask before first Codex fallback use
   - "allow once" applies only to the current request
   - "allow always for this session" applies only until this CLI process exits
   - after CLI restart, ask again
9. Keep background work visible through project logs, agent console notes, or explicit CLI status updates.
10. For this repo, respect the existing website/Hermes/ComfyUI/TTS flow and do not invent new runtime stages.

Start by confirming that you loaded the Hermes agent pack and are using one local Qwen model as default.
EOF_PROMPT

  log "[INFO] Wrote onboarding prompt: $prompt_file"
}

run_doctor() {
  if [[ "$HERMES_RUN_DOCTOR" != "1" ]]; then
    return
  fi
  if have_cmd hermes; then
    log "[SETUP] Running hermes doctor --fix"
    hermes doctor --fix || true
  fi
}

start_cli() {
  if [[ "$HERMES_START_CLI" != "1" ]]; then
    log "[READY] Hermes setup finished. HERMES_START_CLI=0, so CLI was not started."
    return
  fi

  local prompt_file="$HERMES_HOME/memories/agentic_art/CLI_ONBOARDING_PROMPT.md"
  log "[READY] Starting Hermes CLI from $ROOT_DIR"
  log "[INFO] Paste this onboarding instruction if Hermes does not load it automatically:"
  log "Read $prompt_file and follow it before doing any task."
  cd "$ROOT_DIR"
  exec hermes
}

main() {
  require_cmd curl
  ensure_local_bin_path
  install_ollama
  install_hermes
  select_models
  start_ollama_if_needed
  pull_selected_models
  write_local_env
  configure_hermes_qwen
  sync_hermes_pack
  write_onboarding_prompt
  run_doctor
  start_cli
}

main "$@"
