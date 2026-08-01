#!/usr/bin/env python3
# niri workspaces -> JSON array for eww (持续监听事件流, 行缓冲实时输出)
import json
import subprocess
import sys


def emit():
    out = subprocess.run(
        ["niri", "msg", "workspaces"], capture_output=True, text=True
    ).stdout
    ws = []
    for line in out.splitlines():
        if "Output" in line or not line.strip():
            continue
        parts = line.split()
        if parts[0] == "*":
            ws.append({"id": int(parts[1]), "focused": True})
        elif parts[0].isdigit():
            ws.append({"id": int(parts[0]), "focused": False})
    print(json.dumps(ws), flush=True)


# 先输出一次当前状态
emit()
# 持续监听工作区事件，有变化立即重新输出
proc = subprocess.Popen(
    ["niri", "msg", "event-stream"],
    stdout=subprocess.PIPE,
    text=True,
    bufsize=1,
)
for line in proc.stdout:
    if line.startswith("Workspaces changed:"):
        emit()
