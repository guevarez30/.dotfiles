return {
	"williamboman/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup()

		require("mason-tool-installer").setup({
			ensure_installed = {
				"autopep8",
				"css-lsp",
				"docker-compose-language-service",
				"dockerfile-language-server",
				"eslint-lsp",
				"gofumpt",
				"goimports",
				"gopls",
				"helm-ls",
				"html-lsp",
				"lua-language-server",
				"prettier",
				"pyright",
				"rust-analyzer",
				"stylua",
				"typescript-language-server",
				"yaml-language-server",
			},
			auto_update = false,
			run_on_start = false,
			start_delay = 0,
			debounce_hours = 24,
		})

		vim.api.nvim_create_user_command("StarterInstall", function()
			vim.cmd("MasonToolsInstall")
			pcall(vim.cmd, "Lazy load nvim-treesitter")
			vim.cmd("StarterTreesitterInstall")
		end, { desc = "Install starter Mason tools and Tree-sitter parsers" })

		vim.keymap.set("n", "<leader>li", "<cmd>StarterInstall<CR>", { desc = "Install starter tools" })
	end,
}
