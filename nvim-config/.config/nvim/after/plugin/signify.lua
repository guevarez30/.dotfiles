vim.g['signify_sign_show_count'] = 0
vim.g['signify_sign_add']        = '+'
vim.g['signify_sign_change']     = '~'
vim.g['signify_sign_delete']     = '_'
vim.g['signify_line_highlight']  = 0
vim.g['signify_sign_priority']   = 20

-- Re-apply after colorscheme loads so the git signs stay readable.
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "SignifySignAdd",    { fg = "#50fa7b", bg = "NONE", bold = true })
		vim.api.nvim_set_hl(0, "SignifySignChange", { fg = "#8be9fd", bg = "NONE", bold = true })
		vim.api.nvim_set_hl(0, "SignifySignDelete", { fg = "#ff5555", bg = "NONE", bold = true })
		vim.api.nvim_set_hl(0, "SignColumn",        { bg = "NONE" })
	end,
})

vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name or "*" })
