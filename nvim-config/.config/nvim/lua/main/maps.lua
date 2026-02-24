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

vim.keymap.set("n", "gh", "_", { noremap = true })
vim.keymap.set("n", "gl", "$", { noremap = true })

-- Move across line
vim.keymap.set("n", "gh", "_", { noremap = true })
vim.keymap.set("n", "gl", "$", { noremap = true })

-- Search terms in middle
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })
vim.keymap.set("n", "*", "*zzzv", { noremap = true })

-- Telescope
local telescope_builtin = require("telescope.builtin")

-- Find files: exclude *_test.go
vim.keymap.set("n", "<leader>p", function()
	telescope_builtin.find_files({
		find_command = { "rg", "--files", "--glob", "!*_test.go" },
	})
end, { noremap = true, desc = "Find files (no Go tests)" })

-- Find files: include all
vim.keymap.set("n", "<leader>P", function()
	telescope_builtin.find_files()
end, { noremap = true, desc = "Find files (with Go tests)" })

-- Live grep: exclude *_test.go
vim.keymap.set("n", "<leader>f", function()
	telescope_builtin.live_grep({
		additional_args = { "--glob", "!*_test.go" },
	})
end, { noremap = true, desc = "Live grep (no Go tests)" })

-- Live grep: include all
vim.keymap.set("n", "<leader>F", function()
	telescope_builtin.live_grep()
end, { noremap = true, desc = "Live grep (with Go tests)" })

vim.keymap.set("n", "<leader>b", ":Telescope git_status <CR>", { noremap = true })
vim.keymap.set("n", "<leader>d", ":Telescope diagnostics<CR>", { noremap = true })

-- Visual mode telescope grep
vim.keymap.set("v", "<leader>f", function()
	local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	require("telescope.builtin").grep_string({ search = table.concat(text, "\n") })
end, { noremap = true, desc = "Grep visual selection" })

-- QuickFix
vim.keymap.set("n", "cn", ":cnext <CR>", { noremap = true })
vim.keymap.set("n", "cp", ":cprevious <CR>", { noremap = true })
vim.keymap.set("n", "co", ":vertical copen <CR>", { noremap = true })

-- Split
vim.keymap.set("n", "<leader>sv", ":Vexplore <CR>", { noremap = true })
vim.keymap.set("n", "<leader>sh", ":Hexplore <CR>", { noremap = true })

-- Git
vim.keymap.set("n", "<leader>gg", ":Git <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit! <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gp", ":Git -c push.default=current push <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gl", ":Git log -n 20 --decorate <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gb", ":Git blame <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gm", function()
	local files = vim.fn.systemlist("git diff --name-only")
	local qf_list = {}
	for _, file in ipairs(files) do
		table.insert(qf_list, { filename = file, lnum = 1 })
	end
	vim.fn.setqflist(qf_list)
	vim.cmd("copen")
end, { noremap = true, desc = "Modified files to quickfix" })

-- Remap Esc in Terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>h", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Error
vim.keymap.set("n", "<Leader>ee", function()
	filetype = vim.bo.filetype
	if filetype == "go" then
		vim.cmd.normal("iif err != nil {\n\n}")
		return vim.cmd.normal("k")
	elseif filetype == "javascript" or filetype == "typescript" then
		vim.cmd.normal("itry {\n\n} catch(err) {\n  console.error(err)\n}")
		return vim.cmd.normal("3k")
	elseif filetype == "java" then
		vim.cmd.normal("itry {\n\n} catch (Exception e) {\n  e.printStackTrace();\n}")
		return vim.cmd.normal("3k")
	end
end)

