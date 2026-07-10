local function cmd_path(name, fallback)
	local path = vim.fn.exepath(name)
	if path ~= "" then
		return path
	end
	return vim.fn.expand(fallback)
end

local function on_attach(_, bufnr)
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, bufopts)
	vim.keymap.set("n", "gt", require("telescope.builtin").lsp_type_definitions, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, bufopts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename symbol" }))
	vim.keymap.set("n", "<leader>ls", require("telescope.builtin").lsp_document_symbols, bufopts)
	vim.keymap.set("n", "<leader>lS", require("telescope.builtin").lsp_dynamic_workspace_symbols, bufopts)
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		vim.diagnostic.config({
			underline = false,
			virtual_text = true,
			signs = false,
			update_in_insert = false,
		})

		vim.keymap.set("n", "E", vim.diagnostic.open_float, { noremap = true, silent = true, desc = "Line diagnostics" })
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, { noremap = true, silent = true, desc = "Previous diagnostic" })
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, { noremap = true, silent = true, desc = "Next diagnostic" })

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		local lsp_flags = {
			debounce_text_changes = 150,
		}

		vim.filetype.add({
			extension = { templ = "templ" },
			filename = {
				["compose.yaml"] = "yaml.docker-compose",
				["compose.yml"] = "yaml.docker-compose",
				["docker-compose.yaml"] = "yaml.docker-compose",
				["docker-compose.yml"] = "yaml.docker-compose",
			},
		})

		local servers = {
			lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
			pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
			},
			ts_ls = {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
			},
			dockerls = {
				cmd = { "docker-langserver", "--stdio" },
				filetypes = { "dockerfile" },
			},
			docker_compose_language_service = {
				cmd = { "docker-compose-langserver", "--stdio" },
				filetypes = { "yaml.docker-compose" },
			},
			helm_ls = {
				cmd = { "helm_ls", "serve" },
				filetypes = { "helm" },
			},
			yamlls = {
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yaml.docker-compose" },
				settings = {
					yaml = {
						keyOrdering = false,
					},
				},
			},
			tailwindcss = {
				cmd = { "tailwindcss-language-server", "--stdio" },
				filetypes = { "templ", "astro", "javascript", "typescript", "react", "javascriptreact" },
				init_options = { userLanguages = { templ = "html" } },
			},
			rust_analyzer = {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },
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
			},
			templ = {
				cmd = { "templ", "lsp" },
				filetypes = { "templ" },
			},
			gopls = {
				cmd = { cmd_path("gopls", "~/go/bin/gopls") },
				filetypes = { "go", "templ" },
			},
			eslint = {
				cmd = { "vscode-eslint-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
				settings = {
					codeActionOnSave = {
						enable = true,
						mode = "all",
					},
				},
			},
			html = {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html", "templ" },
			},
			htmx = {
				cmd = { "htmx-lsp" },
				filetypes = { "html", "templ" },
			},
			cssls = {
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
			},
		}

		for name, settings in pairs(servers) do
			settings.on_attach = on_attach
			settings.capabilities = capabilities
			settings.flags = settings.flags or lsp_flags
			vim.lsp.config(name, settings)
		end

		vim.lsp.enable(vim.tbl_keys(servers))
	end,
}
