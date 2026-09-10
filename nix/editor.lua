-- Plugins, parsers, servers and formatters are built with the Nix generation.
-- Keep downloads and mutable plugin lockfiles out of shell/editor startup.
vim.g.mapleader = " "
-- Reuse the repo's plugin options and keymaps without starting Lazy or downloads.
local function configurePlugin(module, spec)
  if type(spec[1]) == "table" then
    for _, entry in ipairs(spec) do configurePlugin(module, entry) end
    return
  end
  local opts = type(spec.opts) == "function" and spec.opts(spec, {}) or spec.opts or {}
  if type(spec.config) == "function" then
    spec.config(spec, opts)
  elseif spec.opts or spec.config == true then
    require(module).setup(opts)
  end
  for _, key in ipairs(spec.keys or {}) do
    vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc, silent = true })
  end
end
require("nvim-autopairs").setup({})
require("treesitter-context").setup({ max_lines = 3 })

local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  formatting = { format = require("lspkind").cmp_format() },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, {
    { name = "buffer" }, { name = "path" },
  }),
})
cmp.setup.filetype("sql", { sources = { { name = "vim-dadbod-completion" }, { name = "buffer" } } })

vim.filetype.add({ extension = { templ = "templ" } })
vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
vim.lsp.config("gopls", { filetypes = { "go", "gomod", "gowork", "gotmpl", "templ" } })
vim.lsp.config("helm_ls", { filetypes = { "helm", "gotmpl" } })
vim.lsp.config("tailwindcss", { init_options = { userLanguages = { templ = "html" } } })
vim.lsp.enable({
  "gopls", "templ", "pyright", "ruff", "ts_ls", "tailwindcss", "eslint",
  "html", "cssls", "htmx", "yamlls", "helm_ls", "rust_analyzer", "jdtls",
  "lua_ls", "nil_ls",
})
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  end,
})
vim.keymap.set("n", "E", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)

-- Native highlighting uses the parsers supplied by Nix for either plugin API.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    pcall(vim.treesitter.start, event.buf)
  end,
})
