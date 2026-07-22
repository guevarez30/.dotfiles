return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
	keys = {
		{ "<leader>cc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "CodeCompanion chat" },
		{ "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion chat" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		interactions = {
			chat = {
				adapter = "codex",
				slash_commands = {
					resume = {
						opts = {
							max_sessions = 5,
						},
					},
				},
			},
		},
		rules = {
			goose = {
				description = "Goose: guide the user through code changes one step at a time",
				parser = "none",
				files = {
					vim.fn.stdpath("config") .. "/rules/goose.md",
				},
			},
			opts = {
				chat = {
					enabled = true,
					autoload = { "goose" },
				},
			},
		},
		adapters = {
			acp = {
				codex = function()
					local codex_acp = vim.fn.exepath("codex-acp")
					if codex_acp == "" then
						codex_acp = "codex-acp"
					end

					return require("codecompanion.adapters").extend("codex", {
						commands = {
							default = {
								codex_acp,
								"-c",
								"project_doc_max_bytes=0",
							},
						},
						defaults = {
							auth_method = "chatgpt",
							timeout = 60000,
						},
					})
				end,
			},
		},
	},
}
