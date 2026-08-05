#!/bin/bash
# matugen 渲染 miyu.toml 后，将配色同步到 go-musicfox config.toml
# 包括: primaryColor / textColor / shadowColor / spectrum 三色

THEME_FILE="$HOME/.config/go-musicfox/themes/miyu.toml"
CONFIG_FILE="$HOME/.config/go-musicfox/config.toml"

[ -f "$THEME_FILE" ] || exit 0

# 从主题文件提取颜色值
PRIMARY_COLOR=$(grep -oP '^menuItemHover\s*=\s*"\K[^"]+' "$THEME_FILE" | head -1)
TEXT_COLOR=$(grep -oP '^textColor\s*=\s*"\K[^"]+' "$THEME_FILE" | head -1)
SHADOW_COLOR=$(grep -oP '^shadowColor\s*=\s*"\K[^"]+' "$THEME_FILE" | head -1)
SPECTRUM_LOW=$(grep -oP '^spectrumColorLow\s*=\s*"\K[^"]+' "$THEME_FILE" | head -1)
SPECTRUM_MID=$(grep -oP '^spectrumColorMid\s*=\s*"\K[^"]+' "$THEME_FILE" | head -1)
SPECTRUM_HIGH=$(grep -oP '^spectrumColorHigh\s*=\s*"\K[^"]+' "$THEME_FILE" | head -1)

# 备份
cp "$CONFIG_FILE" "$CONFIG_FILE.bak"

# 替换 primaryColor 行
[ -n "$PRIMARY_COLOR" ] && sed -i "s|^primaryColor = .*|primaryColor = \"$PRIMARY_COLOR\" # Matugen Generated|" "$CONFIG_FILE"

# 替换 textColor / shadowColor
[ -n "$TEXT_COLOR" ] && sed -i "s|^textColor = .*|textColor = \"$TEXT_COLOR\"|" "$CONFIG_FILE"
[ -n "$SHADOW_COLOR" ] && sed -i "s|^shadowColor = .*|shadowColor = \"$SHADOW_COLOR\"|" "$CONFIG_FILE"

# 替换频谱三色
[ -n "$SPECTRUM_LOW" ] && sed -i "s|^spectrumColorLow = .*|spectrumColorLow = \"$SPECTRUM_LOW\"|" "$CONFIG_FILE"
[ -n "$SPECTRUM_MID" ] && sed -i "s|^spectrumColorMid = .*|spectrumColorMid = \"$SPECTRUM_MID\"|" "$CONFIG_FILE"
[ -n "$SPECTRUM_HIGH" ] && sed -i "s|^spectrumColorHigh = .*|spectrumColorHigh = \"$SPECTRUM_HIGH\"|" "$CONFIG_FILE"

exit 0
