-- Only required if you have packer configured as `opt`
vim.cmd("packadd packer.nvim")

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Themes
	use("EdenEast/nightfox.nvim")
	use({ "catppuccin/nvim", as = "catppuccin" })
	-- Using Packer
	use("navarasu/onedark.nvim")

	-- Harpoon
	use("ThePrimeagen/harpoon")

	-- Lua line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
	})

	-- Tree sitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	use("nvim-treesitter/nvim-treesitter-context")

	-- CMP
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("onsails/lspkind-nvim")
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	-- Go
	use({ "fatih/vim-go", run = ":GoUpdateBinaries" })
	-- VIM Vinegar
	use("tpope/vim-vinegar")
	-- VIM surround
	use("tpope/vim-surround")
	-- VIM comment
	use("tpope/vim-commentary")
	-- Fugitive
	use("tpope/vim-fugitive")
	-- Git gutter
	use("mhinz/vim-signify")
	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	-- Coloroizer
	use("norcalli/nvim-colorizer.lua")
	-- Tmux Integration
	use("christoomey/vim-tmux-navigator")
	-- Autoformatter
	use("stevearc/conform.nvim")

	use("mustache/vim-mustache-handlebars")
end)
