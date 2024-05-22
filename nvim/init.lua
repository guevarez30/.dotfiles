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

-- DB
vim.g.dbs = {
	{ name = "dev", url = "postgres://echoprodev:KbxRRnhXaVYPJi9xDwGMF4pUzZHebK@localhost:5432/echoprodev" },
	{ name = "test", url = "postgres://echoprodev@localhost:5432/echoprodevtest" },
	{
		name = "staging",
		url = "postgres://echoprodev:KbxRRnhXaVYPJi9xDwGMF4pUzZHebK@lh-staging-db-pool.shift4payments.internal/echoprodev",
	},
}

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
