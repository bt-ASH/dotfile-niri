#!/usr/bin/env bash
# 鸣潮 (Wuthering Waves) — 一键恢复原始配置
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WW_CONFIG_DIR="/home/ash/Games/ww/pfx/drive_c/Program Files/Wuthering Waves/Client/Saved/Config/WindowsNoEditor"

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  鸣潮 一键恢复原始配置${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# 1. Remove deployed config files → game regenerates defaults
echo -e "${CYAN}[1/5]${NC} 移除部署的配置文件..."
for f in GameUserSettings.ini Engine.ini Scalability.ini Hardware.ini RuntimeOptions.ini Wwise.ini CrashSight.ini DeviceProfiles.ini; do
    if [ -f "$WW_CONFIG_DIR/$f" ]; then
        chmod 644 "$WW_CONFIG_DIR/$f" 2>/dev/null || true
        rm -f "$WW_CONFIG_DIR/$f"
        echo -e "  ${GREEN}✓${NC} 已删除 $f"
    fi
done
echo -e "${GREEN}✅ 配置文件已移除(游戏将重新生成默认值)${NC}"

# 2. Reset GPU: fan auto, power mode auto
echo -e "${CYAN}[2/5]${NC} 重置 GPU 为默认..."
nvidia-settings -a "[gpu:0]/GPUFanControlState=0" >/dev/null 2>&1 || true
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=2" >/dev/null 2>&1 || true
echo -e "${GREEN}✅ GPU: 自动风扇 + 默认电源模式${NC}"

# 3. Remove DXVK cache dir
echo -e "${CYAN}[3/5]${NC} 移除 DXVK 缓存目录..."
rm -rf /home/ash/Games/ww/dxvk_cache
echo -e "${GREEN}✅ DXVK cache 已移除${NC}"

# 4. Restore Lutris env — remove vars added by apply.sh
echo -e "${CYAN}[4/5]${NC} 恢复 Lutris 环境变量..."
python3 << 'PY'
import os
yml = '/home/ash/.local/share/lutris/games/ww-1781980107.yml'
if os.path.exists(yml):
    with open(yml) as f:
        d = f.read()
    # Reverse the insertion from apply.sh
    old = ("    DXVK_HUD: fps\n    __VK_LAYER_NV_optimus_GPU_SELECTOR: '2:0:0'\n"
           "    DXVK_CONFIG_FILE: '/home/ash/Games/ww/pfx/drive_c/users/steamuser/AppData/Local/dxvk/dxvk.conf'\n"
           "    DXVK_STATE_CACHE: '1'\n"
           "    DXVK_STATE_CACHE_PATH: '/home/ash/Games/ww/dxvk_cache'\n"
           "    WINE_FULLSCREEN_FSR: '1'\n"
           "    WINE_FULLSCREEN_FSR_STRENGTH: '5'\n"
           "    vblank_mode: '0'\n"
           "    __GL_SHADER_DISK_CACHE_SIZE: '1073741824'\n"
           "    mesa_glthread: 'true'\n"
           "    PROTON_HIDE_NVIDIA_GPU: '0'\n"
           "    PROTON_ENABLE_NGX_UPDATER: '0'")
    new = "    DXVK_HUD: fps\n    __VK_LAYER_NV_optimus_GPU_SELECTOR: '2:0:0'"
    if old in d:
        d = d.replace(old, new)
        with open(yml, 'w') as f:
            f.write(d)
        print('Lutris env restored')
    else:
        print('Lutris env already clean')
PY
echo -e "${GREEN}✅ Lutris env 已恢复${NC}"

# 5. Recreate ShaderCache dir (apply.sh deleted it)
echo -e "${CYAN}[5/5]${NC} 重建 ShaderCache..."
SHADER_CACHE_DIR="$WW_CONFIG_DIR/../../../ShaderCache"
mkdir -p "$SHADER_CACHE_DIR"
echo -e "${GREEN}✅ ShaderCache 已重建${NC}"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✅ 鸣潮 已恢复至默认配置${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}📋 如需重启 GPU 性能模式:${NC}"
echo "  $SCRIPT_DIR/set_gpu_perf.sh"
