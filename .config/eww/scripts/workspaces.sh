#!/bin/bash
# niri workspaces -> JSON array for eww (一次性输出)
niri msg workspaces | awk '
    /Output/ {next}
    /^\s*\*/ {id=$2; print "{\"id\":"id",\"focused\":true}"}
    /^\s+[0-9]/ {id=$1; print "{\"id\":"id",\"focused\":false}"}
' | jq -sc .
