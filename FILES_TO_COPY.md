# Files And Folders Included For DGX

Upload the whole `comfy_setup/` folder to git, except ignored generated files.

## Included

- `bootstrap_dgx_comfy.sh`: main ARM64 installer.
- `dgx_doctor.sh`: system/GPU/Python/Torch checker.
- `links.md`: active manifest for custom nodes, models, and Krita AI plugin zip.
- `workflows/`: JSON-only workflow copy from the source repo.
- `vendor/TTS-Audio-Suite-local/`: bundled local TTS-Audio-Suite copy preserving custom timing/stitching/SRT/audio work.
- `tts_overlay_include.txt`: obsolete overlay reference kept only for traceability.
- `docs/source_kritaai_novita.md`: original Krita AI notes.
- `docs/source_links_original.md`: original source `links.md`.
- `.gitignore`: prevents ComfyUI clone, models, downloaded zips, venvs, logs, and media outputs from being committed.

## Not Included

- Current local `ComfyUI/` checkout. Bootstrap clones fresh upstream ComfyUI.
- Model binaries. Bootstrap downloads active `wget` entries from `links.md`.
- Hermes files. Hermes will be handled separately.
- Website/backend files. This setup is only ComfyUI/Krita/TTS.
- Generated assets, outputs, caches, and venvs.

## First DGX Feedback File

If bootstrap stops at Torch/CUDA, send back:

```text
comfy_setup/dgx_doctor_output.txt
```

That file contains the architecture, OS, NVIDIA driver/CUDA, Python, and Torch CUDA status needed to make the Torch install block exact for the DGX image.

## Python Environment

Activate your conda environment before running:

```bash
conda activate <your-comfy-env>
./bootstrap_dgx_comfy.sh
```

The installer uses that conda Python for ComfyUI, custom nodes, Krita AI Python packages, and TTS-Audio-Suite. It creates `ComfyUI/venv` only if you explicitly run with `COMFY_CREATE_VENV=1`.
