local parsers = {
	"bash",
	"css",
	"dockerfile",
	"go",
	"gomod",
	"gosum",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"rust",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		lazy = false,
		opts = {
			highlight = {
				enable = true,
				disable = function(lang)
					return lang == "helm" or not pcall(vim.treesitter.language.inspect, lang)
				end,
			},
			indent = {
				enable = true,
				disable = function(lang)
					return lang == "helm" or not pcall(vim.treesitter.language.inspect, lang)
				end,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
			vim.api.nvim_create_user_command("StarterTreesitterInstall", function()
				vim.cmd("TSInstall " .. table.concat(parsers, " "))
			end, { desc = "Install starter Tree-sitter parsers" })
		end,
	},
}
