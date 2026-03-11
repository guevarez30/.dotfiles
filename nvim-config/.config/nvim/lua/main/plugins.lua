-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},

	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash", "c", "css", "go", "gomod", "gosum", "gotmpl",
					"html", "java", "javascript", "json", "lua",
					"markdown", "markdown_inline", "python", "rust",
					"typescript", "tsx", "vim", "vimdoc", "yaml",
				},
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")
			local config = require("nvim-treesitter-textobjects.config")

			config.update({ select = { lookahead = true } })

			-- Select textobjects
			local select_maps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
			}
			for key, query in pairs(select_maps) do
				vim.keymap.set({ "x", "o" }, key, function()
					select.select_textobject(query)
				end, { desc = "Select " .. query })
			end

			-- Move to next/previous textobjects
			vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer") end, { desc = "Next function start" })
			vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer") end, { desc = "Next class start" })
			vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer") end, { desc = "Next function end" })
			vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer") end, { desc = "Next class end" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer") end, { desc = "Previous function start" })
			vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer") end, { desc = "Previous class start" })
			vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer") end, { desc = "Previous function end" })
			vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer") end, { desc = "Previous class end" })

			-- Swap parameters
			vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end, { desc = "Swap with next parameter" })
			vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap with previous parameter" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 3,
				min_window_height = 0,
				line_numbers = true,
				multiline_threshold = 20,
				trim_scope = "outer",
				mode = "cursor",
				separator = nil,
				zindex = 20,
			})
		end,
	},

    {
      "neovim/nvim-lspconfig",
      cmd = "LspInfo", -- Make LspInfo command available immediately
      -- other configurations
    },

	-- CMP
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"onsails/lspkind-nvim",
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- VIM Vinegar
	"tpope/vim-vinegar",

	-- VIM surround
	"tpope/vim-surround",

	-- Fugitive
	"tpope/vim-fugitive",

	-- Git gutter
	"mhinz/vim-signify",

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},

	-- Coloroizer
	"norcalli/nvim-colorizer.lua",

	-- Tmux Integration
	"christoomey/vim-tmux-navigator",

	-- Autoformatter
	"stevearc/conform.nvim",

	"Mofiqul/dracula.nvim",

	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-ui",
	"kristijanhusak/vim-dadbod-completion",

	{
		"oysandvik94/curl.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "CurlOpen" },
		config = true,
	},

	-- CodeCompanion - AI assistant
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					acp = {
						claude_code = function()
							return require("codecompanion.adapters").extend("claude_code", {
								env = {
									CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
								},
							})
						end,
					},
				},
				interactions = {
					chat = {
						adapter = "claude_code",
						opts = {
							system_prompt = "You are a senior software engineer. Be direct and concise. No filler, no preamble, no summaries. Code-only responses unless explanation is explicitly asked for.",
						},
					},
					inline = {
						adapter = "claude_code",
					},
				},
				-- Enable diff approval workflow
				diff = {
					enabled = true,
					provider = "inline", -- Shows changes in floating window (options: inline, split, mini_diff)
				},
				-- Tool approval settings
				tools = {
					["insert_edit_into_file"] = {
						opts = {
							require_approval_before = {
								buffer = true, -- Require approval for buffer edits
								file = true,   -- Require approval for file edits
							},
							require_confirmation_after = true,
						},
					},
					["cmd_runner"] = {
						opts = {
							require_approval_before = true, -- Require approval for command execution
						},
					},
				},
				rules = {
					default = {
						description = "Project rules auto-loaded into every chat",
						files = {
							{ path = "CLAUDE.md", parser = "claude" },
							{ path = "CLAUDE.local.md", parser = "claude" },
							"AGENT.md",
							"AGENTS.md",
							".cursorrules",
						},
					},
					opts = {
						chat = {
							enabled = true,
							autoload = "default",
						},
					},
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle chat" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "Actions palette" })
			vim.keymap.set("v", "<leader>ci", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to chat" })
			vim.cmd([[cab cc CodeCompanion]])
		end,
	},

	-- CodeCompanion - AI assistant
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/codecompanion-history.nvim",
		},
		config = function()
			require("codecompanion").setup({
				adapters = {
					acp = {
						claude_code = function()
							return require("codecompanion.adapters").extend("claude_code", {
								env = {
									CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
								},
							})
						end,
					},
				},
				interactions = {
					chat = {
						adapter = "claude_code",
						opts = {
							system_prompt = "You are a senior software engineer. Be direct and concise. No filler, no preamble, no summaries. Code-only responses unless explanation is explicitly asked for.",
						},
					},
					inline = {
						adapter = "claude_code",
					},
				},
				diff = {
					enabled = true,
					provider = "inline",
				},
				tools = {
					["insert_edit_into_file"] = {
						opts = {
							require_approval_before = {
								buffer = true,
								file = true,
							},
							require_confirmation_after = true,
						},
					},
					["cmd_runner"] = {
						opts = {
							require_approval_before = true,
						},
					},
				},
				rules = {
					default = {
						description = "Project rules auto-loaded into every chat",
						files = {
							{ path = "CLAUDE.md", parser = "claude" },
							{ path = "CLAUDE.local.md", parser = "claude" },
							"AGENT.md",
							"AGENTS.md",
							".cursorrules",
						},
					},
					opts = {
						chat = {
							enabled = true,
							autoload = "default",
						},
					},
				},
				extensions = {
					history = {
						enabled = true,
						opts = {
							keymap = "gh",
							save_chat_keymap = "sc",
							auto_save = true,
							picker = "telescope",
							auto_generate_title = true,
							expiration_days = 0,
						},
					},
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle chat" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "Actions palette" })
			vim.keymap.set("v", "<leader>ci", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to chat" })
			vim.keymap.set("n", "<leader>ch", "<cmd>CodeCompanionHistory<cr>", { desc = "CodeCompanion history" })
			vim.cmd([[cab cc CodeCompanion]])
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				transparent_background = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					telescope = {
						enabled = true,
					},
					harpoon = true,
					mason = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"guevarez30/no-go.nvim",
		branch = "fix/treesitter-query-statement-list",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = "go",
		opts = {
			identifiers = { "err", "error" },
			prefix = " ",
		},
	},

	-- SonarQube LSP
	{
		"iamkarasik/sonarqube.nvim",
		config = function()
			local rules = require("main.sonarqube-rules")
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/sonarlint-language-server/extension"
			require("sonarqube").setup({
				rules = rules,
				lsp = {
					cmd = {
						"java",
						"-jar",
						mason_path .. "/server/sonarlint-ls.jar",
						"-stdio",
						"-analyzers",
						mason_path .. "/analyzers/sonarjava.jar",
						mason_path .. "/analyzers/sonargo.jar",
					},
				},
			})
		end,
	},

})
