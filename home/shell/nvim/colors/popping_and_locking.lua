if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end
vim.cmd("highlight clear")
vim.o.termguicolors = true
vim.g.colors_name = "popping_and_locking"

local p = {
  bg = "#181921",
  bg_alt = "#1d2021",
  fg = "#ebdbb2",
  muted = "#a89984",
  gray = "#928374",

  red = "#cc241d",
  red_bright = "#f42c3e",
  green = "#98971a",
  green_bright = "#b8bb26",
  yellow = "#d79921",
  yellow_bright = "#fabd2f",
  blue = "#458588",
  blue_bright = "#99c6ca",
  magenta = "#b16286",
  magenta_bright = "#d3869b",
  cyan = "#689d6a",
  cyan_bright = "#7ec16e",
}

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hl("Normal", {fg = p.fg, bg = p.bg})
hl("NormalFloat", {fg = p.fg, bg = p.bg})
hl("FloatBorder", {fg = p.gray, bg = p.bg})
hl("SignColumn", {bg = p.bg})
hl("LineNr", {fg = p.gray, bg = p.bg})
hl("CursorLineNr", {fg = p.fg, bg = p.bg, bold = true})
hl("CursorLine", {bg = p.bg_alt})
hl("ColorColumn", {bg = p.bg_alt})
hl("Visual", {bg = "#4a4744"})
hl("Search", {fg = p.bg, bg = p.yellow_bright})
hl("IncSearch", {fg = p.bg, bg = p.red_bright})
hl("MatchParen", {fg = p.yellow_bright, bold = true})
hl("Pmenu", {fg = p.fg, bg = p.bg_alt})
hl("PmenuSel", {fg = p.fg, bg = "#1a1c21"})
hl("WinSeparator", {fg = p.gray})
hl("StatusLine", {fg = p.fg, bg = p.bg_alt})
hl("StatusLineNC", {fg = p.muted, bg = p.bg_alt})
hl("VertSplit", {fg = p.gray})

hl("Comment", {fg = p.blue, italic = true})
hl("Constant", {fg = p.magenta_bright})
hl("String", {fg = p.yellow})
hl("Character", {fg = p.yellow})
hl("Number", {fg = p.magenta_bright})
hl("Boolean", {fg = p.magenta_bright})
hl("Identifier", {fg = p.fg})
hl("Function", {fg = p.gray})
hl("Statement", {fg = p.red_bright})
hl("Operator", {fg = p.green})
hl("Keyword", {fg = p.red_bright})
hl("PreProc", {fg = p.yellow})
hl("Type", {fg = p.yellow_bright})
hl("Special", {fg = p.blue})
hl("Delimiter", {fg = p.green})
hl("Title", {fg = p.blue, bold = true})
hl("Todo", {fg = p.red_bright, bold = true})

hl("DiagnosticError", {fg = p.red})
hl("DiagnosticWarn", {fg = p.yellow})
hl("DiagnosticInfo", {fg = p.blue})
hl("DiagnosticHint", {fg = p.cyan})
hl("DiagnosticUnderlineError", {undercurl = true, sp = p.red})
hl("DiagnosticUnderlineWarn", {undercurl = true, sp = p.yellow})
hl("DiagnosticUnderlineInfo", {undercurl = true, sp = p.blue})
hl("DiagnosticUnderlineHint", {undercurl = true, sp = p.cyan})

hl("DiffAdd", {fg = p.green, bg = "#38391f"})
hl("DiffChange", {fg = p.yellow, bg = "#483921"})
hl("DiffDelete", {fg = p.red, bg = "#451c20"})
hl("DiffText", {fg = p.blue, bg = "#23343b"})
hl("GitSignsAdd", {fg = p.green})
hl("GitSignsChange", {fg = p.yellow})
hl("GitSignsDelete", {fg = p.red})

hl("@comment", {link = "Comment"})
hl("@keyword", {fg = p.red_bright})
hl("@operator", {fg = p.green})
hl("@string", {fg = p.yellow})
hl("@string.escape", {fg = p.yellow})
hl("@string.special", {fg = p.blue})
hl("@string.special.path", {fg = p.blue})
hl("@number", {fg = p.magenta_bright})
hl("@boolean", {fg = p.magenta_bright})
hl("@function", {fg = p.gray})
hl("@function.method", {fg = p.cyan})
hl("@type", {fg = p.yellow_bright})
hl("@property", {fg = p.blue})
hl("@punctuation", {fg = p.green})
hl("@punctuation.bracket", {fg = p.green})
hl("@punctuation.delimiter", {fg = p.green})
hl("@punctuation.special", {fg = p.red_bright})
hl("@variable", {fg = p.fg})
hl("@variable.builtin", {fg = p.magenta_bright})
hl("@constructor", {fg = p.yellow_bright})

vim.g.terminal_color_0 = "#1d2021"
vim.g.terminal_color_1 = "#cc241d"
vim.g.terminal_color_2 = "#98971a"
vim.g.terminal_color_3 = "#d79921"
vim.g.terminal_color_4 = "#458588"
vim.g.terminal_color_5 = "#b16286"
vim.g.terminal_color_6 = "#689d6a"
vim.g.terminal_color_7 = "#a89984"
vim.g.terminal_color_8 = "#928374"
vim.g.terminal_color_9 = "#f42c3e"
vim.g.terminal_color_10 = "#b8bb26"
vim.g.terminal_color_11 = "#fabd2f"
vim.g.terminal_color_12 = "#99c6ca"
vim.g.terminal_color_13 = "#d3869b"
vim.g.terminal_color_14 = "#7ec16e"
vim.g.terminal_color_15 = "#ebdbb2"
