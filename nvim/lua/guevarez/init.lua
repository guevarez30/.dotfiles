-- Install plugins 
require("guevarez.plugins")

-- Vim Defaults
require("guevarez.set")
require("guevarez.colors")

-- Plugins
require("guevarez.telescope")
require("guevarez.lspconfig")
require("guevarez.treesitter")
require("guevarez.lualine")
require("guevarez.signify")

-- After
require("guevarez.maps")

-- Commands
local cmd = vim.cmd
-- Standard File Save
local current_directory = vim.fn.getcwd()
if string.match(current_directory, "loads/api")  then
  cmd[[autocmd BufWritePre,FileWritePre *.jsx,*.js EslintFixAll]]
else
  cmd[[autocmd BufWritePre,FileWritePre *.jsx,*.js Neoformat jsbeautify]]
end
cmd[[autocmd BufWritePre,FileWritePre *.ts Neoformat tsfmt]]
cmd[[autocmd BufWritePre,FileWritePre *.go :GoFmt]]

-- Rust
cmd[[syntax enable]]
cmd[[filetype plugin indent on]]
vim.g.rustfmt_autosave = 1

-- Auto update on file change
cmd[[autocmd FocusGained * :checktime]]

-- Line number highlight
cmd[[highlight clear LineNr]]
