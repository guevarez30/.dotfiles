require("main.plugins")
require("main.set")
require("main.maps")

-- Commands
local cmd = vim.cmd

-- Auto update on file change
cmd([[autocmd FocusGained * :checktime]])
cmd([[highlight clear LineNr]])

-- Handlebars
vim.g.mustache_abbreviations = 1

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

vim.api.nvim_create_autocmd("WinResized", {
	pattern = "*",
	command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})
