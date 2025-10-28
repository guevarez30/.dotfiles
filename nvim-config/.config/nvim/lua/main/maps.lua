vim.g.mapleader = " "
vim.keymap.set("v", "<Space>", "<Nop>", { noremap = true })

-- Add empty lines
vim.keymap.set("n", "<Leader>o", "o<Esc>", { noremap = true })
vim.keymap.set("n", "<Leader>O", "O<Esc>", { noremap = true })

-- Move HighLighted Lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })

-- Make J not suck by keeping cursor in place
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })

-- Vertical Page Movements
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Move across line
vim.keymap.set("n", "gh", "_", { noremap = true })
vim.keymap.set("n", "gl", "$", { noremap = true })

-- Search terms in middle
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })
vim.keymap.set("n", "*", "*zzzv", { noremap = true })

-- Telescope
vim.keymap.set("n", "<leader>p", ":Telescope find_files <CR>", { noremap = true })
vim.keymap.set("n", "<leader>f", ":Telescope live_grep <CR>", { noremap = true })

-- Visual mode telescope grep
vim.keymap.set("v", "<leader>f", function()
	local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	require("telescope.builtin").grep_string({ search = table.concat(text, "\n") })
end, { noremap = true, desc = "Grep visual selection" })

-- QuickFix
vim.keymap.set("n", "cn", ":cnext <CR>", { noremap = true })
vim.keymap.set("n", "cp", ":cprevious <CR>", { noremap = true })
vim.keymap.set("n", "co", ":copen <CR>", { noremap = true })

-- Split
vim.keymap.set("n", "<leader>sv", ":Vexplore <CR>", { noremap = true })
vim.keymap.set("n", "<leader>sh", ":Hexplore <CR>", { noremap = true })

-- Git
vim.keymap.set("n", "<leader>gg", ":Git <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit! <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gp", ":Git -c push.default=current push <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gl", ":Git log -n 20 --decorate <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gb", ":Git blame <CR>", { noremap = true })

-- Remap Esc in Terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Harpoon
vim.keymap.set("n", "<leader>h", ":lua require('harpoon.mark').add_file() <CR>", { noremap = true })
vim.keymap.set("n", "<leader>hl", ":lua require('harpoon.ui').toggle_quick_menu() <CR>", { noremap = true })

-- Error
vim.keymap.set("n", "<Leader>ee", function()
	filetype = vim.bo.filetype
	if filetype == "go" then
		vim.cmd.normal("iif err != nil {\n\n}")
		return vim.cmd.normal("k")
	elseif filetype == "javascript" or filetype == "typescript" then
		vim.cmd.normal("itry {\n\n} catch(err) {\n  console.error(err)\n}")
		return vim.cmd.normal("3k")
	end
end)
