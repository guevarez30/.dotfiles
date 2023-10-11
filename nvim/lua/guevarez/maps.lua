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

-- QuickFix
map("n", "cn", ":cnext <CR>")
map("n", "cp", ":cprevious <CR>")
map("n", "co", ":copen <CR>")

-- Split
map("n", "<leader>sv", ":Vexplore <CR>")
map("n", "<leader>sh", ":Hexplore <CR>")

-- Git 
map("n", "<leader>gg", ":Git <CR>")
map("n", "<leader>gd", ":Gvdiffsplit <CR>")
map("n", "<leader>gp", ":Git -c push.default=current push <CR>")
map("n", "<leader>gl", ":Git log -n 20 --decorate <CR>")

-- Remap Esc in Terminal mode
map('t', '<Esc>', '<C-\\><C-n>')

-- Harpoon
map("n", "<leader>h", ":lua require('harpoon.mark').add_file() <CR>")
map("n","<leader>hl", ":lua require('harpoon.ui').toggle_quick_menu() <CR>")

-- Error
vim.keymap.set('n', '<Leader>ee', function() 
  filetype = vim.bo.filetype 
  if(filetype == 'go') then
    vim.cmd.normal "iif err != nil {\n\n}"
    return vim.cmd.normal "k"
  elseif(filetype == 'javascript' or filetype == 'typescript' ) then
    vim.cmd.normal "itry {\n\n} catch(err) {\n  console.error(err)\n}"
    return vim.cmd.normal "3k"
  end
end)
