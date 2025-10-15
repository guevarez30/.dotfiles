local cmd = vim.cmd

-- Auto update on file change
cmd([[autocmd FocusGained * :checktime]])
cmd([[highlight clear LineNr]])

-- Auto format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("WinResized", {
	pattern = "*",
	command = "wincmd =",
})

-- Prevent automatic comment continuation
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

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
