#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMFYUI_DIR="${COMFYUI_DIR:-$ROOT_DIR/ComfyUI}"
COMFYUI_HOST="${COMFYUI_HOST:-127.0.0.1}"
COMFYUI_PORT="${COMFYUI_PORT:-3008}"
LINKS_FILE="${LINKS_FILE:-$ROOT_DIR/links.md}"
COMFY_CREATE_VENV="${COMFY_CREATE_VENV:-0}"
COMFY_PYTHON="${COMFY_PYTHON:-}"
KRITA_AI_VERSION="${KRITA_AI_VERSION:-1.52.1}"
KRITA_AI_MODEL_ARGS="${KRITA_AI_MODEL_ARGS:---recommended --backend auto}"
KRITA_AI_SKIP_MODEL_DOWNLOAD="${KRITA_AI_SKIP_MODEL_DOWNLOAD:-0}"
DOWNLOAD_DIR="$ROOT_DIR/downloads"
LOG_DIR="$ROOT_DIR/logs"
TTS_AUDIO_SUITE_DIRNAME="TTS-Audio-Suite"
TTS_AUDIO_SUITE_INSTALL_STAMP=".agentic_art_tts_audio_suite_installed"
TTS_AUDIO_SUITE_OLD_LOCAL_MARKER=".agentic_art_local_tts_audio_suite"
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
    nodejs \
    npm \
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

  if [[ -n "${CONDA_PREFIX:-}" ]]; then
    if [[ -x "$CONDA_PREFIX/bin/python" ]]; then
      COMFY_PYTHON="$CONDA_PREFIX/bin/python"
      return
    fi
    if [[ -x "$CONDA_PREFIX/bin/python3" ]]; then
      COMFY_PYTHON="$CONDA_PREFIX/bin/python3"
      return
    fi
    echo "[ERROR] Active conda env has no python executable under: $CONDA_PREFIX/bin" >&2
    echo "Install Python into the env first, for example:" >&2
    echo "  conda install -n $(basename "$CONDA_PREFIX") python pip" >&2
    exit 1
  fi

  if [[ "$COMFY_CREATE_VENV" == "1" ]]; then
    cd "$COMFYUI_DIR"
    if [[ ! -d venv ]]; then
      python3 -m venv venv
    fi
    COMFY_PYTHON="$COMFYUI_DIR/venv/bin/python"
    return
  fi

  echo "[ERROR] No active conda env found." >&2
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

is_tts_audio_suite_repo() {
  local repo="$1"
  local name
  name="$(repo_dirname "$repo")"
  [[ "$name" == "$TTS_AUDIO_SUITE_DIRNAME" ]]
}

install_custom_node_repo() {
  local repo="$1"
  local name
  local target
  name="$(repo_dirname "$repo")"
  target="$COMFYUI_DIR/custom_nodes/$name"
  if [[ -d "$target" ]]; then
    log "[INFO] Custom node exists: $name"
    if [[ -d "$target/.git" ]]; then
      if git -C "$target" diff --quiet && git -C "$target" diff --cached --quiet; then
        log "[UPDATE] $name"
        git -C "$target" pull --ff-only || {
          log "[WARN] git pull failed for $name; continuing with existing checkout."
        }
      else
        log "[WARN] Custom node has local changes; skipping update: $name"
      fi
    else
      log "[WARN] Custom node is not a git checkout; skipping update: $name"
    fi
  else
    log "[CLONE] $repo"
    git clone "$repo" "$target"
  fi
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
      repo="${line#git clone }"
      if is_tts_audio_suite_repo "$repo"; then
        log "[INFO] Skipping manifest TTS-Audio-Suite clone; bundled local copy is installed separately."
      else
        install_custom_node_repo "$repo"
      fi
    fi
  done < "$LINKS_FILE"
}

install_krita_ai_plugin_source() {
  local zip_path
  local plugin_root
  local plugin_dir
  local source_dir
  local tmp_dir
  local constraints_file
  zip_path="$DOWNLOAD_DIR/krita_ai_diffusion-${KRITA_AI_VERSION}.zip"
  plugin_root="$ROOT_DIR/krita-ai-diffusion"
  plugin_dir="$plugin_root/plugin-v${KRITA_AI_VERSION}"
  source_dir="$plugin_root/source-v${KRITA_AI_VERSION}"

  if [[ ! -f "$zip_path" ]]; then
    log "[WARN] Krita AI plugin zip not found: $zip_path. links.md should download it."
    return
  fi

  mkdir -p "$plugin_root" "$plugin_dir"
  if [[ ! -d "$plugin_dir/ai_diffusion" ]]; then
    tmp_dir="$(mktemp -d)"
    unzip -q "$zip_path" -d "$tmp_dir"
    cp -a "$tmp_dir/ai_diffusion" "$plugin_dir/"
    cp -a "$tmp_dir/ai_diffusion.desktop" "$plugin_dir/" 2>/dev/null || true
    rm -rf "$tmp_dir"
  fi

  if [[ ! -d "$source_dir/.git" ]]; then
    git clone --branch "v${KRITA_AI_VERSION}" --depth 1 https://github.com/Acly/krita-ai-diffusion.git "$source_dir"
  else
    git -C "$source_dir" fetch --depth 1 origin "v${KRITA_AI_VERSION}" || {
      log "[WARN] Could not fetch Krita AI tag v${KRITA_AI_VERSION}; using existing source checkout."
    }
    git -C "$source_dir" checkout -q "v${KRITA_AI_VERSION}" || {
      log "[WARN] Could not checkout Krita AI tag v${KRITA_AI_VERSION}; using existing source checkout."
    }
  fi

  if [[ -f "$source_dir/requirements.txt" ]]; then
    "$COMFY_PYTHON" -m pip install -r "$source_dir/requirements.txt" || {
      log "[WARN] Krita AI requirements failed; inspect ARM64 compatibility."
    }
  fi

  constraints_file="$LOG_DIR/shared_python_constraints.txt"
  cat > "$constraints_file" <<'EOF_CONSTRAINTS'
numpy>=2.1,<2.3
transformers>=4.51.3,<=4.57.3
EOF_CONSTRAINTS

  "$COMFY_PYTHON" -m pip install -c "$constraints_file" aiohttp tqdm accelerate gguf surrealist diffusers imageio-ffmpeg sageattention huggingface_hub || {
    log "[WARN] One or more Krita/Comfy extra Python packages failed; inspect ARM64 compatibility."
  }

  "$COMFY_PYTHON" -m pip install -c "$constraints_file" "rembg[cpu]" "rembg[gpu]" || {
    log "[WARN] rembg install failed under shared NumPy constraints; leaving NumPy/Transformers pinned for old TTS compatibility."
  }

  if [[ "$KRITA_AI_SKIP_MODEL_DOWNLOAD" == "1" ]]; then
    log "[INFO] Skipping Krita AI model download because KRITA_AI_SKIP_MODEL_DOWNLOAD=1."
  elif [[ -f "$source_dir/scripts/download_models.py" ]]; then
    log "[DOWNLOAD] Krita AI models: $KRITA_AI_MODEL_ARGS"
    # shellcheck disable=SC2086
    "$COMFY_PYTHON" "$source_dir/scripts/download_models.py" "$COMFYUI_DIR" $KRITA_AI_MODEL_ARGS
  else
    log "[WARN] Krita AI download_models.py not found in $source_dir/scripts."
  fi
}

install_local_tts_audio_suite() {
  local target="$COMFYUI_DIR/custom_nodes/$TTS_AUDIO_SUITE_DIRNAME"
  local source="$ROOT_DIR/vendor/TTS-Audio-Suite-local"
  local backup

  if [[ ! -d "$source" ]]; then
    echo "[ERROR] Bundled local TTS-Audio-Suite is missing: $source" >&2
    exit 1
  fi

  if [[ -d "$target" && ! -f "$target/$TTS_AUDIO_SUITE_INSTALL_STAMP" && ! -f "$target/$TTS_AUDIO_SUITE_OLD_LOCAL_MARKER" ]]; then
    backup="${target}.backup.$(date +%Y%m%d-%H%M%S)"
    log "[WARN] Existing TTS-Audio-Suite is not the bundled local install; moving to $backup"
    mv "$target" "$backup"
  fi

  mkdir -p "$COMFYUI_DIR/custom_nodes"
  log "[INFO] Installing bundled local TTS-Audio-Suite into ComfyUI/custom_nodes"
  rsync -a --delete \
    --exclude='.git' \
    --exclude='.codex' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.cache' \
    --exclude='data/cache' \
    --exclude='data/downloads' \
    "$source/" "$target/"

  if [[ -f "$target/install.py" ]]; then
    (cd "$target" && "$COMFY_PYTHON" install.py) || {
      log "[WARN] TTS-Audio-Suite install.py failed; inspect ARM64 compatibility."
    }
  fi

  local step_audio_model_dir="$COMFYUI_DIR/models/TTS/step_audio_editx/Step-Audio-EditX"
  if [[ -d "$step_audio_model_dir" ]]; then
    log "[INFO] Step Audio EditX model already present."
  elif [[ -f "$target/engines/step_audio_editx/step_audio_editx_downloader.py" ]]; then
    log "[DOWNLOAD] Step Audio EditX model"
    (cd "$target" && PYTHONPATH="$COMFYUI_DIR:$target${PYTHONPATH:+:$PYTHONPATH}" \
      "$COMFY_PYTHON" -m engines.step_audio_editx.step_audio_editx_downloader Step-Audio-EditX) || {
        log "[WARN] Step Audio EditX model download failed; rerun after checking network/model access."
      }
  fi

  printf 'installed\n' > "$target/$TTS_AUDIO_SUITE_INSTALL_STAMP"
  rm -f "$target/$TTS_AUDIO_SUITE_OLD_LOCAL_MARKER"
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
  install_local_tts_audio_suite
  copy_workflows
  print_finish
}

main "$@"
