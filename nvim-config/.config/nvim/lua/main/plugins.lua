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

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	"nvim-treesitter/nvim-treesitter-context",


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
			local autopairs = require("nvim-autopairs")
			autopairs.setup({})
			-- Disable autopairs for ( and [
			local Rule = require("nvim-autopairs.rule")
			autopairs.remove_rule("(")
			autopairs.remove_rule("[")
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
		tag = "0.1.4",
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
		config = function()
			require("curl").setup({
				open_with = "buffer",
				default_flags = { "-i", "-S" },
			})

			-- Auto-execute curl on save (runs command under cursor)
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.curl",
				callback = function()
					local line = vim.api.nvim_get_current_line()
					if line:match("^curl%s") then
						pcall(require("curl.api").execute_curl)
					end
				end,
			})
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin-macchiato",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
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
		end,
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
