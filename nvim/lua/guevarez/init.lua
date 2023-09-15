-- Install plugins 
require("guevarez.plugins")

-- Vim Defaults
require("guevarez.set")
-- Vim Colorscheme
require("guevarez.colors")

-- Plugins
require("guevarez.telescope")
require("guevarez.lspconfig")
require("guevarez.treesitter")
require("guevarez.lualine")
require("guevarez.signify")
require('nvim-ts-autotag').setup()

-- Vim Remap
require("guevarez.maps")


vim.cmd[[highlight clear LineNr]]

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = true,
    signs = false,
    update_in_insert = false,
  }
)

