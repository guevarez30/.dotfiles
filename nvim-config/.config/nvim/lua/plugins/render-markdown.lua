return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.nvim",
	},
	ft = { "markdown", "codecompanion" },
	opts = {
		heading = {
			sign = false,
			icons = {},
		},
		bullet = {
			enabled = true,
		},
		quote = {
			enabled = true,
		},
		indent = {
			enabled = false,
		},
		code = {
			sign = false,
			border = "none",
			width = "full",
		},
	},
}
