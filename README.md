# Comfy Setup For NVIDIA DGX Spark ARM64

This folder is a standalone ComfyUI/Krita AI/TTS setup kit. It is intentionally separate from the original repo. Upload this folder to git, clone it on the DGX Spark, then run the bootstrap there.

## What Is Included

- `bootstrap_dgx_comfy.sh`: one main installer.
- `dgx_doctor.sh`: hardware/runtime detector.
- `links.md`: active install manifest for models, custom nodes, and Krita AI plugin.
- `workflows/`: JSON-only copy of current workflows.
- `vendor/TTS-Audio-Suite-local/`: local TTS-Audio-Suite overlay preserving the current custom additions.
- `docs/source_kritaai_novita.md`: original Krita install notes for traceability.
- `docs/source_links_original.md`: original source `links.md`.

## Run On DGX Spark

```bash
cd comfy_setup
conda activate <your-comfy-env>
./dgx_doctor.sh | tee dgx_doctor_output.txt
./bootstrap_dgx_comfy.sh
```

The bootstrap will run the doctor again and save `dgx_doctor_output.txt`.

The bootstrap installs Python packages into the active conda environment. It does not create `ComfyUI/venv` unless you explicitly set:

```bash
COMFY_CREATE_VENV=1 ./bootstrap_dgx_comfy.sh
```

You can also bypass conda activation by setting:

```bash
COMFY_PYTHON=/path/to/python ./bootstrap_dgx_comfy.sh
```

## Important Torch Behavior

This installer is ARM64-specific and does not guess PyTorch CUDA wheels. If `torch.cuda.is_available()` is not true inside your active conda environment, the bootstrap stops. Send back `dgx_doctor_output.txt`; then the Torch block can be made exact for your DGX OS image.

## Active Link Rules

`links.md` is the source of truth:

- active `wget <url>` lines download model/plugin files
- active `git clone <repo>` lines clone custom nodes
- commented lines are ignored
- `## section` decides the ComfyUI model subfolder for following `wget` lines

## Krita AI

The bootstrap downloads the Krita AI Diffusion plugin zip and prepares plugin source/requirements. It does not force-install the Krita app itself. Install/import the plugin manually in Krita:

```text
Tools -> Scripts -> Import Python Plugin from File
```

Select the downloaded `krita_ai_diffusion-*.zip` from `downloads/`.

The default Krita AI plugin version is `1.52.1`. The bootstrap checks out the matching upstream source tag and runs Krita AI's model downloader with:

```bash
--recommended --backend auto
```

Override with `KRITA_AI_VERSION`, `KRITA_AI_MODEL_ARGS`, or set `KRITA_AI_SKIP_MODEL_DOWNLOAD=1` if you need to skip the Krita model download.

## TTS-Audio-Suite

The bootstrap clones the latest upstream TTS-Audio-Suite into ComfyUI custom nodes, runs upstream install if possible, then overlays the local bundled TTS files from `vendor/TTS-Audio-Suite-local`.

This keeps upstream freshness while preserving your timing/stitching/SRT/audio work.

Default overlay mode is selected files from `tts_overlay_include.txt`. If something is missing, rerun with:

```bash
TTS_OVERLAY_MODE=full ./bootstrap_dgx_comfy.sh
```
