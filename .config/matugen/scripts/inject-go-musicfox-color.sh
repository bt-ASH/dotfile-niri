#!/bin/bash
# 用 matugen 渲染好的颜色替换 go-musicfox config.toml 中的 primaryColor

COLOR_FILE="$HOME/.cache/matugen/musicfox-primary.txt"
CONFIG_FILE="$HOME/.config/go-musicfox/config.toml"

[ -f "$COLOR_FILE" ] || exit 0

PRIMARY_COLOR=$(cat "$COLOR_FILE" | tr -d ' \n\r;')

# 备份
cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# 替换 primaryColor 行
sed -i "s|^primaryColor = .*|primaryColor = \"$PRIMARY_COLOR\" # Matugen Generated|" "$CONFIG_FILE"

exit 0
