vim.g['signify_sign_show_count'] = 0
vim.g['signify_sign_add']        = '▎'
vim.g['signify_sign_change']     = '▎'
vim.g['signify_sign_delete']     = '▁'

-- Re-apply after colorscheme loads so catppuccin doesn't wipe them
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "SignifySignAdd",    { fg = "#A6E3A1", bold = true })
		vim.api.nvim_set_hl(0, "SignifySignChange", { fg = "#89B4FA", bold = true })
		vim.api.nvim_set_hl(0, "SignifySignDelete", { fg = "#F38BA8", bold = true })
	end,
})
