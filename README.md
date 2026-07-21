# Comfy Setup For NVIDIA DGX Spark ARM64

This folder is a standalone ComfyUI/Krita AI/TTS setup kit. It is intentionally separate from the original repo. Upload this folder to git, clone it on the DGX Spark, then run the bootstrap there.

## What Is Included

- `bootstrap_dgx_comfy.sh`: one main installer.
- `dgx_doctor.sh`: hardware/runtime detector.
- `links.md`: active install manifest for models, custom nodes, and Krita AI plugin.
- `workflows/`: JSON-only copy of current workflows.
- `vendor/TTS-Audio-Suite-local/`: bundled local TTS-Audio-Suite copy preserving the current custom additions.
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

The bootstrap installs required system tools with `apt`, including `ffmpeg`, `git`, `curl`, `wget`, `unzip`, `nodejs`, and `npm`.

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

The bootstrap downloads the Krita AI Diffusion plugin zip and prepares plugin source/requirements. It does not force-install the Krita app itself. Install Krita system-wide, for example with `apt`, then import the plugin manually in Krita:

```text
Tools -> Scripts -> Import Python Plugin from File
```

Select the downloaded `krita_ai_diffusion-*.zip` from `downloads/`.

The default Krita AI plugin version is `1.52.1`. The bootstrap checks out the matching upstream source tag and runs Krita AI's model downloader with:

```bash
--recommended --backend auto
```

Override with `KRITA_AI_VERSION`, `KRITA_AI_MODEL_ARGS`, or set `KRITA_AI_SKIP_MODEL_DOWNLOAD=1` if you need to skip the Krita model download.

Keep the ComfyUI Python environment isolated. Do not copy Python packages from another conda env such as `base` into the active Comfy env; the bootstrap installs ComfyUI, Krita AI, and custom-node Python requirements into the selected `COMFY_PYTHON` runtime. Large model downloads are skipped when the target file already exists.

## TTS-Audio-Suite

The bootstrap installs the bundled local TTS-Audio-Suite from `vendor/TTS-Audio-Suite-local` directly into `ComfyUI/custom_nodes/TTS-Audio-Suite`.

It does not clone latest upstream TTS-Audio-Suite. This keeps the older dependency profile and preserves your timing/stitching/SRT/audio work.

If an existing `ComfyUI/custom_nodes/TTS-Audio-Suite` folder is present and was not installed by this bootstrap, it is moved to a timestamped backup before the bundled local copy is installed.
