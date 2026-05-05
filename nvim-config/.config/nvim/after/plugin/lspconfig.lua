local opts = { noremap = true, silent = true }

vim.diagnostic.config({
	underline = false,
	virtual_text = {
		spacing = 2,
		source = "if_many",
	},
	signs = false,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
})

vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, opts)
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "grt", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references({}) end, bufopts)
	vim.keymap.set("n", "grx", vim.lsp.codelens.run, bufopts)

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
		local group = vim.api.nvim_create_augroup("DotfilesLspCodeLens" .. bufnr, { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
			group = group,
			buffer = bufnr,
			callback = function()
				vim.lsp.codelens.enable(true, { bufnr = bufnr })
			end,
		})
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end

	if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

--Enable (broadcasting) snippet capability for completion
local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
	capabilities = capabilities,
	flags = lsp_flags,
	workspace_required = true,
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
			check = {
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
	on_attach = function(client, bufnr)
		-- Disable gopls formatting in favor of conform.nvim
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
	flags = lsp_flags,
	settings = {
		gopls = {
			gofumpt = true, -- Use gofumpt-style formatting when gopls does format
		},
	},
}

-- ESLint
vim.lsp.config.eslint = {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
	on_attach = on_attach,
	capabilities = capabilities,
	workspace_required = true,
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
	on_attach = on_attach,
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
	"eslint",
	"html",
	"htmx",
	"cssls",
})
