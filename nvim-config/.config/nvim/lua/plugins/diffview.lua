return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewFileHistory",
	},
	keys = {
		{ "<leader>dvo", "<cmd>DiffviewOpen origin/dev<cr>", desc = "Diffview origin/dev" },
		{ "<leader>dvc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
	},
}
