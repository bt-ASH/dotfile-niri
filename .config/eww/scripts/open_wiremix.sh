#!/bin/bash
# open wiremix in kitty (don't spawn duplicates)
if ! pgrep -f "kitty --app-id wiremix" >/dev/null 2>&1; then
  setsid kitty --app-id wiremix -e wiremix >/dev/null 2>&1 &
fi
