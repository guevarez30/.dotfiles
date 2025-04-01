local set = vim.opt

set.nu = true
set.relativenumber = true
set.hlsearch = false
set.incsearch = true
set.hidden = true
set.errorbells = false
set.smartindent = true
set.wrap = false
set.swapfile = false
set.backup = false
set.undofile = true
set.showmode = false
set.showmatch = true
set.ruler = true
set.smarttab = true
set.autoread = true
set.cursorline = true
set.termguicolors = true
set.clipboard = "unnamedplus"
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = false -- Use actual tab characters
set.copyindent = true
set.preserveindent = true
set.scrolloff = 8

-- Prevent automatic comment continuation
set.formatoptions:remove("o")
set.formatoptions:remove("r")

-- Fix indentation for CSS, SCSS, and similar files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "css", "scss", "sass", "less" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = false -- Ensure tabs, not spaces
	end,
})
