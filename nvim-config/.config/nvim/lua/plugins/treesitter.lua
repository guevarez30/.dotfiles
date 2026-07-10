local parsers = {
	"bash",
	"css",
	"dockerfile",
	"go",
	"gomod",
	"gosum",
	"helm",
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
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			highlight = {
				enable = true,
				disable = function(lang)
					return not pcall(vim.treesitter.language.inspect, lang)
				end,
			},
			indent = {
				enable = true,
				disable = function(lang)
					return not pcall(vim.treesitter.language.inspect, lang)
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
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
		},
	},
}
