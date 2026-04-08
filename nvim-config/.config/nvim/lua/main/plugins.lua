-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

local function get_bookmark_file(dir)
	dir = dir or vim.fn.getcwd()
	local result = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel")
	if vim.v.shell_error == 0 and result[1] and result[1] ~= "" then
		return result[1] .. "/.bookmarks"
	end
	return dir .. "/.bookmarks"
end

-- Setup lazy.nvim
require("lazy").setup({
{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
	},

	"williamboman/mason.nvim",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter").setup({})
			-- Install parsers
			local parsers = {
				"bash", "c", "css", "go", "gomod", "gosum", "gotmpl",
				"html", "java", "javascript", "json", "lua",
				"markdown", "markdown_inline", "python", "rust",
				"typescript", "tsx", "vim", "vimdoc", "yaml",
			}
			local installed = require("nvim-treesitter.config").get_installed()
			local to_install = vim.tbl_filter(function(p)
				return not vim.list_contains(installed, p)
			end, parsers)
			if #to_install > 0 then
				require("nvim-treesitter.install").install(to_install)
			end

			-- Enable treesitter highlighting
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
			-- Start on the current buffer (which triggered the load)
			pcall(vim.treesitter.start)
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

	-- Bookmarks with Telescope integration
	{
		"tomasky/bookmarks.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			local bm_config = require("bookmarks.config")
			local bm        = require("bookmarks")

			bm.setup({
				save_file = get_bookmark_file(),
				keywords = {
					["@t"] = "☑ ",
					["@w"] = "⚠ ",
					["@f"] = "⛏ ",
					["@n"] = " ",
				},
			})

			local telescope = require("telescope").load_extension("bookmarks")
			vim.keymap.set("n", "]m", bm.bookmark_next,   { desc = "Next bookmark" })
			vim.keymap.set("n", "[m", bm.bookmark_prev,   { desc = "Previous bookmark" })
			vim.keymap.set("n", "mm", bm.bookmark_toggle, { desc = "Toggle bookmark" })
			vim.keymap.set("n", "ma", bm.bookmark_ann,    { desc = "Bookmark with annotation" })
			vim.keymap.set("n", "mc", bm.bookmark_clean,  { desc = "Clear all bookmarks in file" })
			vim.keymap.set("n", "mx", function()
				bm.bookmark_clear_all()
				bm.refresh()
			end, { desc = "Clear all bookmarks" })
			vim.keymap.set("n", "ml", telescope.list, { desc = "List all bookmarks" })

			vim.api.nvim_create_autocmd("DirChanged", {
				group = vim.api.nvim_create_augroup("BookmarksProjectLocal", { clear = true }),
				callback = function(ev)
					local new_file = get_bookmark_file(ev.file)
					if new_file ~= bm_config.config.save_file then
						bm_config.config.save_file = new_file
						bm_config.config.cache = { data = {} }
						require("bookmarks.actions").loadBookmarks()
						bm.refresh()
					end
				end,
			})
		end,
	},

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
				display = {
					chat = {
						fold_reasoning = false,
						show_reasoning = false,
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
			-- Read theme from config file, default to mocha
			local theme_file = io.open(vim.fn.expand("~/.config/theme"), "r")
			local flavour = "mocha"
			if theme_file then
				flavour = theme_file:read("*l") or "mocha"
				theme_file:close()
			end
			
			require("catppuccin").setup({
				flavour = flavour,
				transparent_background = true,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					telescope = {
						enabled = true,
					},
					mason = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
})
