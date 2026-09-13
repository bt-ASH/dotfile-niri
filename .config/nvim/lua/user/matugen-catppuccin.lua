-- Matugen generated catppuccin overrides for nvim
local palette = {
  bg = "#1f1f25",
  fg = "#e4e1e9",
  primary = "#bdc2ff",
  secondary = "#c4c4dd",
  tertiary = "#e7b9d5",
  error = "#ffb4ab",
}

local function hex_highlight(name, bg, fg, opts)
  local cmd = "highlight " .. name
  if bg then cmd = cmd .. " guibg=" .. bg end
  if fg then cmd = cmd .. " guifg=" .. fg end
  if opts then cmd = cmd .. " " .. opts end
  vim.cmd(cmd)
end

-- make catppuccin recolor when changing palette (source this file after matugen)
vim.cmd("colorscheme catppuccin")
hex_highlight("Normal", nil, palette.fg)
hex_highlight("FloatBorder", palette.tertiary, palette.fg, "gui=bold")
hex_highlight("TelescopeBorder", palette.tertiary, nil, "gui=bold")
