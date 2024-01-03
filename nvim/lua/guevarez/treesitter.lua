require("nvim-treesitter.configs").setup({
	ensure_installed = { "python", "bash", "javascript", "go", "http", "json", "rust", "vim", "glimmer" },
	sync_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	rainbow = {
		enable = true,
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		colors = {
			"#8be9fd",
			"#ffb86c",
			"#ff79c6",
			"#bd93f9",
			"#ff5555",
			"#f1fa8c",
			"#f8f8f2",
		}, -- table of hex strings
	},
})
vim.g.rainbow_active = 1
