vim.g.mapleader = ' ' 

function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Control Splits
map("n", "<Leader>sv", ":Vexplore<CR>")
map("n", "<Leader>sh", ":Hexplore<CR>")
map("n", "<Leader>se", "<C-w>=")

-- Add empty lines 
map("n", "<Leader>o", "o<Esc>")
map("n", "<Leader>O", "O<Esc>")

-- Move Entire line -- 
map("n", "<C-Up>", "<Up>ddp<Up>")
map("n", "<C-Down>", "ddp")

-- Telescope
map("n", "<C-p>", ":Telescope find_files <CR>")
map("n", "<C-f>", ":Telescope live_grep <CR>")

-- LazyGit
map("n", "<leader>lg", ":FloatermNew lazygit <CR>")
map("n", "<leader>ft", ":FloatermNew cargo test")

-- Test
map("n", "<leader>tn", ":TestNearest <CR>")
map("n", "<leader>tf", ":TestFile <CR>")
map("n", "<leader>ts", ":TestSuite <CR>")

-- Harpoon
map("n", "<leader>m", ":lua require('harpoon.mark').add_file() <CR>")
map("n","<leader>ml", ":lua require('harpoon.ui').toggle_quick_menu() <CR>")
map("n","<leader>mn", ":lua require('harpoon.ui').nav_next() <CR>")
map("n","<leader>mp", ":lua require('harpoon.ui').nav_prev() <CR>")
