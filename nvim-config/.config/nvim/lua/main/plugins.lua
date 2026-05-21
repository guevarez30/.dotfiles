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
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	"williamboman/mason.nvim",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			})
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
	"neovim/nvim-lspconfig",
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
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
			vim.keymap.set("n", "]b", bm.bookmark_next,   { desc = "Next bookmark" })
			vim.keymap.set("n", "[b", bm.bookmark_prev,   { desc = "Previous bookmark" })
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

	-- Tmux Integration
	"christoomey/vim-tmux-navigator",

	-- Autoformatter
	"stevearc/conform.nvim",

	{
		"olimorris/codecompanion.nvim",
		version = "^19.0.0",
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
		keys = {
			{ "<leader>cc", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
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
							defaults = {
								auth_method = "chatgpt",
							},
						})
					end,
				},
			},
		},
	},

	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-ui",
	"kristijanhusak/vim-dadbod-completion",

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
					native_lsp = {
						enabled = true,
					},
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
	{
	  "MeanderingProgrammer/render-markdown.nvim",
	  dependencies = {
	    "nvim-treesitter/nvim-treesitter",
	    "nvim-mini/mini.nvim",
	  },
	  ft = { "markdown", "codecompanion" },
	  config = function()
	    require("render-markdown").setup({
	      heading = {
	        sign = false,
	        icons = {},
	      },
	      bullet = {
	        enabled = true,
	      },
	      quote = {
	        enabled = true,
	      },
	      indent = {
	        enabled = false,
	      },
	      code = {
	        sign = false,
	        border = "none",
	        width = "full",
	      },
	    })
	  end,
	}


})
