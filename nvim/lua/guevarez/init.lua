require("guevarez.set")

-- Install plugins
require("guevarez.plugins")

vim.filetype.add({ extension = { templ = "templ" } })

-- Plugins
require("guevarez.colors")
require("guevarez.telescope")
require("guevarez.lspconfig")
require("guevarez.treesitter")
require("guevarez.lualine")
require("guevarez.signify")
require("guevarez.conform")
require("guevarez.maps")

-- Commands
local cmd = vim.cmd

-- Auto update on file change
cmd([[autocmd FocusGained * :checktime]])

-- Line number highlight
cmd([[highlight clear LineNr]])

-- Handlebars
vim.g.mustache_abbreviations = 1

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
