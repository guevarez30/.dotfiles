local dracula_plus = {
	normal = {
		a = { fg = "#212121", bg = "#c792ea", gui = "bold" },
		b = { fg = "#f8f8f2", bg = "#21222c" },
		c = { fg = "#f8f8f2", bg = "NONE" },
	},
	insert = {
		a = { fg = "#212121", bg = "#50fa7b", gui = "bold" },
	},
	visual = {
		a = { fg = "#212121", bg = "#ffcb6b", gui = "bold" },
	},
	replace = {
		a = { fg = "#212121", bg = "#ff5555", gui = "bold" },
	},
	command = {
		a = { fg = "#212121", bg = "#8be9fd", gui = "bold" },
	},
	inactive = {
		a = { fg = "#545454", bg = "NONE" },
		b = { fg = "#545454", bg = "NONE" },
		c = { fg = "#545454", bg = "NONE" },
	},
}

local function progress_status()
	return vim.trim(vim.ui.progress_status())
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = dracula_plus,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = {
			"filename",
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
			},
		},
		lualine_x = {
			{
				progress_status,
				cond = function()
					return progress_status() ~= ""
				end,
			},
			"encoding",
			"filetype",
		},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
