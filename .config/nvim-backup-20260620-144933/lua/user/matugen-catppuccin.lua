-- Matugen generated catppuccin overrides for nvim
local palette = {
  bg = "#1f1f25",
  fg = "#e4e1e9",
  primary = "#bec2ff",
  secondary = "#c5c4dd",
  tertiary = "#e8b9d5",
  error = "#ffb4ab",
}

local function hex_highlight(name, bg, fg, opts)
  local cmd = "highlight " .. name
  if bg then cmd = cmd .. " guibg=" .. bg end
  if fg then cmd = cmd .. " guifg=" .. fg end
  if opts then cmd = cmd .. " " .. opts end
  vim.cmd(cmd)
end

-- Do NOT re-apply colorscheme here; polish.lua already sets it
hex_highlight("Normal", nil, palette.fg)
hex_highlight("FloatBorder", palette.tertiary, palette.fg, "gui=bold")
hex_highlight("TelescopeBorder", palette.tertiary, nil, "gui=bold")
hex_highlight("TelescopePromptBorder", palette.tertiary, nil, "gui=bold")
hex_highlight("TelescopeResultsBorder", palette.secondary, nil, "gui=bold")
hex_highlight("Comment", nil, palette.secondary)
hex_highlight("LineNr", nil, palette.secondary)
hex_highlight("CursorLineNr", palette.primary, nil, "gui=bold")
hex_highlight("Search", palette.primary, palette.bg)
hex_highlight("IncSearch", palette.primary, palette.bg)
hex_highlight("Visual", palette.tertiary, palette.bg)
hex_highlight("VertSplit", palette.secondary, nil)
hex_highlight("StatusLine", palette.tertiary, palette.bg, "gui=bold")
hex_highlight("StatusLineNC", palette.secondary, palette.bg)
