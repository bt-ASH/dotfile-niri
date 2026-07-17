#!/bin/bash
# ~/.config/niri/scripts/set-wallpaper.sh
# 一键设置壁纸，同时更新 overview 模糊背景
# 用法：set-wallpaper.sh /path/to/wallpaper.jpg

set -e

if [ -z "$1" ] || [ ! -f "$1" ]; then
    echo "Usage: set-wallpaper.sh /path/to/wallpaper.jpg"
    exit 1
fi

WALLPAPER="$1"

echo "Setting desktop wallpaper..."

# 设置桌面壁纸
awww img "$WALLPAPER"

echo "Updating overview blurred background..."

# 更新 overview 模糊背景
bash ~/.config/niri/scripts/blur-overview.sh "$WALLPAPER"

echo "Done！"
