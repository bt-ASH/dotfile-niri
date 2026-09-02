#!/bin/bash
# 监听显示器(输出)变化, 变化时重新为每个输出开一个 bar
#
# 说明: niri 26.04 的 `niri msg --json event-stream` 不发输出变化事件
# (实测改 scale、改 transform 都不会发任何事件, 事件流里只有 WorkspacesChanged /
# WindowsChanged 这类, 没有 OutputsChanged), 所以这里用轮询 + 快照对比。
# 只有输出的名字集合发生变化(插拔屏)时才重开 bar, 改分辨率/缩放不会触发。

LAUNCH="$HOME/.config/eww/scripts/launch.sh"

snapshot() {
    niri msg outputs | sed -n 's/^Output .*(\([^)]*\))$/\1/p' | sort
}

prev=$(snapshot)

while true; do
    sleep 2
    cur=$(snapshot)
    [ "$cur" = "$prev" ] && continue
    prev=$cur
    [ -z "$cur" ] && continue
    sleep 1 # 等 niri 把新输出准备好
    bash "$LAUNCH"
done
