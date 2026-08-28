-- Set leader key before loading plugins so plugin keymaps use the correct leader
vim.g.mapleader = " "

pcall(function()
	require("vim._core.ui2").enable()
end)

require("main.plugins")
require("main.set")
require("main.branch_review").setup()
require("main.maps")
require("main.highlights")
require("main.autocmds")
