local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		typescript = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		json = { "prettier" },
		go = { "gofmt" },
	 	rust = { "rustfmt" },
		python = { "autopep8" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		["_"] = { "trim_whitespace" },
	},
	-- custom formatter configs
	formatters = {
		stylua = {
			prepend_args = {} 
		},
	},
})

-- Templ
local templ_format = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local cmd = "templ fmt " .. vim.fn.shellescape(filename)

	vim.fn.jobstart(cmd, {
		on_exit = function()
			-- Reload the buffer only if it's still the current buffer
			if vim.api.nvim_get_current_buf() == bufnr then
				vim.cmd("e!")
			end
		end,
	})
end
vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = templ_format })

