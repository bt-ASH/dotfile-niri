#!/usr/bin/env bash
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1" 2>/dev/null
nvidia-settings -a "[gpu:0]/GPUFanControlState=1" 2>/dev/null
nvidia-settings -a "[gpu:0]/GPUTargetFanSpeed=100" 2>/dev/null
echo "✅ GPU: P0模式 + Fan 100%"
