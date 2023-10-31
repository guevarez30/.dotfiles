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

-- After
require("guevarez.maps")

-- Commands
local cmd = vim.cmd

-- Standard File Save For Shift4
local current_directory = vim.fn.getcwd()
if string.match(current_directory, "loads") then
	cmd([[autocmd BufWritePre,FileWritePre *.jsx,*.js EslintFixAll]])
end

-- Auto update on file change
cmd([[autocmd FocusGained * :checktime]])

-- Line number highlight
cmd([[highlight clear LineNr]])

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
