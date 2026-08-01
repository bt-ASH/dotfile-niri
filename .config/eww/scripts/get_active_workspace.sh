#!/bin/bash
niri msg workspaces | awk '/^ \*/ {print $2}'
