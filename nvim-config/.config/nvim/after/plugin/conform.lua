local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		typescript = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		json = { "prettier" },
		go = { "goimports", "gofmt" },
		rust = { "rustfmt" },
		python = { "autopep8" },
		templ = { "templ" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		["_"] = { "trim_whitespace" },
	},
})
