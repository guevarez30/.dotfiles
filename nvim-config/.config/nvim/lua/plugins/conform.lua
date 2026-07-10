return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			typescript = { "prettier" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			json = { "prettier" },
			go = { "goimports", "gofumpt" },
			rust = { "rustfmt" },
			python = { "autopep8" },
			templ = { "templ" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			["_"] = { "trim_whitespace" },
		},
	},
}
