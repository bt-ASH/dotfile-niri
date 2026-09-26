#!/bin/bash
# open wiremix in ghostty (don't spawn duplicates)
# --gtk-single-instance=false: 单独进程, 否则 CLI 移交主实例后退出, pgrep 检测不到
if ! pgrep -f "ghostty --class wiremix" >/dev/null 2>&1; then
  setsid ghostty -e wiremix >/dev/null 2>&1 &
fi
