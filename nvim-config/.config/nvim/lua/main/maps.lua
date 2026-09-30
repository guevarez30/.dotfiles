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
vim.keymap.set("n", "cn", "<cmd>cnext<CR>", { noremap = true, desc = "Next quickfix item" })
vim.keymap.set("n", "cp", "<cmd>cprevious<CR>", { noremap = true, desc = "Previous quickfix item" })
vim.keymap.set("n", "]q", "<cmd>cnext<CR>", { noremap = true, desc = "Next quickfix item" })
vim.keymap.set("n", "[q", "<cmd>cprevious<CR>", { noremap = true, desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>qo", "<cmd>vertical copen<CR>", { noremap = true, desc = "Open quickfix list" })

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

local function copy_ref(opts)
	local path = vim.fn.expand("%:p")
	if path == "" then
		vim.notify("Save the buffer first so the agent has a file path.", vim.log.levels.WARN)
		return
	end

	-- Snapshot the source before the prompt changes focus or Visual mode.
	local start_line = vim.fn.line(".")
	local lines = { vim.api.nvim_get_current_line() }
	local filetype = vim.bo.filetype

	if opts.visual then
		local anchor = vim.fn.getpos("v")
		local cursor = vim.fn.getpos(".")
		start_line = math.min(anchor[2], cursor[2])
		lines = vim.fn.getregion(anchor, cursor, { type = vim.fn.mode() })
		vim.cmd.normal({ args = { vim.keycode("<Esc>") }, bang = true })
	end

	local end_line = start_line + #lines - 1
	local ref = path .. ":" .. start_line
	if end_line > start_line then
		ref = ref .. "-" .. end_line
	end
	local content = table.concat(lines, "\n")
	local fence = "```"
	for ticks in content:gmatch("`+") do
		if #ticks >= #fence then
			fence = string.rep("`", #ticks + 1)
		end
	end
	local context = ref .. "\n\n" .. fence .. filetype .. "\n" .. content .. "\n" .. fence

	vim.ui.input({ prompt = "Prompt (optional): " }, function(note)
		if note == nil then
			return
		end

		local prompt = note ~= "" and (note .. "\n\n" .. context) or context
		vim.fn.setreg("+", prompt)
		vim.notify("Copied prompt: " .. ref)
	end)
end

vim.keymap.set("n", "<leader>ap", function()
	copy_ref({})
end, { desc = "Copy agent prompt with current line" })

vim.keymap.set("x", "<leader>ap", function()
	copy_ref({ visual = true })
end, { desc = "Copy agent prompt with selection" })

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
