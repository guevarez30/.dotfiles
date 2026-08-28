return {
	"cbochs/grapple.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", lazy = true },
	},
	event = { "BufReadPost", "BufNewFile" },
	cmd = "Grapple",
	opts = {
		scope = "git",
		style = "relative",
		win_opts = {
			focusable = true,
		},
	},
	keys = {
		{ "mm", "<cmd>Grapple toggle<cr>", desc = "Grapple toggle file" },
		{
			"ml",
			function()
				if vim.bo.filetype == "grapple" then
					vim.cmd.close()
					return
				end

				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].filetype == "grapple" then
						vim.api.nvim_set_current_win(win)
						return
					end
				end

				require("grapple").open_tags()
			end,
			desc = "Grapple files",
		},
		{ "]b", "<cmd>Grapple cycle_tags next<cr>", desc = "Next grapple file" },
		{ "[b", "<cmd>Grapple cycle_tags prev<cr>", desc = "Previous grapple file" },
		{ "m1", "<cmd>Grapple select index=1<cr>", desc = "Grapple file 1" },
		{ "m2", "<cmd>Grapple select index=2<cr>", desc = "Grapple file 2" },
		{ "m3", "<cmd>Grapple select index=3<cr>", desc = "Grapple file 3" },
		{ "m4", "<cmd>Grapple select index=4<cr>", desc = "Grapple file 4" },
		{ "m5", "<cmd>Grapple select index=5<cr>", desc = "Grapple file 5" },
	},
}
