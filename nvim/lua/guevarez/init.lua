-- Install plugins
require("guevarez.plugins")

-- Vim Defaults
require("guevarez.set")
require("guevarez.colors")

-- Plugins
require("guevarez.telescope")
require("guevarez.lspconfig")
require("guevarez.treesitter")
require("guevarez.lualine")
require("guevarez.signify")
require("guevarez.conform")

-- After
require("guevarez.maps")

-- Commands
local cmd = vim.cmd

-- Auto update on file change
cmd([[autocmd FocusGained * :checktime]])

-- Line number highlight
cmd([[highlight clear LineNr]])

-- Handlebars
vim.g.mustache_abbreviations = 1

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
