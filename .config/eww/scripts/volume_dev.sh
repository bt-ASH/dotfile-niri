#!/bin/bash
# 输出当前默认音频设备的类型:
#   bt          - 蓝牙设备 (format-bluetooth)
#   headphone   - 耳机
#   hands-free  - 免提
#   headset     - 头戴式耳机
#   phone       - 手机
#   portable    - 便携设备
#   car         - 车载
#   default     - 其他/内置
sink=$(pactl get-default-sink 2>/dev/null)
[ -z "$sink" ] && { echo "default"; exit; }

# 提取默认 sink 的 Properties 段
props=$(pactl list sinks | awk -v s="$sink" '
  $1=="Name:" && $2==s {found=1; next}
  found && /^Sink #/ {exit}
  found {print}
')
# 有线耳机: 耳机插入后 active port 切到 analog-output-headphones
if echo "$props" | grep -q 'Active Port: analog-output-headphones'; then
  echo "headphone"
  exit
fi

name=$(echo "$props" | grep -oP 'device.product.name\s*=\s*"\K[^"]+' | head -1 | tr '[:upper:]' '[:lower:]')
if echo "$props" | grep -q 'api.bluez5.profile'; then
  echo "bt"
  exit
fi

name=$(echo "$props" | grep -oP 'device.product.name\s*=\s*"\K[^"]+' | head -1 | tr '[:upper:]' '[:lower:]')
case "$name" in
  *headset*)   echo "headset" ;;
  *headphone*) echo "headphone" ;;
  *hands-free*|*hands_free*|*handsfree*) echo "hands-free" ;;
  *phone*)     echo "phone" ;;
  *portable*)  echo "portable" ;;
  *car*)       echo "car" ;;
  *)           echo "default" ;;
esac
