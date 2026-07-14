
download zip file for plugin - 
wget https://github.com/Acly/krita-ai-diffusion/releases/download/v1.46.1/krita_ai_diffusion-1.46.1.zip

Tools --> Scripts --> Plugin .. python file --> direct it to this zip file


Open your File Manager and go to: ~/.local/share/krita/pykrita/ai_diffusion/

Find the folder named websockets inside it.

Copy that websockets folder.

Go back one level to: ~/.local/share/krita/pykrita/

Paste the folder here.


ssh with the runpod

port 8888, 3008, 3002

# For network volume added-
mkdir workspace
mv ComfyUI workspace/ComfyUI
# Move the folder to the permanent Network Volume
mv /root/workspace /network/

# Create the "Shortcut" (Link)
ln -s /network/workspace /root/workspace

python -m venv venv
source venv/bin/activate

# git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
pip install -r requirements.txt

cd custom_nodes/

git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git
git clone https://github.com/Acly/comfyui-inpaint-nodes.git
git clone https://github.com/Acly/comfyui-tooling-nodes.git
git clone https://github.com/kijai/ComfyUI-WanVideoWrapper
git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess
git clone https://github.com/stduhpf/ComfyUI-WanMoeKSampler
git clone https://github.com/pollockjj/ComfyUI-MultiGPU
git clone https://github.com/evanspearman/ComfyMath
git clone https://github.com/ltdrdata/was-node-suite-comfyui
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
git clone https://github.com/yolain/ComfyUI-Easy-Use
git clone https://github.com/kijai/ComfyUI-KJNodes
git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts
git clone https://github.com/city96/ComfyUI-GGUF
git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation
git clone https://github.com/Comfy-Org/ComfyUI-Manager
git clone https://github.com/kijai/ComfyUI-segment-anything-2.git
git clone https://github.com/un-seen/comfyui-tensorops.git
git clone https://github.com/diodiogod/TTS-Audio-Suite.git

cd comfyui_controlnet_aux/
pip install -r requirements.txt

cd ../ComfyUI-WanVideoWrapper/
pip install -r requirements.txt

cd ../comfyui-tensorops/
pip install -r requirements.txt

cd ../ComfyUI-GGUF/
pip install -r requirements.txt

cd ../ComfyUI-VideoHelperSuite
pip install -r requirements.txt

# we need to go back to cd workspace/
cd ../../../
apt update && apt install unzip -y
apt-get install -y wget
wget https://github.com/Acly/krita-ai-diffusion/releases/download/v1.46.1/krita_ai_diffusion-1.46.1.zip


unzip krita_ai_diffusion-1.46.1.zip
mkdir krita-ai-diffusion
cp -r ai_diffusion krita-ai-diffusion/
cp ai_diffusion.desktop krita-ai-diffusion/
rm -rf ai_diffusion
rm ai_diffusion.desktop krita_ai_diffusion-1.46.1.zip

cd krita-ai-diffusion/
git clone https://github.com/Acly/krita-ai-diffusion.git
cd krita-ai-diffusion/
pip install -r requirements.txt

python -m pip install aiohttp tqdm "rembg[cpu]" "rembg[gpu]" accelerate gguf surrealist diffusers imageio-ffmpeg sageattention huggingface_hub
cp -r scripts/ ../

cd ../scripts
python download_models.py /root/workspace/ComfyUI --all --flux --upscalers --controlnet

# When a different instance is started and you need to connect it-
# Re-create the link from the network volume to your home folder
ln -s /network/workspace /root/workspace

cd workspace/
source venv/bin/activate
# if template is pytorch 2.7 -->    apt-get update && apt-get install -y libgl1-mesa-glx libglib2.0-0 

pip uninstall -y onnxruntime onnxruntime-gpu
pip install onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/
supervisorctl stop comfyui
ps -ef | grep main.py
python ComfyUI/main.py --listen 0.0.0.0 --port 3008


# How to add workflow to krita - /home/saswata/.local/share/krita/ai_diffusion/workflows paste the workflows here

# For wan2.2 - few extra stuff
# https://huggingface.co/Kijai/WanVideo_comfy/tree/main --> Wan video all
# https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled --> Wan 2.2 all
# https://huggingface.co/QuantStack/Wan2.2-I2V-A14B-GGUF/tree/main/HighNoise
# https://huggingface.co/QuantStack/Wan2.2-I2V-A14B-GGUF/tree/main/HighNoise
# wget https://huggingface.co/lightx2v/Wan2.2-Lightning/tree/main

# https://www.patreon.com/posts/how-to-use-wan-2-140152605
cd ../../
cd ComfyUI/models/unet/

wget https://huggingface.co/QuantStack/Wan2.2-Animate-14B-GGUF/resolve/main/Wan2.2-Animate-14B-Q4_K_M.gguf
wget https://huggingface.co/QuantStack/Wan2.2-I2V-A14B-GGUF/resolve/main/HighNoise/Wan2.2-I2V-A14B-HighNoise-Q4_K_M.gguf
wget https://huggingface.co/QuantStack/Wan2.2-I2V-A14B-GGUF/resolve/main/LowNoise/Wan2.2-I2V-A14B-LowNoise-Q4_K_M.gguf

cd ../vae

wget https://huggingface.co/QuantStack/Wan2.2-T2V-A14B-GGUF/resolve/main/VAE/Wan2.1_VAE.safetensors
wget https://huggingface.co/QuantStack/Wan2.2-I2V-A14B-GGUF/blob/main/VAE/Wan2.1_VAE.safetensors
wget https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors
wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors

cd ../diffusion_models

wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_scaled_e5m2_KJ_v2.safetensors
wget https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors
wget https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
wget https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors

# more
wget https://huggingface.co/fal/Qwen-Image-Edit-2511-Multiple-Angles-LoRA/resolve/main/qwen-image-edit-2511-multiple-angles-lora.safetensors
wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_2512_bf16.safetensors
wget https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2511_bf16.safetensors

cd ../clip_vision/

wget https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors

cd ../text_encoders/

wget https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors
wget https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors

# more
wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors

cd ../loras/

wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22_relight/WanAnimate_relight_lora_fp16.safetensors
wget https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors
wget https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Canny-Control/resolve/main/ltx-2-19b-ic-lora-canny-control.safetensors
wget https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-distilled-lora-384.safetensors

# more
wget https://huggingface.co/lightx2v/Wan2.2-Lightning/blob/main/Wan2.2-I2V-A14B-4steps-lora-rank64-Seko-V1/high_noise_model.safetensors
wget https://huggingface.co/lightx2v/Wan2.2-Lightning/blob/main/Wan2.2-I2V-A14B-4steps-lora-rank64-Seko-V1/low_noise_model.safetensors
wget https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors
wget https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors
wget https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors
wget https://huggingface.co/lightx2v/Qwen-Image-Edit-2511-Lightning/resolve/main/Qwen-Image-Edit-2511-Lightning-4steps-V1.0-bf16.safetensors

cd ../checkpoints/

wget https://huggingface.co/Comfy-Org/hunyuan3D_2.0_repackaged/resolve/main/split_files/hunyuan3d-dit-v2-mv_fp16.safetensors
wget https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-19b-dev-fp8.safetensors

cd ../latent_upscale_models/
wget https://huggingface.co/Lightricks/LTX-2/resolve/main/ltx-2-spatial-upscaler-x2-1.0.safetensors

cd ../
mkdir detection
cd detection
wget https://huggingface.co/JunkyByte/easy_ViTPose/resolve/main/onnx/wholebody/vitpose-l-wholebody.onnx
wget https://huggingface.co/Wan-AI/Wan2.2-Animate-14B/resolve/main/process_checkpoint/det/yolov10m.onnx




# from another terminal (check IP address and port of runpod)
sed -i 's/from comfy.model_patcher import get_key_weight, string_to_seed/from comfy.model_patcher import get_key_weight\nfrom comfy.utils import string_to_seed/g' /workspace/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper/utils.py

# 1. Completely remove both to clear the conflict
pip uninstall -y onnxruntime onnxruntime-gpu

# 2. Install ONLY the GPU version with the correct CUDA links
pip install onnxruntime-gpu --extra-index-url https://aiinfra.pkgs.visualstudio.com/PublicPackages/_packaging/onnxruntime-cuda-12/pypi/simple/

cd ../../
python main.py --listen 0.0.0.0 --port 3008

disconnect and reconnect server  --> /workspace/ComfyUI# python main.py --listen 0.0.0.0 --port 3001



# for runpod copy-

scp -P 22191 ./krita_workflow/*.json root@69.30.85.66:/workspace/krita-ai-diffusion/ai_diffusion/styles/

# workflows

git clone https://github.com/Comfy-Org/workflows.git

scp -P 22052 "./krita_workflow/wan2.2_krita/"*.json root@194.68.245.49:/workspace/krita-ai-diffusion/ai_diffusion/styles/

# image gen

# wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_2512_fp8_e4m3fn.safetensors  
wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_2512_bf16.safetensors
wget https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2511_bf16.safetensors

wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors

wget https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors

wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors

wget https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors
wget https://huggingface.co/fal/Qwen-Image-Edit-2511-Multiple-Angles-LoRA/resolve/main/qwen-image-edit-2511-multiple-angles-lora.safetensors


# pose image
cd ../loras/
wget https://huggingface.co/MIUProject/VNCCS_PoseStudio/resolve/main/models/loras/qwen/VNCCS/VNCCS_PoseStudioQIE2511_V3_Art.safetensors

git clone https://github.com/AHEKOT/ComfyUI_VNCCS_Utils.git

# image to video

git clone https://github.com/TTPlanetPig/Comfyui_TTP_Toolset.git

# controlnet
https://huggingface.co/lllyasviel/ControlNet/tree/main/models

• If you are on main, push to main like this:

  git add .
  git commit -m "Your message"
  git push origin main

  If you are on shell_min, push to shell_min like this:

  git add .
  git commit -m "Your message"
  git push origin shell_min
