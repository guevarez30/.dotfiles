vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "dracula-plus"
vim.o.termguicolors = true
vim.o.background = "dark"

local c = {
	bg = "#212121",
	bg_alt = "#21222c",
	fg = "#f8f8f2",
	muted = "#545454",
	selection = "#44475a",
	red = "#ff5555",
	red_bright = "#ff6e6e",
	green = "#50fa7b",
	green_bright = "#69ff94",
	yellow = "#ffcb6b",
	blue = "#82aaff",
	blue_bright = "#d6acff",
	purple = "#c792ea",
	pink = "#ff92df",
	cyan = "#8be9fd",
	cyan_bright = "#a4ffff",
	white = "#f8f8f2",
	cursor = "#eceff4",
}

local function hl(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

hl("Normal", { fg = c.fg, bg = "NONE" })
hl("NormalFloat", { fg = c.fg, bg = c.bg })
hl("FloatBorder", { fg = c.purple, bg = c.bg })
hl("Cursor", { fg = c.bg, bg = c.cursor })
hl("CursorLine", { bg = c.bg_alt })
hl("CursorLineNr", { fg = c.yellow, bold = true })
hl("LineNr", { fg = c.muted })
hl("Visual", { bg = c.selection })
hl("Search", { fg = c.bg, bg = c.yellow })
hl("IncSearch", { fg = c.bg, bg = c.pink })
hl("MatchParen", { fg = c.cyan_bright, bold = true })
hl("Pmenu", { fg = c.fg, bg = c.bg })
hl("PmenuSel", { fg = c.bg, bg = c.purple })
hl("PmenuSbar", { bg = c.selection })
hl("PmenuThumb", { bg = c.purple })
hl("StatusLine", { fg = c.fg, bg = c.bg_alt })
hl("StatusLineNC", { fg = c.muted, bg = c.bg_alt })
hl("TabLine", { fg = c.muted, bg = c.bg_alt })
hl("TabLineSel", { fg = c.fg, bg = c.selection })
hl("WinSeparator", { fg = c.selection })
hl("VertSplit", { fg = c.selection })
hl("Directory", { fg = c.blue })
hl("Title", { fg = c.purple, bold = true })
hl("NonText", { fg = c.muted })
hl("SpecialKey", { fg = c.muted })
hl("Folded", { fg = c.cyan, bg = c.bg_alt })
hl("SignColumn", { fg = c.fg, bg = "NONE" })
hl("ColorColumn", { bg = c.bg_alt })

hl("Comment", { fg = c.muted, italic = true })
hl("Constant", { fg = c.purple })
hl("String", { fg = c.green })
hl("Character", { fg = c.green })
hl("Number", { fg = c.purple })
hl("Boolean", { fg = c.purple })
hl("Float", { fg = c.purple })
hl("Identifier", { fg = c.fg })
hl("Function", { fg = c.green_bright })
hl("Statement", { fg = c.pink })
hl("Conditional", { fg = c.pink })
hl("Repeat", { fg = c.pink })
hl("Label", { fg = c.pink })
hl("Operator", { fg = c.pink })
hl("Keyword", { fg = c.pink })
hl("Exception", { fg = c.red })
hl("PreProc", { fg = c.pink })
hl("Include", { fg = c.pink })
hl("Define", { fg = c.pink })
hl("Macro", { fg = c.pink })
hl("Type", { fg = c.blue })
hl("StorageClass", { fg = c.pink })
hl("Structure", { fg = c.blue })
hl("Typedef", { fg = c.blue })
hl("Special", { fg = c.cyan })
hl("Underlined", { fg = c.cyan, underline = true })
hl("Error", { fg = c.red })
hl("Todo", { fg = c.bg, bg = c.yellow, bold = true })

hl("DiagnosticError", { fg = c.red })
hl("DiagnosticWarn", { fg = c.yellow })
hl("DiagnosticInfo", { fg = c.cyan })
hl("DiagnosticHint", { fg = c.green })
hl("DiagnosticUnderlineError", { sp = c.red, undercurl = true })
hl("DiagnosticUnderlineWarn", { sp = c.yellow, undercurl = true })
hl("DiagnosticUnderlineInfo", { sp = c.cyan, undercurl = true })
hl("DiagnosticUnderlineHint", { sp = c.green, undercurl = true })

hl("DiffAdd", { fg = c.green, bg = "NONE" })
hl("DiffChange", { fg = c.yellow, bg = "NONE" })
hl("DiffDelete", { fg = c.red, bg = "NONE" })
hl("DiffText", { fg = c.blue, bg = "NONE" })
hl("SignifySignAdd", { fg = c.green })
hl("SignifySignChange", { fg = c.yellow })
hl("SignifySignDelete", { fg = c.red })

hl("TelescopeNormal", { fg = c.fg, bg = c.bg })
hl("TelescopeBorder", { fg = c.purple, bg = c.bg })
hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg })
hl("TelescopePromptBorder", { fg = c.cyan, bg = c.bg })
hl("TelescopePromptTitle", { fg = c.bg, bg = c.cyan })
hl("TelescopePreviewNormal", { fg = c.fg, bg = c.bg })
hl("TelescopePreviewBorder", { fg = c.purple, bg = c.bg })
hl("TelescopeResultsNormal", { fg = c.fg, bg = c.bg })
hl("TelescopeResultsBorder", { fg = c.purple, bg = c.bg })
hl("TelescopeSelection", { fg = c.fg, bg = c.selection })
hl("CmpItemAbbrMatch", { fg = c.cyan, bold = true })
hl("CmpItemKind", { fg = c.purple })

hl("@variable", { fg = c.fg })
hl("@variable.builtin", { fg = c.purple })
hl("@constant", { fg = c.purple })
hl("@string", { fg = c.green })
hl("@number", { fg = c.purple })
hl("@boolean", { fg = c.purple })
hl("@function", { fg = c.green_bright })
hl("@function.builtin", { fg = c.cyan })
hl("@method", { fg = c.green_bright })
hl("@keyword", { fg = c.pink })
hl("@keyword.function", { fg = c.pink })
hl("@operator", { fg = c.pink })
hl("@type", { fg = c.blue })
hl("@property", { fg = c.cyan })
hl("@punctuation", { fg = c.fg })
hl("@comment", { fg = c.muted, italic = true })
hl("@tag", { fg = c.pink })
hl("@tag.attribute", { fg = c.green })

hl("LspReferenceRead", { bg = c.selection })
hl("LspReferenceText", { bg = c.selection })
hl("LspReferenceWrite", { bg = c.selection })
