vim.g.mapleader = ' ' 

function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<Leader>s", ":Vexplore<CR>")
map("n", "<Leader>S", ":Hexplore<CR>")
map("n", "<Leader>w", "<C-w>w")
map("n", "<Leader>o", "o<Esc>")
map("n", "<Leader>O", "O<Esc>")

-- Move Entire line -- 
map("n", "<C-Up>", "<Up>ddp<Up>")
map("n", "<C-Down>", "ddp")

-- Telescope
map("n", "<C-p>", ":Telescope find_files <CR>")
map("n", "<C-f>", ":Telescope live_grep <CR>")

-- Harpoon
map("n", "<leader>m", ":lua require('harpoon.mark').add_file() <CR>")
map("n","<leader>ml", ":lua require('harpoon.ui').toggle_quick_menu() <CR>")
map("n","<leader>mn", ":lua require('harpoon.ui').nav_next() <CR>")
map("n","<leader>mp", ":lua require('harpoon.ui').nav_prev() <CR>")

-- Line Movement
map("n", "<leader>h", "0")
map("n", "<leader>l", "$")
