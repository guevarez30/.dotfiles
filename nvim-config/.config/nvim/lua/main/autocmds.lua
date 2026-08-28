local augroup = vim.api.nvim_create_augroup

vim.api.nvim_create_autocmd("FocusGained", {
	group = augroup("DotfilesChecktime", { clear = true }),
	callback = function()
		vim.cmd.checktime()
	end,
})

-- Auto format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("DotfilesFormatOnSave", { clear = true }),
	pattern = "*",
	callback = function(args)
		require("conform").format({
			bufnr = args.buf,
			async = false,
			lsp_format = "fallback",
			quiet = true,
		})
	end,
})

-- Prevent automatic comment continuation
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("DotfilesFormatOptions", { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end,
})

-- Fix indentation for CSS, SCSS, and similar files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("DotfilesCssIndent", { clear = true }),
	pattern = { "css", "scss", "sass", "less" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = false -- Ensure tabs, not spaces
	end,
})

-- Detect Helm chart templates as helm for proper Tree-sitter highlighting
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("DotfilesHelmTemplates", { clear = true }),
	pattern = { "*/templates/*.yaml", "*/templates/*.yml", "*/templates/*.tpl", "*.gotmpl" },
	callback = function()
		vim.bo.filetype = "helm"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("DotfilesTreesitterTemplates", { clear = true }),
	pattern = { "helm", "gotmpl" },
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("DotfilesTreesitterGo", { clear = true }),
	pattern = { "go", "gomod", "gosum" },
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
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
