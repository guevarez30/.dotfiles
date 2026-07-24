local augroup = vim.api.nvim_create_augroup

vim.api.nvim_set_hl(0, "LineNr", {})

local highlight_group = augroup("DotfilesHighlights", { clear = true })

local function set_highlights()
	vim.api.nvim_set_hl(0, "DotfilesTodoComment", {
		fg = "#1f1f1f",
		bg = "#f9e2af",
		bold = true,
	})
	vim.api.nvim_set_hl(0, "DotfilesClanker", {
		fg = "#1f1f1f",
		bg = "#50fa7b",
		bold = true,
	})
end

local function apply_matches()
	if vim.w.dotfiles_todo_match then
		pcall(vim.fn.matchdelete, vim.w.dotfiles_todo_match)
	end
	if vim.w.dotfiles_clanker_match then
		pcall(vim.fn.matchdelete, vim.w.dotfiles_clanker_match)
	end

	vim.w.dotfiles_todo_match = vim.fn.matchadd("DotfilesTodoComment", [[\c\(#\|//\|--\|;\|"\|%\|<!--\|/\*\|\*\).*\<todo\>.*]])
	vim.w.dotfiles_clanker_match = vim.fn.matchadd("DotfilesClanker", [[\c\<clanker\>]])
end

set_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = highlight_group,
	callback = set_highlights,
})

vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType" }, {
	group = highlight_group,
	callback = apply_matches,
})
