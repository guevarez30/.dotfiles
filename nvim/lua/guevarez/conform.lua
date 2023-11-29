local conform = require("conform")
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { { "eslint_d", "standardjs" } },
		go = { "gofmt" },
		rust = { "rustfmt" },
		["_"] = { "trim_whitespace" },
	},
})
