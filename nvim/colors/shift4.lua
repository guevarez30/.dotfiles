-- shift4.lua - Custom Neovim colorscheme based on provided palette
-- Author: TaylorGuevarez

local M = {}

-- Core palette (16 terminal colors)
local term = {
  "#4d4d4d", -- 0
  "#f12d52", -- 1
  "#09cd7e", -- 2
  "#f5f17a", -- 3
  "#3182e0", -- 4
  "#ff2b6d", -- 5
  "#09c87a", -- 6
  "#fcfcfc", -- 7
  "#808080", -- 8
  "#f16d86", -- 9
  "#0ae78d", -- 10
  "#fffc67", -- 11
  "#6096ff", -- 12
  "#ff78a2", -- 13
  "#0ae78d", -- 14
  "#ffffff", -- 15
}

local ui = {
  bg = "#0d0d17",
  fg = "#e6e5e5",
  cursor = "#e6e5e5",
  cursor_text = "#ffffff",
  sel_bg = "#adbdd0",
  sel_fg = "#000000",
}

-- Convenience named colors from the palette
local c = {
  gray0 = term[1],      -- #4d4d4d
  red = term[2],        -- #f12d52
  green = term[3],      -- #09cd7e
  yellow = term[4],     -- #f5f17a
  blue = term[5],       -- #3182e0
  magenta = term[6],    -- #ff2b6d
  teal = term[7],       -- #09c87a
  white = term[8],      -- #fcfcfc
  gray1 = term[9],      -- #808080
  red2 = term[10],      -- #f16d86
  green2 = term[11],    -- #0ae78d
  yellow2 = term[12],   -- #fffc67
  blue2 = term[13],     -- #6096ff
  magenta2 = term[14],  -- #ff78a2
  green3 = term[15],    -- #0ae78d
  white2 = term[16],    -- #ffffff
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
  vim.o.background = "dark"

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "shift4"

  set_terminal_colors()

  -- Editor/UI
  hi("Normal",         { fg = ui.fg, bg = ui.bg })
  hi("NormalNC",       { fg = ui.fg, bg = ui.bg })
  hi("Cursor",         { fg = ui.cursor_text, bg = ui.cursor })
  hi("TermCursor",     { fg = ui.cursor_text, bg = ui.cursor })
  hi("Visual",         { fg = ui.sel_fg, bg = ui.sel_bg })
  hi("Search",         { fg = "#000000", bg = c.yellow2 })
  hi("IncSearch",      { fg = "#000000", bg = c.blue2 })
  hi("MatchParen",     { fg = c.yellow2, bold = true })

  hi("LineNr",         { fg = c.gray1, bg = ui.bg })
  hi("CursorLineNr",   { fg = c.white2, bold = true })
  hi("CursorLine",     { bg = "#12121b" })
  hi("CursorColumn",   { bg = "#12121b" })
  hi("ColorColumn",    { bg = "#10101a" })
  hi("SignColumn",     { bg = ui.bg })
  hi("FoldColumn",     { fg = c.gray1, bg = ui.bg })
  hi("Folded",         { fg = c.gray1, bg = "#10101a" })

  hi("StatusLine",     { fg = ui.fg, bg = c.gray0 })
  hi("StatusLineNC",   { fg = c.gray1, bg = c.gray0 })
  hi("VertSplit",      { fg = c.gray0, bg = ui.bg })
  hi("WinSeparator",   { fg = c.gray0 })

  hi("Pmenu",          { fg = ui.fg, bg = "#141421" })
  hi("PmenuSel",       { fg = ui.sel_fg, bg = c.blue })
  hi("PmenuSbar",      { bg = "#11111a" })
  hi("PmenuThumb",     { bg = c.blue2 })

  hi("TabLine",        { fg = c.gray1, bg = "#11111a" })
  hi("TabLineSel",     { fg = ui.fg, bg = c.gray0, bold = true })
  hi("TabLineFill",    { bg = "#11111a" })

  hi("Whitespace",     { fg = "#222233" })
  hi("NonText",        { fg = "#222233" })
  hi("EndOfBuffer",    { fg = ui.bg })

  hi("Directory",      { fg = c.blue2 })
  hi("Title",          { fg = c.yellow2, bold = true })
  hi("ErrorMsg",       { fg = c.white2, bg = c.red, bold = true })
  hi("WarningMsg",     { fg = c.yellow2, bold = true })
  hi("MoreMsg",        { fg = c.green2 })
  hi("ModeMsg",        { fg = c.blue2 })

  -- Diff/VC
  hi("DiffAdd",        { fg = c.green2, bg = "#0f1a14" })
  hi("DiffChange",     { fg = c.blue2,  bg = "#0f1420" })
  hi("DiffDelete",     { fg = c.red,    bg = "#1a0f12" })
  hi("DiffText",       { fg = ui.sel_fg, bg = c.blue2, bold = true })

  -- Syntax
  hi("Comment",        { fg = c.gray1, italic = true })
  hi("Constant",       { fg = c.blue })
  hi("String",         { fg = c.green2 })
  hi("Character",      { fg = c.green2 })
  hi("Number",         { fg = c.blue2 })
  hi("Boolean",        { fg = c.red2 })
  hi("Float",          { fg = c.blue2 })

  hi("Identifier",     { fg = c.white })
  hi("Function",       { fg = c.blue2 })

  hi("Statement",      { fg = c.magenta, bold = true })
  hi("Conditional",    { fg = c.magenta })
  hi("Repeat",         { fg = c.magenta })
  hi("Label",          { fg = c.magenta })
  hi("Operator",       { fg = c.white2 })
  hi("Keyword",        { fg = c.magenta, bold = true })
  hi("Exception",      { fg = c.magenta })

  hi("PreProc",        { fg = c.blue })
  hi("Include",        { fg = c.blue })
  hi("Define",         { fg = c.blue })
  hi("Macro",          { fg = c.blue })
  hi("PreCondit",      { fg = c.blue })

  hi("Type",           { fg = c.teal })
  hi("StorageClass",   { fg = c.teal })
  hi("Structure",      { fg = c.teal })
  hi("Typedef",        { fg = c.teal })

  hi("Special",        { fg = c.yellow })
  hi("SpecialChar",    { fg = c.yellow })
  hi("Tag",            { fg = c.blue })
  hi("Delimiter",      { fg = c.gray1 })
  hi("SpecialComment", { fg = c.gray1, italic = true })
  hi("Debug",          { fg = c.red2 })

  hi("Underlined",     { underline = true })
  hi("Ignore",         { fg = c.gray1 })
  hi("Error",          { fg = c.white2, bg = c.red, bold = true })
  hi("Todo",           { fg = ui.sel_fg, bg = ui.sel_bg, bold = true })

  -- Diagnostics (LSP)
  hi("DiagnosticError", { fg = c.red })
  hi("DiagnosticWarn",  { fg = c.yellow2 })
  hi("DiagnosticInfo",  { fg = c.blue2 })
  hi("DiagnosticHint",  { fg = c.teal })
  hi("DiagnosticOk",    { fg = c.green2 })

  hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
  hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.yellow2 })
  hi("DiagnosticUnderlineInfo",  { undercurl = true, sp = c.blue2 })
  hi("DiagnosticUnderlineHint",  { undercurl = true, sp = c.teal })

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
  hi("TelescopeNormal",       { fg = ui.fg, bg = "#11111a" })
  hi("TelescopeBorder",       { fg = c.gray0, bg = "#11111a" })
  hi("TelescopeSelection",    { fg = ui.sel_fg, bg = c.blue })
  hi("TelescopeMatching",     { fg = c.yellow2, bold = true })
  hi("TelescopePromptNormal", { fg = ui.fg, bg = "#10101a" })
  hi("TelescopePromptBorder", { fg = c.gray0, bg = "#10101a" })

  -- Git signs (generic)
  hi("DiffAdded",   { fg = c.green2 })
  hi("DiffRemoved", { fg = c.red })
  hi("DiffChanged", { fg = c.blue2 })
end

M.setup = function()
  M.load()
end

M.load()

return M
