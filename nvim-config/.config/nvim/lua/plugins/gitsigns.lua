return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "_" },
			changedelete = { text = "~" },
			untracked = { text = "+" },
		},
		sign_priority = 20,
	},
	config = function(_, opts)
		vim.keymap.set("n", "<leader>gq", function()
			require("gitsigns").setqflist("all")
		end, { desc = "Git hunks to quickfix" })

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = function()
				vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#50fa7b", bg = "NONE", bold = true })
				vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#8be9fd", bg = "NONE", bold = true })
				vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff5555", bg = "NONE", bold = true })
				vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
			end,
		})

		vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name or "*" })
		require("gitsigns").setup(opts)
	end,
}
