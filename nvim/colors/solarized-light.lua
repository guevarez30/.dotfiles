-- solarized-light.lua - Solarized Light colorscheme for Neovim
-- Loads theme definition from ~/.dotfiles/themes/solarized-light.lua

local M = {}

-- Load theme from themes directory
local theme_path = vim.fn.expand("~/.dotfiles/themes/solarized-light.lua")
local theme = dofile(theme_path)

local term = theme.term
local ui = theme.ui

-- Convenience named colors from the palette
local c = {
  base03 = term[1],     -- #073642
  red = term[2],        -- #dc322f
  green = term[3],      -- #859900
  yellow = term[4],     -- #b58900
  blue = term[5],       -- #268bd2
  magenta = term[6],    -- #d33682
  cyan = term[7],       -- #2aa198
  base2 = term[8],      -- #eee8d5
  base02 = term[9],     -- #002b36
  orange = term[10],    -- #cb4b16
  base01 = term[11],    -- #586e75
  base00 = term[12],    -- #657b83
  base0 = term[13],     -- #839496
  violet = term[14],    -- #6c71c4
  base1 = term[15],     -- #93a1a1
  base3 = term[16],     -- #fdf6e3
}

local function set_terminal_colors()
  for i, hex in ipairs(term) do
    vim.g["terminal_color_" .. (i - 1)] = hex
  end
  vim.g.terminal_color_foreground = ui.fg
  vim.g.terminal_color_background = ui.bg
end

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function link(group, target)
  vim.api.nvim_set_hl(0, group, { link = target })
end

function M.load()
  if vim.fn.has("termguicolors") == 1 then
    vim.o.termguicolors = true
  end
  vim.o.background = theme.background

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = theme.name

  set_terminal_colors()

  -- Editor/UI
  hi("Normal",         { fg = ui.fg, bg = ui.bg })
  hi("NormalNC",       { fg = ui.fg, bg = ui.bg })
  hi("Cursor",         { fg = ui.cursor_text, bg = ui.cursor })
  hi("TermCursor",     { fg = ui.cursor_text, bg = ui.cursor })
  hi("Visual",         { fg = ui.sel_fg, bg = ui.sel_bg })
  hi("Search",         { fg = c.base3, bg = c.yellow })
  hi("IncSearch",      { fg = c.base3, bg = c.orange })
  hi("MatchParen",     { fg = c.red, bold = true })

  hi("LineNr",         { fg = c.base1, bg = ui.bg })
  hi("CursorLineNr",   { fg = c.base01, bold = true })
  hi("CursorLine",     { bg = c.base2 })
  hi("CursorColumn",   { bg = c.base2 })
  hi("ColorColumn",    { bg = c.base2 })
  hi("SignColumn",     { bg = ui.bg })
  hi("FoldColumn",     { fg = c.base1, bg = ui.bg })
  hi("Folded",         { fg = c.base01, bg = c.base2 })

  hi("StatusLine",     { fg = c.base00, bg = c.base2 })
  hi("StatusLineNC",   { fg = c.base1, bg = c.base2 })
  hi("VertSplit",      { fg = c.base2, bg = ui.bg })
  hi("WinSeparator",   { fg = c.base2 })

  hi("Pmenu",          { fg = ui.fg, bg = c.base2 })
  hi("PmenuSel",       { fg = c.base3, bg = c.blue })
  hi("PmenuSbar",      { bg = c.base2 })
  hi("PmenuThumb",     { bg = c.base0 })

  hi("TabLine",        { fg = c.base1, bg = c.base2 })
  hi("TabLineSel",     { fg = c.base00, bg = c.base3, bold = true })
  hi("TabLineFill",    { bg = c.base2 })

  hi("Whitespace",     { fg = c.base2 })
  hi("NonText",        { fg = c.base2 })
  hi("EndOfBuffer",    { fg = ui.bg })

  hi("Directory",      { fg = c.blue })
  hi("Title",          { fg = c.orange, bold = true })
  hi("ErrorMsg",       { fg = c.base3, bg = c.red, bold = true })
  hi("WarningMsg",     { fg = c.orange, bold = true })
  hi("MoreMsg",        { fg = c.green })
  hi("ModeMsg",        { fg = c.blue })

  -- Diff/VC
  hi("DiffAdd",        { fg = c.green, bg = c.base2 })
  hi("DiffChange",     { fg = c.yellow, bg = c.base2 })
  hi("DiffDelete",     { fg = c.red, bg = c.base2 })
  hi("DiffText",       { fg = c.blue, bg = c.base2, bold = true })

  -- Syntax
  hi("Comment",        { fg = c.base1, italic = true })
  hi("Constant",       { fg = c.cyan })
  hi("String",         { fg = c.green })
  hi("Character",      { fg = c.green })
  hi("Number",         { fg = c.violet })
  hi("Boolean",        { fg = c.violet })
  hi("Float",          { fg = c.violet })

  hi("Identifier",     { fg = c.blue })
  hi("Function",       { fg = c.blue })

  hi("Statement",      { fg = c.green, bold = true })
  hi("Conditional",    { fg = c.green })
  hi("Repeat",         { fg = c.green })
  hi("Label",          { fg = c.green })
  hi("Operator",       { fg = c.base00 })
  hi("Keyword",        { fg = c.green, bold = true })
  hi("Exception",      { fg = c.green })

  hi("PreProc",        { fg = c.orange })
  hi("Include",        { fg = c.orange })
  hi("Define",         { fg = c.orange })
  hi("Macro",          { fg = c.orange })
  hi("PreCondit",      { fg = c.orange })

  hi("Type",           { fg = c.yellow })
  hi("StorageClass",   { fg = c.yellow })
  hi("Structure",      { fg = c.yellow })
  hi("Typedef",        { fg = c.yellow })

  hi("Special",        { fg = c.red })
  hi("SpecialChar",    { fg = c.red })
  hi("Tag",            { fg = c.orange })
  hi("Delimiter",      { fg = c.base01 })
  hi("SpecialComment", { fg = c.base1, italic = true })
  hi("Debug",          { fg = c.red })

  hi("Underlined",     { underline = true })
  hi("Ignore",         { fg = c.base1 })
  hi("Error",          { fg = c.red, bold = true })
  hi("Todo",           { fg = c.magenta, bold = true })

  -- Diagnostics (LSP)
  hi("DiagnosticError", { fg = c.red })
  hi("DiagnosticWarn",  { fg = c.orange })
  hi("DiagnosticInfo",  { fg = c.blue })
  hi("DiagnosticHint",  { fg = c.cyan })
  hi("DiagnosticOk",    { fg = c.green })

  hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
  hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.orange })
  hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.blue })
  hi("DiagnosticUnderlineHint",  { undercurl = true, sp = c.cyan })

  -- Treesitter links (fallbacks)
  link("@comment", "Comment")
  link("@constant", "Constant")
  link("@string", "String")
  link("@character", "Character")
  link("@number", "Number")
  link("@boolean", "Boolean")
  link("@float", "Float")
  link("@variable", "Identifier")
  link("@function", "Function")
  link("@keyword", "Keyword")
  link("@type", "Type")
  link("@operator", "Operator")

  -- Telescope (if installed)
  hi("TelescopeNormal",       { fg = ui.fg, bg = c.base2 })
  hi("TelescopeBorder",       { fg = c.base1, bg = c.base2 })
  hi("TelescopeSelection",    { fg = c.base3, bg = c.blue })
  hi("TelescopeMatching",     { fg = c.yellow, bold = true })
  hi("TelescopePromptNormal", { fg = ui.fg, bg = c.base2 })
  hi("TelescopePromptBorder", { fg = c.base1, bg = c.base2 })

  -- Git signs (generic)
  hi("DiffAdded",   { fg = c.green })
  hi("DiffRemoved", { fg = c.red })
  hi("DiffChanged", { fg = c.yellow })
end

M.setup = function()
  M.load()
end

M.load()

return M
