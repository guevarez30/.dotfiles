return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	keys = {
		{
			"<leader>p",
			function()
				require("fff").find_files()
			end,
			desc = "Find files",
		},
		{
			"<leader>f",
			function()
				require("fff").live_grep()
			end,
			desc = "Search text",
		},
		{
			"<leader>f",
			function()
				local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
				require("fff").live_grep({ query = table.concat(text, "\n") })
			end,
			mode = "v",
			desc = "Search visual selection",
		},
	},
	opts = {
		lazy_sync = true,
	},
	lazy = false,
}
