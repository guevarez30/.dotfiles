local cmd = vim.cmd

-- Auto update on file change
cmd([[autocmd FocusGained * :checktime]])
cmd([[highlight clear LineNr]])

-- Auto format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Prevent automatic comment continuation
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

-- Fix indentation for CSS, SCSS, and similar files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "css", "scss", "sass", "less" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = false -- Ensure tabs, not spaces
	end,
})

-- Detect Helm chart templates as gotmpl for proper syntax highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*/templates/*.yaml", "*/templates/*.yml", "*/templates/*.tpl", "*.gotmpl" },
	callback = function()
		vim.bo.filetype = "gotmpl"
	end,
})

-- :F / :P - show path and copy to clipboard
vim.api.nvim_create_user_command("F", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify(path .. " (copied)")
end, {})

vim.api.nvim_create_user_command("P", function()
	local cwd = vim.uv.cwd()
	vim.fn.setreg("+", cwd)
	vim.notify(cwd .. " (copied)")
end, {})

-- Abbreviate :f -> :F and :p -> :P in command mode
vim.cmd([[cab f F]])
vim.cmd([[cab p P]])

-- Close stale floating windows with <Esc>
vim.keymap.set("n", "<Esc>", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local config = vim.api.nvim_win_get_config(win)
		if config.relative ~= "" then
			pcall(vim.api.nvim_win_close, win, false)
		end
	end
end, { desc = "Close floating windows" })

vim.cmd.colorscheme("catppuccin")
