#!/usr/bin/env bash
# 鸣潮 (Wuthering Waves) — 一键极限帧率配置
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WW_CONFIG_DIR="/home/ash/Games/ww/pfx/drive_c/Program Files/Wuthering Waves/Client/Saved/Config/WindowsNoEditor"

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  鸣潮 极致帧率一键配置${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# 1. Copy configs
echo -e "${CYAN}[1/5]${NC} 部署配置文件..."
mkdir -p "$WW_CONFIG_DIR"
for f in GameUserSettings.ini Engine.ini Scalability.ini Hardware.ini RuntimeOptions.ini Wwise.ini CrashSight.ini DeviceProfiles.ini; do
    if [ -f "$SCRIPT_DIR/$f" ]; then
        chmod 644 "$WW_CONFIG_DIR/$f" 2>/dev/null || true
        cp "$SCRIPT_DIR/$f" "$WW_CONFIG_DIR/$f"
        # CRLF
        python3 -c "import os; p='$WW_CONFIG_DIR/$f'; d=open(p,'rb').read().replace(b'\r\n',b'\n').replace(b'\n',b'\r\n'); open(p,'wb').write(d)" 2>/dev/null || true
        chmod 444 "$WW_CONFIG_DIR/$f"
        echo -e "  ${GREEN}✓${NC} $f"
    fi
done
echo -e "${GREEN}✅ 配置文件已部署(只读)${NC}"

# 2. GPU echo -e "${CYAN}[2/5]${NC} GPU 性能模式..."
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1" >/dev/null 2>&1
nvidia-settings -a "[gpu:0]/GPUFanControlState=1" >/dev/null 2>&1
nvidia-settings -a "[gpu:0]/GPUTargetFanSpeed=100" >/dev/null 2>&1
echo -e "${GREEN}✅ GPU P0 + Fan100%${NC}"

# 3. DXVK cache dir
echo -e "${CYAN}[3/5]${NC} DXVK 缓存目录..."
mkdir -p /home/ash/Games/ww/dxvk_cache
echo -e "${GREEN}✅ DXVK cache${NC}"

# 4. Lutris env
echo -e "${CYAN}[4/5]${NC} Lutris 环境变量..."
python3 << 'PY'
import os
yml = '/home/ash/.local/share/lutris/games/ww-1781980107.yml'
if os.path.exists(yml):
    with open(yml) as f:
        d = f.read()
    if 'DXVK_CONFIG_FILE' not in d:
        d = d.replace("    DXVK_HUD: fps\n    __VK_LAYER_NV_optimus_GPU_SELECTOR: '2:0:0'",
                       "    DXVK_HUD: fps\n    __VK_LAYER_NV_optimus_GPU_SELECTOR: '2:0:0'\n    DXVK_CONFIG_FILE: '/home/ash/Games/ww/pfx/drive_c/users/steamuser/AppData/Local/dxvk/dxvk.conf'\n    DXVK_STATE_CACHE: '1'\n    DXVK_STATE_CACHE_PATH: '/home/ash/Games/ww/dxvk_cache'\n    WINE_FULLSCREEN_FSR: '1'\n    WINE_FULLSCREEN_FSR_STRENGTH: '5'\n    vblank_mode: '0'\n    __GL_SHADER_DISK_CACHE_SIZE: '1073741824'\n    mesa_glthread: 'true'\n    PROTON_HIDE_NVIDIA_GPU: '0'\n    PROTON_ENABLE_NGX_UPDATER: '0'")
        with open(yml, 'w') as f:
            f.write(d)
        print('Lutris env updated')
    else:
        print('Lutris env already set')
PY
echo -e "${GREEN}✅ Lutris env${NC}"

# 5. Clean
echo -e "${CYAN}[5/5]${NC} 清理缓存..."
rm -rf "$WW_CONFIG_DIR/../../../ShaderCache" 2>/dev/null
rm -rf "/home/ash/Games/ww/GLCache"/* 2>/dev/null
echo -e "${GREEN}✅ 缓存清理${NC}"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✅ 鸣潮 优化完成!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}📋 关键配置:${NC}"
echo "  分辨率: 640x360 (内部渲染20%)"
echo "  FPS上限: 120"
echo "  SimpleForwardShading: 开启"
echo "  阴影/后处理/体积: 全部关闭"
echo "  纹理池: 32MB | MipBias: 5"
echo ""
echo -e "${YELLOW}📋 每次启动前:${NC}"
echo "  $SCRIPT_DIR/set_gpu_perf.sh"
echo "  sudo cpupower frequency-set -g performance (可选)"
