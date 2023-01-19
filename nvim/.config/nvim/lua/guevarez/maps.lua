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

-- Move HighLighted Lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Make J not suck by keeping cursor in place
map("n", "J", "mzJ`z")
--
-- -- Vertical Page Movements
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Search terms in middle
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Telescope
map("n", "<C-p>", ":Telescope find_files <CR>")
map("n", "<C-f>", ":Telescope live_grep <CR>")

-- Git 
map("n", "<leader>gg", ":LazyGit <CR>")
map("n", "<leader>gd", ":GitGutterDiffOrig <CR>")
map("n", "]h", ":GitGutterNextHunk <CR>")
map("n", "]h", ":GitGutterNextHunk <CR>")


-- Refresh buffers
map("n", "<leader>r", ":checktime <CR>")

-- Test
map("n", "<leader>tn", ":TestNearest <CR>")
map("n", "<leader>tf", ":TestFile <CR>")
map("n", "<leader>ts", ":TestSuite <CR>")

-- Harpoon
map("n", "<leader>m", ":lua require('harpoon.mark').add_file() <CR>")
map("n","<leader>ml", ":lua require('harpoon.ui').toggle_quick_menu() <CR>")
