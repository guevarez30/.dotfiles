-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, bufopts)
end

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

-- Add templ file type
vim.filetype.add({ extension = { templ = "templ" } })

require("mason").setup()

require("lspconfig")["pyright"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
	filetypes = { "python" },
})

require("lspconfig")["ts_ls"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
})

require("lspconfig")["tailwindcss"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "templ", "astro", "javascript", "typescript", "react", "javascriptreact" },
	init_options = { userLanguages = { templ = "html" } },
})

require("lspconfig")["rust_analyzer"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				disabled = { "unresolved-import" },
			},
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

require("lspconfig")["templ"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

require("lspconfig")["gopls"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
	filetypes = { "go", "templ" },
})

-- Ember Set Up
require("lspconfig")["ember"].setup({
	on_attach = on_attach,
	flags = lsp_flags,
	filetypes = { "handlebars", "html.handlebars" },
})

require("lspconfig").eslint.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		codeActionOnSave = {
			enable = true,
			mode = "all",
		},
	},
})

require("lspconfig").html.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "templ" },
})

require("lspconfig").htmx.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "templ" },
})

require("lspconfig").cssls.setup({
	capabilities = capabilities,
})
