#!/bin/bash
xhost +SI:localuser:root >/dev/null 2>&1
nohup vmware "$@" >/dev/null 2>&1 &
