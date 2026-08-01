#!/bin/bash
# 左击时钟：在"时间"和"年月日"显示之间切换
MODE_FILE=/tmp/eww-clock-mode
if [ -f "$MODE_FILE" ]; then
    rm -f "$MODE_FILE"
else
    touch "$MODE_FILE"
fi
# 立即刷新显示，不等 1s 轮询
eww update time="$(/home/ash/.config/eww/scripts/clock.sh)"
