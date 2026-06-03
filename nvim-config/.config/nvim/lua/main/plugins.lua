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
		lazy = false,
		config = function()
			local parsers = {
				"bash", "c", "css", "go", "gomod", "gosum", "gotmpl",
				"helm", "html", "java", "javascript", "json", "lua",
				"markdown", "markdown_inline", "python", "rust",
				"typescript", "tsx", "vim", "vimdoc", "yaml",
			}

			require("nvim-treesitter").setup({
				ensure_installed = parsers,
				auto_install = true,
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "an",
						node_incremental = "an",
						node_decremental = "in",
						scope_incremental = false,
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
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

	"tpope/vim-dadbod",
	"kristijanhusak/vim-dadbod-ui",
	"kristijanhusak/vim-dadbod-completion",

	-- CodeCompanion chat integration
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"MunifTanjim/nui.nvim",
		},
		cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
		keys = {
			{
				"<leader>cc",
				"<cmd>CodeCompanionChat Toggle<cr>",
				desc = "Toggle CodeCompanion",
				mode = { "n", "t" },
			},
		},
		opts = {
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
			interactions = {
				chat = {
					adapter = "codex",
				},
				inline = {
					adapter = "codex",
				},
			},
		},
	},

	{
		"Mofiqul/dracula.nvim",
		name = "dracula",
		priority = 1000,
		config = function()
			require("dracula").setup({
				transparent_bg = true,
			})
			vim.cmd.colorscheme("dracula")
		end,
	},

	{
	  "MeanderingProgrammer/render-markdown.nvim",
	  dependencies = {
	    "nvim-treesitter/nvim-treesitter",
	    "nvim-mini/mini.nvim",
	  },
	  ft = { "markdown" },
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
	        enabled = true,
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
