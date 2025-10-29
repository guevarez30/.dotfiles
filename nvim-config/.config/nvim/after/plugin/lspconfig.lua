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
local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

-- Add templ file type
vim.filetype.add({ extension = { templ = "templ" } })

require("mason").setup()

-- Python
vim.lsp.config.pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	on_attach = on_attach,
	flags = lsp_flags,
}

-- TypeScript
vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	on_attach = on_attach,
	flags = lsp_flags,
}

-- Tailwind CSS
vim.lsp.config.tailwindcss = {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = { "templ", "astro", "javascript", "typescript", "react", "javascriptreact" },
	init_options = { userLanguages = { templ = "html" } },
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Rust
vim.lsp.config.rust_analyzer = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
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
}

-- Templ
vim.lsp.config.templ = {
	cmd = { "templ", "lsp" },
	filetypes = { "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
}

-- Go
vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "templ" },
	on_attach = on_attach,
	flags = lsp_flags,
}

-- Ember
vim.lsp.config.ember = {
	cmd = { "ember-language-server", "--stdio" },
	filetypes = { "handlebars", "html.handlebars" },
	on_attach = on_attach,
	flags = lsp_flags,
}

-- ESLint
vim.lsp.config.eslint = {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		codeActionOnSave = {
			enable = true,
			mode = "all",
		},
	},
}

-- HTML
vim.lsp.config.html = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
}

-- HTMX
vim.lsp.config.htmx = {
	cmd = { "htmx-lsp" },
	filetypes = { "html", "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
}

-- CSS
vim.lsp.config.cssls = {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	capabilities = capabilities,
}

-- Enable all configured language servers
vim.lsp.enable({
	"pyright",
	"ts_ls",
	"tailwindcss",
	"rust_analyzer",
	"templ",
	"gopls",
	"ember",
	"eslint",
	"html",
	"htmx",
	"cssls",
})
