#!/usr/bin/env bash
set -euo pipefail

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$PACK_DIR/../.." && pwd)"
COMFYUI_DIR="${COMFYUI_DIR:-$ROOT_DIR/ComfyUI}"
COMFY_CONDA_ENV="${COMFY_CONDA_ENV:-react}"
COMFYUI_HOST="${COMFYUI_HOST:-127.0.0.1}"
COMFYUI_PORT="${COMFYUI_PORT:-3008}"
LOG_DIR="$ROOT_DIR/logs"
COMFYUI_LOG="$LOG_DIR/comfyui.log"

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

main() {
  mkdir -p "$LOG_DIR"
  [[ -f "$COMFYUI_DIR/main.py" ]] || fail "ComfyUI main.py not found at $COMFYUI_DIR/main.py"
  port_has_public_listener "$COMFYUI_PORT" && fail "Port $COMFYUI_PORT is already bound publicly. Stop it and restart on 127.0.0.1."

  if http_ok "http://$COMFYUI_HOST:$COMFYUI_PORT/system_stats"; then
    log "[READY] ComfyUI is already reachable at http://$COMFYUI_HOST:$COMFYUI_PORT"
    exit 0
  fi

  load_conda
  log "[INFO] Activated conda env: $COMFY_CONDA_ENV"
  log "[INFO] Writing ComfyUI log to: $COMFYUI_LOG"

  cd "$COMFYUI_DIR"
  if [[ "${COMFY_BACKGROUND:-0}" == "1" ]]; then
    nohup python main.py --listen "$COMFYUI_HOST" --port "$COMFYUI_PORT" >>"$COMFYUI_LOG" 2>&1 &
    log "[READY] Started ComfyUI in background on http://$COMFYUI_HOST:$COMFYUI_PORT"
    log "[INFO] PID: $!"
  else
    log "[READY] Starting ComfyUI on http://$COMFYUI_HOST:$COMFYUI_PORT"
    python main.py --listen "$COMFYUI_HOST" --port "$COMFYUI_PORT" 2>&1 | tee -a "$COMFYUI_LOG"
  fi
}

main "$@"
