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
vim.keymap.set("n", "<leader>b", ":Telescope git_status <CR>", { noremap = true })

-- Visual mode telescope grep
vim.keymap.set("v", "<leader>f", function()
	local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	require("telescope.builtin").grep_string({ search = table.concat(text, "\n") })
end, { noremap = true, desc = "Grep visual selection" })

-- Format visual selection with jq
vim.keymap.set("v", "<leader>jq", ":!jq .<CR>", { noremap = true, desc = "Format visual selection with jq" })

-- QuickFix
vim.keymap.set("n", "cn", ":cnext <CR>", { noremap = true })
vim.keymap.set("n", "cp", ":cprevious <CR>", { noremap = true })
vim.keymap.set("n", "co", ":vertical copen <CR>", { noremap = true })

-- Branch review
vim.keymap.set("n", "<leader>dvo", "<cmd>BranchReviewPick<CR>", { noremap = true, desc = "Open branch review" })
vim.keymap.set("n", "<leader>dvd", "<cmd>BranchReviewOpen origin/dev<CR>", { noremap = true, desc = "Open branch review vs origin/dev" })
vim.keymap.set("n", "<leader>dvu", "<cmd>BranchReviewOpen --uncommitted<CR>", { noremap = true, desc = "Open uncommitted review" })
vim.keymap.set("n", "<leader>dvs", "<cmd>BranchReviewOpen --staged<CR>", { noremap = true, desc = "Open staged review" })
vim.keymap.set("n", "<leader>dvc", "<cmd>BranchReviewClose<CR>", { noremap = true, desc = "Close branch review" })

-- Split
vim.keymap.set("n", "<leader>sv", ":Vexplore <CR>", { noremap = true })
vim.keymap.set("n", "<leader>sh", ":Hexplore <CR>", { noremap = true })

-- Git
local function git_changed_files_to_qf(args, title)
	local files = vim.fn.systemlist("git diff --name-only " .. args)
	if vim.v.shell_error ~= 0 then
		vim.notify("git diff failed for " .. args, vim.log.levels.ERROR)
		return
	end

	local qf_list = {}
	for _, file in ipairs(files) do
		if file ~= "" then
			table.insert(qf_list, { filename = file, lnum = 1 })
		end
	end

	vim.fn.setqflist({}, " ", { title = title, items = qf_list })
	vim.cmd("copen")
end

	vim.keymap.set("n", "<leader>gg", ":Git <CR>", { noremap = true })
	vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit! <CR>", { noremap = true })
	vim.keymap.set("n", "<leader>gv", ":Gvdiffsplit origin/dev:% <CR>", { noremap = true, desc = "Diff current file vs origin/dev" })
	vim.keymap.set("n", "<leader>gp", ":Git -c push.default=current push <CR>", { noremap = true })
	vim.keymap.set("n", "<leader>gl", ":Git log -n 20 --decorate <CR>", { noremap = true })
	vim.keymap.set("n", "<leader>gb", ":Git blame <CR>", { noremap = true })
	vim.keymap.set("n", "<leader>gm", function()
		git_changed_files_to_qf("", "Modified files")
	end, { noremap = true, desc = "Modified files to quickfix" })

-- Remap Esc in Terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

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

	local note = vim.fn.input("Prompt (optional): ")
	if note ~= "" then
		ref = ref .. " " .. note
	end

	vim.fn.setreg("+", ref)
	vim.notify("Copied: " .. ref)
end

vim.keymap.set("n", "<leader>cp", function()
	copy_ref({})
end, { desc = "Copy file path prompt" })

vim.keymap.set("v", "<leader>cp", function()
	copy_ref({ visual = true })
end, { desc = "Copy file path range prompt" })

vim.keymap.set("n", "<leader>cl", function()
	require("main.clanker").insert()
end, { desc = "Insert clanker comment" })

vim.keymap.set("v", "<leader>cl", function()
	require("main.clanker").insert({ visual = true })
end, { desc = "Insert clanker comment above selection" })

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
