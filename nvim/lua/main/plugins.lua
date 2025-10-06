-- Only required if you have packer configured as `opt`
vim.cmd("packadd packer.nvim")

return require("packer").startup(function()
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	use("ThePrimeagen/harpoon")

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	use({
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
	})

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

	-- Fugitive
	use("tpope/vim-fugitive")

	-- Git gutter
	use("mhinz/vim-signify")

	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Coloroizer
	use("norcalli/nvim-colorizer.lua")

	-- Tmux Integration
	use("christoomey/vim-tmux-navigator")

	-- Autoformatter
	use("stevearc/conform.nvim")

	use("mustache/vim-mustache-handlebars")

	use 'Mofiqul/dracula.nvim'


	use 'tpope/vim-dadbod'
	use 'kristijanhusak/vim-dadbod-ui'
	use 'kristijanhusak/vim-dadbod-completion'

	-- Luarocks support
	use("vhyrro/luarocks.nvim")

	-- Image viewing
	use({
		"3rd/image.nvim",
		requires = { "luarocks.nvim" },
		config = function()
			require("image").setup({
				backend = "ueberzugpp",
				max_width = 100,
				max_height = 12,
				max_height_window_percentage = math.huge,
				max_width_window_percentage = math.huge,
				window_overlap_clear_enabled = true,
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
				editor_only_render_when_focused = false,
				tmux_show_only_in_active_window = true,
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif", "*.svg" },
			})
		end,
	})

end)
