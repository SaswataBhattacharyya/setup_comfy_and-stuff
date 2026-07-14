#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMFYUI_DIR="${COMFYUI_DIR:-$ROOT_DIR/ComfyUI}"
COMFYUI_HOST="${COMFYUI_HOST:-127.0.0.1}"
COMFYUI_PORT="${COMFYUI_PORT:-3008}"
LINKS_FILE="${LINKS_FILE:-$ROOT_DIR/links.md}"
COMFY_CREATE_VENV="${COMFY_CREATE_VENV:-0}"
COMFY_PYTHON="${COMFY_PYTHON:-}"
DOWNLOAD_DIR="$ROOT_DIR/downloads"
LOG_DIR="$ROOT_DIR/logs"
DEBIAN_FRONTEND=noninteractive
APT_PREFIX=()

log() {
  echo "$1"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

configure_privilege_mode() {
  if [[ "${EUID}" -eq 0 ]]; then
    APT_PREFIX=()
  elif have_cmd sudo; then
    APT_PREFIX=(sudo)
  else
    echo "[ERROR] Need root or sudo for apt packages." >&2
    exit 1
  fi
}

apt_get() {
  "${APT_PREFIX[@]}" apt-get "$@"
}

require_arm64() {
  if [[ "$(uname -m)" != "aarch64" ]]; then
    echo "[ERROR] This setup targets ARM64/aarch64 DGX Spark. Found: $(uname -m)" >&2
    echo "Set ALLOW_NON_ARM64=1 only for local dry-run testing." >&2
    [[ "${ALLOW_NON_ARM64:-0}" == "1" ]] || exit 1
  fi
}

ensure_base_packages() {
  apt_get update
  apt_get install -y \
    ca-certificates \
    curl \
    ffmpeg \
    git \
    gnupg \
    libgl1 \
    libglib2.0-0 \
    libsamplerate0-dev \
    libsm6 \
    libxext6 \
    libxrender1 \
    lsof \
    nano \
    pciutils \
    portaudio19-dev \
    psmisc \
    python3-pip \
    python3-venv \
    rsync \
    tesseract-ocr \
    unzip \
    wget
}

ensure_nvidia() {
  if ! have_cmd nvidia-smi; then
    echo "[ERROR] nvidia-smi is unavailable. Install/repair NVIDIA driver before continuing." >&2
    exit 1
  fi
  nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader
}

ensure_comfyui_checkout() {
  mkdir -p "$(dirname "$COMFYUI_DIR")"
  if [[ -f "$COMFYUI_DIR/main.py" ]]; then
    log "[INFO] ComfyUI already present: $COMFYUI_DIR"
    return
  fi
  if [[ -e "$COMFYUI_DIR" && -n "$(find "$COMFYUI_DIR" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
    echo "[ERROR] COMFYUI_DIR exists but is not a valid ComfyUI checkout: $COMFYUI_DIR" >&2
    exit 1
  fi
  git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFYUI_DIR"
}

resolve_python_runtime() {
  if [[ -n "$COMFY_PYTHON" ]]; then
    if [[ ! -x "$COMFY_PYTHON" ]]; then
      echo "[ERROR] COMFY_PYTHON is set but not executable: $COMFY_PYTHON" >&2
      exit 1
    fi
    return
  fi

  if [[ -n "${CONDA_PREFIX:-}" && -x "$CONDA_PREFIX/bin/python" ]]; then
    COMFY_PYTHON="$CONDA_PREFIX/bin/python"
    return
  fi

  if [[ "$COMFY_CREATE_VENV" == "1" ]]; then
    cd "$COMFYUI_DIR"
    if [[ ! -d venv ]]; then
      python3 -m venv venv
    fi
    COMFY_PYTHON="$COMFYUI_DIR/venv/bin/python"
    return
  fi

  echo "[ERROR] No active conda Python found." >&2
  echo "Activate your conda env first, then rerun:" >&2
  echo "  conda activate <your-env>" >&2
  echo "  ./bootstrap_dgx_comfy.sh" >&2
  echo "Or set COMFY_PYTHON=/path/to/python." >&2
  echo "If you explicitly want a local venv, set COMFY_CREATE_VENV=1." >&2
  exit 1
}

ensure_python_requirements() {
  cd "$COMFYUI_DIR"
  resolve_python_runtime
  log "[INFO] Using Python runtime: $COMFY_PYTHON"
  "$COMFY_PYTHON" -m pip install --upgrade pip

  if "$COMFY_PYTHON" - <<'PY'
try:
    import torch
    raise SystemExit(0 if torch.cuda.is_available() else 1)
except Exception:
    raise SystemExit(1)
PY
  then
    log "[INFO] Torch CUDA is available in selected Python runtime."
  else
    echo "[ERROR] Torch CUDA is not available in selected Python runtime: $COMFY_PYTHON" >&2
    echo "This ARM64 installer does not guess PyTorch CUDA wheels." >&2
    echo "Run ./dgx_doctor.sh | tee dgx_doctor_output.txt and use the output to choose the DGX-supported Torch install path." >&2
    echo "After installing a working CUDA Torch in your conda env, rerun this bootstrap." >&2
    exit 1
  fi

  "$COMFY_PYTHON" -m pip install -r requirements.txt
}

section_to_dir() {
  case "$1" in
    checkpoints) echo "checkpoints" ;;
    unet) echo "unet" ;;
    diffusion_models) echo "diffusion_models" ;;
    text_encoders) echo "text_encoders" ;;
    vae) echo "vae" ;;
    clip_vision) echo "clip_vision" ;;
    controlnet) echo "controlnet" ;;
    dwpose) echo "dwpose" ;;
    loras) echo "loras" ;;
    latent_upscale_models) echo "latent_upscale_models" ;;
    upscale_models) echo "upscale_models" ;;
    other_models) echo "other_models" ;;
    detection) echo "detection" ;;
    krita_ai_plugin) echo "" ;;
    *) echo "" ;;
  esac
}

is_known_section() {
  local section="$1"
  if [[ "$section" == "notes" || "$section" == "krita_ai_plugin" ]]; then
    return 0
  fi
  [[ -n "$(section_to_dir "$section")" ]]
}

download_file() {
  local section="$1"
  local url="$2"
  local model_dir
  local target_dir
  local filename
  filename="$(basename "${url%%\?*}")"
  model_dir="$(section_to_dir "$section")"
  if [[ "$section" == "krita_ai_plugin" ]]; then
    target_dir="$DOWNLOAD_DIR"
  elif [[ -n "$model_dir" ]]; then
    target_dir="$COMFYUI_DIR/models/$model_dir"
  else
    log "[WARN] Skipping wget in unknown section '$section': $url"
    return
  fi
  mkdir -p "$target_dir"
  if [[ -f "$target_dir/$filename" ]]; then
    log "[INFO] Already downloaded: $target_dir/$filename"
    return
  fi
  log "[DOWNLOAD] $filename -> $target_dir"
  rm -f "$target_dir/$filename.partial"
  wget -O "$target_dir/$filename.partial" "$url"
  mv "$target_dir/$filename.partial" "$target_dir/$filename"
}

repo_dirname() {
  local repo="$1"
  local name
  name="${repo%/}"
  name="${name##*/}"
  name="${name%.git}"
  echo "$name"
}

install_custom_node_repo() {
  local repo="$1"
  local name
  local target
  name="$(repo_dirname "$repo")"
  target="$COMFYUI_DIR/custom_nodes/$name"
  if [[ -d "$target" ]]; then
    log "[INFO] Custom node exists: $name"
    return
  fi
  log "[CLONE] $repo"
  git clone "$repo" "$target"
  if [[ -f "$target/requirements.txt" ]]; then
    "$COMFY_PYTHON" -m pip install -r "$target/requirements.txt" || {
      log "[WARN] requirements install failed for $name; inspect ARM64 compatibility."
    }
  fi
}

parse_links_manifest() {
  local current_section=""
  local candidate_section=""
  while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
    line="${raw_line#"${raw_line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue
    if [[ "$line" == "## "* ]]; then
      candidate_section="${line#\#\# }"
      candidate_section="${candidate_section,,}"
      if is_known_section "$candidate_section"; then
        current_section="$candidate_section"
      fi
      continue
    fi
    [[ "$line" == \#* ]] && continue
    if [[ "$line" == wget\ * ]]; then
      download_file "$current_section" "${line#wget }"
    elif [[ "$line" == git\ clone\ * ]]; then
      install_custom_node_repo "${line#git clone }"
    fi
  done < "$LINKS_FILE"
}

install_krita_ai_plugin_source() {
  local zip_path
  zip_path="$(find "$DOWNLOAD_DIR" -maxdepth 1 -type f -name 'krita_ai_diffusion-*.zip' | sort | tail -n 1 || true)"
  if [[ -z "$zip_path" ]]; then
    log "[WARN] Krita AI plugin zip not found in $DOWNLOAD_DIR. links.md should download it."
    return
  fi

  mkdir -p "$ROOT_DIR/krita-ai-diffusion"
  if [[ ! -d "$ROOT_DIR/krita-ai-diffusion/ai_diffusion" ]]; then
    local tmp_dir
    tmp_dir="$(mktemp -d)"
    unzip -q "$zip_path" -d "$tmp_dir"
    cp -a "$tmp_dir/ai_diffusion" "$ROOT_DIR/krita-ai-diffusion/"
    cp -a "$tmp_dir/ai_diffusion.desktop" "$ROOT_DIR/krita-ai-diffusion/" 2>/dev/null || true
  fi

  if [[ ! -d "$ROOT_DIR/krita-ai-diffusion/krita-ai-diffusion" ]]; then
    git clone https://github.com/Acly/krita-ai-diffusion.git "$ROOT_DIR/krita-ai-diffusion/krita-ai-diffusion"
  fi

  if [[ -f "$ROOT_DIR/krita-ai-diffusion/krita-ai-diffusion/requirements.txt" ]]; then
    "$COMFY_PYTHON" -m pip install -r "$ROOT_DIR/krita-ai-diffusion/krita-ai-diffusion/requirements.txt" || {
      log "[WARN] Krita AI requirements failed; inspect ARM64 compatibility."
    }
  fi

  "$COMFY_PYTHON" -m pip install aiohttp tqdm "rembg[cpu]" "rembg[gpu]" accelerate gguf surrealist diffusers imageio-ffmpeg sageattention huggingface_hub || {
    log "[WARN] One or more Krita/Comfy extra Python packages failed; inspect ARM64 compatibility."
  }

  if [[ -d "$ROOT_DIR/krita-ai-diffusion/krita-ai-diffusion/scripts" ]]; then
    cp -a "$ROOT_DIR/krita-ai-diffusion/krita-ai-diffusion/scripts" "$ROOT_DIR/krita-ai-diffusion/"
  fi
}

install_tts_audio_suite_overlay() {
  local target="$COMFYUI_DIR/custom_nodes/TTS-Audio-Suite"
  local overlay="$ROOT_DIR/vendor/TTS-Audio-Suite-local"
  if [[ ! -d "$target" ]]; then
    install_custom_node_repo "https://github.com/diodiogod/TTS-Audio-Suite.git"
  fi
  if [[ -f "$target/install.py" ]]; then
    (cd "$target" && "$COMFY_PYTHON" install.py) || {
      log "[WARN] TTS-Audio-Suite install.py failed; inspect ARM64 compatibility."
    }
  fi
  if [[ -d "$overlay" ]]; then
    mkdir -p "$target/.agentic_art_overlay_backup"
    if [[ "${TTS_OVERLAY_MODE:-selected}" == "full" ]]; then
      rsync -a \
        --exclude='.git' \
        --exclude='__pycache__' \
        --exclude='*.pyc' \
        --exclude='.cache' \
        --exclude='data/cache' \
        --exclude='data/downloads' \
        "$overlay/" "$target/"
    else
      while IFS= read -r overlay_path || [[ -n "$overlay_path" ]]; do
        overlay_path="${overlay_path#"${overlay_path%%[![:space:]]*}"}"
        overlay_path="${overlay_path%"${overlay_path##*[![:space:]]}"}"
        [[ -z "$overlay_path" || "$overlay_path" == \#* ]] && continue
        if [[ -e "$overlay/$overlay_path" ]]; then
          mkdir -p "$target/$(dirname "$overlay_path")"
          cp -a "$overlay/$overlay_path" "$target/$overlay_path"
        else
          log "[WARN] TTS overlay path missing locally: $overlay_path"
        fi
      done < "$ROOT_DIR/tts_overlay_include.txt"
    fi
    date -Is > "$target/.agentic_art_overlay_applied"
    log "[INFO] Applied local TTS-Audio-Suite overlay."
  fi
}

copy_workflows() {
  mkdir -p "$COMFYUI_DIR/user/default/workflows"
  cp -a "$ROOT_DIR/workflows/." "$COMFYUI_DIR/user/default/workflows/"
}

print_finish() {
  cat <<EOF

[READY] ComfyUI setup steps finished.

Start ComfyUI:
  cd "$COMFYUI_DIR"
  "$COMFY_PYTHON" main.py --listen "$COMFYUI_HOST" --port "$COMFYUI_PORT"

Krita AI plugin:
  Downloaded plugin zip is in: $DOWNLOAD_DIR
  In Krita: Tools -> Scripts -> Import Python Plugin from File
  Select krita_ai_diffusion-*.zip.
  If needed, copy:
    ~/.local/share/krita/pykrita/ai_diffusion/websockets
  to:
    ~/.local/share/krita/pykrita/websockets

If bootstrap stopped at Torch CUDA:
  Send back comfy_setup/dgx_doctor_output.txt.
EOF
}

main() {
  mkdir -p "$DOWNLOAD_DIR" "$LOG_DIR"
  "$ROOT_DIR/dgx_doctor.sh" | tee "$ROOT_DIR/dgx_doctor_output.txt"
  require_arm64
  configure_privilege_mode
  ensure_base_packages
  ensure_nvidia
  ensure_comfyui_checkout
  ensure_python_requirements
  mkdir -p "$COMFYUI_DIR/custom_nodes"
  parse_links_manifest
  install_krita_ai_plugin_source
  install_tts_audio_suite_overlay
  copy_workflows
  print_finish
}

main "$@"
