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

-- Explicit host/system clipboard copy
vim.keymap.set("n", "<leader>y", '"+y', { noremap = true, desc = "Copy to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+yy', { noremap = true, desc = "Copy line to clipboard" })

-- QuickFix
vim.keymap.set("n", "cn", function()
	vim.cmd.cnext()
end, { noremap = true })
vim.keymap.set("n", "cp", function()
	vim.cmd.cprevious()
end, { noremap = true })
vim.keymap.set("n", "co", ":copen <CR>", { noremap = true, desc = "Open quickfix" })

-- Branch review
vim.keymap.set("n", "<leader>dvo", "<cmd>BranchReviewPick<CR>", { noremap = true, desc = "Open branch review" })
vim.keymap.set("n", "<leader>dvd", "<cmd>BranchReviewOpen origin/dev<CR>", { noremap = true, desc = "Open branch review vs origin/dev" })
vim.keymap.set("n", "<leader>dvu", "<cmd>BranchReviewOpen --uncommitted<CR>", { noremap = true, desc = "Open uncommitted review" })
vim.keymap.set("n", "<leader>dvs", "<cmd>BranchReviewOpen --staged<CR>", { noremap = true, desc = "Open staged review" })
vim.keymap.set("n", "<leader>dvc", "<cmd>BranchReviewClose<CR>", { noremap = true, desc = "Close branch review" })

-- Split
vim.keymap.set("n", "<leader>sv", ":Vexplore <CR>", { noremap = true })
vim.keymap.set("n", "<leader>sh", ":Hexplore <CR>", { noremap = true })

-- Remap Esc in Terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Error
vim.keymap.set("n", "<Leader>ee", function()
	local filetype = vim.bo.filetype
	if filetype == "go" then
		vim.cmd.normal("iif err != nil {\n\n}")
		return vim.cmd.normal("k")
	elseif filetype == "javascript" or filetype == "typescript" then
		vim.cmd.normal("itry {\n\n} catch(err) {\n  console.error(err)\n}")
		return vim.cmd.normal("3k")
	end
end)

local function copy_ref(opts)
	local path = vim.fn.expand("%:.")
	local ref = path

	if opts.visual then
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end
		ref = path .. ":" .. start_line .. ":" .. end_line
	end

	vim.ui.input({ prompt = "Prompt (optional): " }, function(note)
		if note and note ~= "" then
			ref = ref .. " " .. note
		end

		vim.fn.setreg("+", ref)
		vim.notify("Copied: " .. ref)
	end)
end

vim.keymap.set("n", "<leader>ap", function()
	copy_ref({})
end, { desc = "Copy file path prompt" })

vim.keymap.set("v", "<leader>ap", function()
	copy_ref({ visual = true })
end, { desc = "Copy file path range prompt" })

vim.keymap.set("n", "<leader>al", function()
	require("main.clanker").insert()
end, { desc = "Insert clanker comment" })

vim.keymap.set("v", "<leader>al", function()
	require("main.clanker").insert({ visual = true })
end, { desc = "Insert clanker comment above selection" })
