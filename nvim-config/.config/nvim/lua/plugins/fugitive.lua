return {
	"tpope/vim-fugitive",
	cmd = {
		"G",
		"Git",
		"Gdiffsplit",
		"Gvdiffsplit",
		"Ghdiffsplit",
	},
	keys = {
		{ "<leader>gg", "<cmd>Git<cr>", desc = "Git status" },
		{ "<leader>gp", "<cmd>Git -c push.default=current push<cr>", desc = "Git push current branch" },
		{ "<leader>gl", "<cmd>Git log -n 20 --decorate<cr>", desc = "Git log" },
		{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
	},
}
