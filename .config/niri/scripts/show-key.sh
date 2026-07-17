#!/bin/bash
# 在屏幕上显示最近按下的键
# 需要: yad, zenity, 或 notify-send

KEY=\$(cat /dev/stdin)
notify-send -t 1500 "Key Pressed" "\$KEY" 2>/dev/null
