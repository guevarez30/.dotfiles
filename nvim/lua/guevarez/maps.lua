vim.g.mapleader = ' ' 

function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Add empty lines 
map("n", "<Leader>o", "o<Esc>")
map("n", "<Leader>O", "O<Esc>")


-- Move HighLighted Lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Make J not suck by keeping cursor in place
map("n", "J", "mzJ`z")

-- Vertical Page Movements
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Move across line
map("n", "gh", "_")
map("n", "gl", "$")

-- Search terms in middle
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "*", "*zzzv")

-- Telescope
map("n", "<leader>p", ":Telescope find_files <CR>")
map("n", "<leader>f", ":Telescope live_grep <CR>")

-- Marks
map("n", "<leader>m", ":Telescope vim_bookmarks all <CR>")
map("n", "md", " <Plug>BookmarkClearAll")
map("n", "ma", ":Telescope vim_bookmarks all <CR>")

-- QuickFix
map("n", "<leader>cn", ":cnext <CR>")
map("n", "<leader>cp", ":cprevious <CR>")

-- Split
map("n", "<leader>sv", ":Vexplore <CR>")
map("n", "<leader>sh", ":Hexplore <CR>")

-- Git 
map("n", "<leader>gg", ":Git <CR>")
map("n", "<leader>gf", ":Git fetch <CR>")
map("n", "<leader>gd", ":Gvdiffsplit <CR>")
map("n", "<leader>gp", ":Git -c push.default=current push <CR>")
map("n", "<leader>gl", ":Git log -n 20 --decorate <CR>")
map("n", "<leader>gb",  ":Telescope git_branches<CR>" )

-- Harpoon
-- map("n", "<leader>h", ":lua require('harpoon.mark').add_file() <CR>")
-- map("n","<leader>hl", ":lua require('harpoon.ui').toggle_quick_menu() <CR>")
