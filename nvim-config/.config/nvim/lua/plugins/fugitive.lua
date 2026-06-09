return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>gg", "<cmd>Git<cr>", desc = "Git status" },
		{ "<leader>gd", "<cmd>Gvdiffsplit!<cr>", desc = "Git diff split" },
		{ "<leader>gv", "<cmd>Gvdiffsplit origin/dev:%<cr>", desc = "Diff file vs origin/dev" },
		{ "<leader>gp", "<cmd>Git -c push.default=current push<cr>", desc = "Git push current branch" },
		{ "<leader>gl", "<cmd>Git log -n 20 --decorate<cr>", desc = "Git log" },
		{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
		{
			"<leader>gr",
			function()
				local files = vim.fn.systemlist("git diff --name-only origin/dev...HEAD")
				local qf_list = {}
				for _, file in ipairs(files) do
					table.insert(qf_list, { filename = file, lnum = 1 })
				end

				vim.fn.setqflist({}, "r", { title = "Branch review vs origin/dev", items = qf_list })
				vim.cmd("copen")
			end,
			desc = "Review branch vs origin/dev",
		},
	},
}
