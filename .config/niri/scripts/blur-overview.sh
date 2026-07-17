#!/bin/bash
# ~/.config/niri/scripts/blur-overview.sh
# 
# 从当前壁纸生成模糊版发送给 overview 总览界面
# 带缓存：已模糊过的壁纸不会重复生成
# .webp 格式跳过，不做模糊处理
#
# 用法：
#   blur-overview.sh                              # 从 waypaper 配置读取壁纸
#   blur-overview.sh /path/to/wallpaper.jpg       # 指定壁纸路径
#
# 依赖: imagemagick (magick/convert), awww

set -e

# 如果传了参数，直接用参数作为壁纸路径
if [ -n "$1" ]; then
    CURRENT_WALLPAPER="$1"
else
    RAW_WALLPAPER=$(grep "^wallpaper =" ~/.config/waypaper/config.ini | head -1 | cut -d= -f2 | xargs)
    CURRENT_WALLPAPER="${RAW_WALLPAPER/#\~/$HOME}"
fi

if [ -z "$CURRENT_WALLPAPER" ] || [ ! -f "$CURRENT_WALLPAPER" ]; then
    echo "Wallpaper not found: $CURRENT_WALLPAPER"
    echo "Usage: blur-overview.sh [wallpaper_path]"
    exit 1
fi

# .webp 格式跳过 overview 模糊壁纸
if [[ "$CURRENT_WALLPAPER" == *.webp ]]; then
    exit 0
fi

CACHE_DIR="$HOME/.cache/waypaper/Pi"
mkdir -p "$CACHE_DIR"

HASH=$(echo -n "$CURRENT_WALLPAPER" | md5sum | cut -d' ' -f1)
BLUR_FILE="$CACHE_DIR/${HASH}_blurred.png"

if [ -f "$BLUR_FILE" ]; then
    awww img -n overview "$BLUR_FILE" --resize crop \
        --transition-type any --transition-step 63 --transition-duration 2 --transition-fps 60
    exit 0
fi

echo "Generating blurred wallpaper..."
magick "$CURRENT_WALLPAPER" -blur 0x30 "$BLUR_FILE"

awww img -n overview "$BLUR_FILE" --resize crop \
    --transition-type any --transition-step 63 --transition-duration 2 --transition-fps 60
