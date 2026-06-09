return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
	keys = {
		{ "<leader>cc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "CodeCompanion chat" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		interactions = {
			chat = {
				adapter = "codex",
			},
		},
		adapters = {
			acp = {
				codex = function()
					return require("codecompanion.adapters").extend("codex", {
						commands = {
							default = {
								"codex-acp",
								"-c",
								"project_doc_max_bytes=0",
							},
						},
						defaults = {
							auth_method = "chatgpt",
						},
					})
				end,
			},
		},
	},
}
