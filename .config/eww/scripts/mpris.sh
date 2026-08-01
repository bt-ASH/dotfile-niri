#!/bin/bash
# mpris info as JSON (no album art download)
playerctl metadata -F -f '{{playerName}}|{{title}}|{{artist}}|{{status}}' 2>/dev/null | while IFS='|' read -r name title artist status; do
  if [ -z "$name" ]; then
    echo '{"name":"","title":"","artist":"","status":"Stopped"}'
  else
    jq -n --arg name "$name" --arg title "$title" --arg artist "$artist" --arg status "$status" \
      '{name:$name,title:$title,artist:$artist,status:$status}'
  fi
done
