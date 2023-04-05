-- Install plugins 
require("guevarez.plugins")

-- Vim Defaults
require("guevarez.set")
-- Vim Remap
require("guevarez.maps")
-- Vim Colorscheme
require("guevarez.colors")

-- Plugins
require("guevarez.telescope")
require("guevarez.lspconfig")
require("guevarez.treesitter")
require("guevarez.test")
require("guevarez.lualine")
require("guevarez.signify")

vim.cmd[[highlight clear LineNr]]

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = true,
    signs = false,
    update_in_insert = false,
  }
)
