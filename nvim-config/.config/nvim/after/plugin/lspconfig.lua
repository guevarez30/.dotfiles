local opts = { noremap = true, silent = true }

vim.diagnostic.config({
	underline = false,
	virtual_text = true,
	signs = false,
	update_in_insert = false,
})

vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, opts)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, opts)

local on_attach = function(_, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, bufopts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_flags = {
	debounce_text_changes = 150,
}

local function cmd_path(name, fallback)
	local path = vim.fn.exepath(name)
	if path ~= "" then
		return path
	end
	return vim.fn.expand(fallback)
end

local function config(name, settings)
	vim.lsp.config(name, settings)
end

vim.filetype.add({ extension = { templ = "templ" } })

require("mason").setup()

config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	on_attach = on_attach,
	flags = lsp_flags,
})

config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	on_attach = on_attach,
	capabilities = capabilities,
	flags = lsp_flags,
})

config("tailwindcss", {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = { "templ", "astro", "javascript", "typescript", "react", "javascriptreact" },
	init_options = { userLanguages = { templ = "html" } },
	on_attach = on_attach,
	capabilities = capabilities,
})

config("rust_analyzer", {
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
})

config("templ", {
	cmd = { "templ", "lsp" },
	filetypes = { "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
})

config("gopls", {
	cmd = { cmd_path("gopls", "~/go/bin/gopls") },
	filetypes = { "go", "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
	flags = lsp_flags,
})

config("eslint", {
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
})

config("html", {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
})

config("htmx", {
	cmd = { "htmx-lsp" },
	filetypes = { "html", "templ" },
	on_attach = on_attach,
	capabilities = capabilities,
})

config("cssls", {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	on_attach = on_attach,
	capabilities = capabilities,
})

vim.lsp.enable({
	"pyright",
	"ts_ls",
	"tailwindcss",
	"rust_analyzer",
	"templ",
	"gopls",
	"eslint",
	"html",
	"htmx",
	"cssls",
})
