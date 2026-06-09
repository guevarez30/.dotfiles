return {
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		config = function()
			vim.api.nvim_create_user_command("DBUIClear", function()
				local paths = {
					vim.fn.stdpath("data") .. "/db_ui/connections.json",
					vim.fn.expand("~/.local/share/nvim/db_ui/connections.json"),
					vim.fn.expand("~/Library/Application Support/nvim/db_ui/connections.json"),
				}

				for _, path in ipairs(paths) do
					if vim.fn.filereadable(path) == 1 then
						vim.fn.delete(path)
						print("Deleted: " .. path)
					end
				end

				if vim.fn.exists(":DBUI") == 2 then
					vim.cmd("DBUI")
				end
			end, { desc = "Clear vim-dadbod-ui connection history" })

			vim.g.dbs = {
				rdp_platform = vim.env.DB_RDP_PLATFORM,
				rdp_catalog_api = vim.env.DB_RDP_CATALOG_API,
				rdp_backend = vim.env.DB_RDP_BACKEND,
			}
		end,
	},
}
