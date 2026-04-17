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
				local parsers = {
					"bash", "c", "css", "go", "gomod", "gosum", "gotmpl",
					"html", "java", "javascript", "json", "lua",
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

	-- Codex terminal integration
	{
		"johnseth97/codex.nvim",
		cmd = { "Codex", "CodexToggle" },
		keys = {
			{
				"<leader>cc",
				function()
					require("codex").toggle()
				end,
				desc = "Toggle Codex",
				mode = { "n", "t" },
			},
		},
		opts = {
			keymaps = {
				toggle = nil,
			},
			border = "rounded",
			width = 0.35,
			autoinstall = false,
			panel = true,
		},
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
