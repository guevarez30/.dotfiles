-- Set leader key before loading plugins so plugin keymaps use the correct leader
vim.g.mapleader = " "

require("main.plugins")
require("main.set")
require("main.maps")
require("main.autocmds")
