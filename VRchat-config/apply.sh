#!/usr/bin/env bash
# VRChat 极致帧率 — 一键配置
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

VRCDIR="/home/ash/.local/share/Steam/steamapps/common/VRChat"
PREFIX="/home/ash/.local/share/Steam/steamapps/compatdata/438100"
DXVK_DIR="$PREFIX/pfx/drive_c/users/steamuser/AppData/Local/dxvk"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  VRChat 极致帧率一键配置${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# 1. DXVK
echo -e "${CYAN}[1/6]${NC} DXVK 配置..."
mkdir -p "$DXVK_DIR"
cp "$SCRIPT_DIR/dxvk.conf" "$DXVK_DIR/dxvk.conf"
echo -e "${GREEN}✅ DXVK${NC}"

# 2. boot.config
 echo -e "${CYAN}[2/6]${NC} Unity boot.config..."
cp "$SCRIPT_DIR/boot.config" "$VRCDIR/VRChat_Data/boot.config"
echo -e "${GREEN}✅ boot.config${NC}"

# 3. Registry FPS + quality
 echo -e "${CYAN}[3/6]${NC} FPS 解封 + 质量最低化..."
python3 << 'PY'
rp = '/home/ash/.local/share/Steam/steamapps/compatdata/438100/pfx/user.reg'
with open(rp, 'r', encoding='utf-8', errors='replace') as f:
    d = f.read()
d = d.replace('"FPS_LIMIT_h3202401354"=dword:00000014', '"FPS_LIMIT_h3202401354"=dword:00000048')
d = d.replace('"FPSType_h850469784"=dword:00000002', '"FPSType_h850469784"=dword:00000003')
d = d.replace('"VRC_ADVANCED_GRAPHICS_ANTIALIASING_h4197584722"=dword:00000001', '"VRC_ADVANCED_GRAPHICS_ANTIALIASING_h4197584722"=dword:00000000')
d = d.replace('00,00,00,00,00,00,f0,3f', '00,00,00,00,00,00,00,00')
d = d.replace('00,00,00,40,33,33,eb,3f', '00,00,00,00,00,00,00,00')
with open(rp, 'w', encoding='utf-8', errors='replace') as f:
    f.write(d)
print('FPS/AA/SteamAudio done')
PY
echo -e "${GREEN}✅ 注册表${NC}"

# 4. Resolution
echo -e "${CYAN}[4/6]${NC} 分辨率 → 800x450..."
python3 << 'PY'
rp = '/home/ash/.local/share/Steam/steamapps/compatdata/438100/pfx/user.reg'
with open(rp, 'r', encoding='utf-8', errors='replace') as f:
    d = f.read()
d = d.replace('"Screenmanager Resolution Width_h182942802"=dword:00000380', '"Screenmanager Resolution Width_h182942802"=dword:00000320')
d = d.replace('"Screenmanager Resolution Width Default_h680557497"=dword:00000400', '"Screenmanager Resolution Width Default_h680557497"=dword:00000320')
d = d.replace('"Screenmanager Resolution Height_h2627697771"=dword:00000215', '"Screenmanager Resolution Height_h2627697771"=dword:000001c2')
d = d.replace('"Screenmanager Resolution Height Default_h1380706816"=dword:00000300', '"Screenmanager Resolution Height Default_h1380706816"=dword:000001c2')
with open(rp, 'w', encoding='utf-8', errors='replace') as f:
    f.write(d)
print('Resolution: 800x450')
PY
echo -e "${GREEN}✅ 分辨率${NC}"

# 5. Cache clean
echo -e "${CYAN}[5/6]${NC} 清理缓存..."
rm -rf "$PREFIX/pfx/drive_c/users/steamuser/AppData/LocalLow/VRChat/VRChat/Cache-WindowsPlayer/"* 2>/dev/null
rm -rf "$PREFIX/pfx/drive_c/users/steamuser/AppData/LocalLow/VRChat/VRChat/TextureCache-WindowsPlayer/"* 2>/dev/null
rm -f "$VRCDIR/VRChat.dxvk-cache" 2>/dev/null
echo -e "${GREEN}✅ 缓存已清理${NC}"

# 6. GPU
echo -e "${CYAN}[6/6]${NC} GPU 性能模式..."
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1" >/dev/null 2>&1
nvidia-settings -a "[gpu:0]/GPUFanControlState=1" >/dev/null 2>&1
nvidia-settings -a "[gpu:0]/GPUTargetFanSpeed=100" >/dev/null 2>&1
echo -e "${GREEN}✅ GPU P0 + Fan100%${NC}"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  ✅ VRChat 优化完成!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}📋 Steam 启动选项 (右键VRChat→属性→启动选项):${NC}"
echo "  --enable-sandbox=False --disable-vr --screen-width 800 --screen-height 450 --window-mode exclusive"
echo ""
echo -e "${YELLOW}📋 游戏中设置:${NC}"
echo "  性能→全部最低 | 抗锯齿→关 | 分辨率缩放→最低"
echo "  安全→屏蔽非好友 | 头像→VeryPoor/None"
echo ""
echo -e "${YELLOW}📋 每次启动前运行:${NC}"
echo "  $SCRIPT_DIR/set_gpu_perf.sh"
