#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMFYUI_DIR="${COMFYUI_DIR:-$ROOT_DIR/ComfyUI}"
COMFY_PYTHON="${COMFY_PYTHON:-}"

print_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "$cmd: $(command -v "$cmd")"
    case "$cmd" in
      python3) python3 --version || true ;;
      pip3) pip3 --version || true ;;
      node) node --version || true ;;
      npm) npm --version || true ;;
      git) git --version || true ;;
      ffmpeg) ffmpeg -version | sed -n '1p' || true ;;
      nvidia-smi) nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader || true ;;
      nvcc) nvcc --version | tail -n 1 || true ;;
      krita) krita --version || true ;;
    esac
  else
    echo "$cmd: MISSING"
  fi
}

echo "DGX ComfyUI setup doctor"
echo "========================"
echo "date: $(date -Is)"
echo "root: $ROOT_DIR"
echo "comfyui_dir: $COMFYUI_DIR"
echo "conda_prefix: ${CONDA_PREFIX:-<none>}"
echo "arch: $(uname -m)"
echo "kernel: $(uname -sr)"
echo

if [[ -f /etc/os-release ]]; then
  echo "OS:"
  sed -n '1,12p' /etc/os-release
  echo
fi

echo "Commands:"
for cmd in python3 pip3 git curl wget unzip ffmpeg nvidia-smi nvcc node npm krita; do
  print_cmd "$cmd"
done
echo

echo "NVIDIA:"
if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi || true
else
  echo "nvidia-smi unavailable"
fi
echo

echo "Python torch check from system python:"
python3 - <<'PY' || true
try:
    import torch
    print("torch:", torch.__version__)
    print("cuda_available:", torch.cuda.is_available())
    if torch.cuda.is_available():
        print("device:", torch.cuda.get_device_name(0))
except Exception as exc:
    print("torch_import_failed:", repr(exc))
PY
echo

if [[ -z "$COMFY_PYTHON" && -n "${CONDA_PREFIX:-}" ]]; then
  if [[ -x "$CONDA_PREFIX/bin/python" ]]; then
    COMFY_PYTHON="$CONDA_PREFIX/bin/python"
  elif [[ -x "$CONDA_PREFIX/bin/python3" ]]; then
    COMFY_PYTHON="$CONDA_PREFIX/bin/python3"
  fi
fi

if [[ -n "$COMFY_PYTHON" && -x "$COMFY_PYTHON" ]]; then
  echo "Python torch check from selected runtime:"
  echo "python: $COMFY_PYTHON"
  "$COMFY_PYTHON" - <<'PY' || true
try:
    import torch
    print("torch:", torch.__version__)
    print("cuda_available:", torch.cuda.is_available())
    if torch.cuda.is_available():
        print("device:", torch.cuda.get_device_name(0))
except Exception as exc:
    print("torch_import_failed:", repr(exc))
PY
  echo
fi

if [[ -x "$COMFYUI_DIR/venv/bin/python" ]]; then
  echo "Python torch check from ComfyUI venv:"
  "$COMFYUI_DIR/venv/bin/python" - <<'PY' || true
try:
    import torch
    print("torch:", torch.__version__)
    print("cuda_available:", torch.cuda.is_available())
    if torch.cuda.is_available():
        print("device:", torch.cuda.get_device_name(0))
except Exception as exc:
    print("torch_import_failed:", repr(exc))
PY
else
  echo "ComfyUI venv missing: $COMFYUI_DIR/venv"
fi
echo

echo "Disk:"
df -h "$ROOT_DIR" || true
