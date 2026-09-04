return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			highlight = {
				enable = true,
				disable = function(lang)
					return not pcall(vim.treesitter.language.inspect, lang)
				end,
			},
			indent = {
				enable = true,
				disable = function(lang)
					return not pcall(vim.treesitter.language.inspect, lang)
				end,
			},
		},
		config = function(_, opts)
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup(opts)
			else
				require("nvim-treesitter").setup(opts)
			end

			-- Helm's parser does not expose gotmpl's anonymous "else if" token,
			-- but the upstream helm query inherits gotmpl highlights. Strip only
			-- that token until the parser/query mismatch is resolved upstream.
			local gotmpl_query = vim.api.nvim_get_runtime_file("queries/gotmpl/highlights.scm", false)[1]
			local helm_query = vim.api.nvim_get_runtime_file("queries/helm/highlights.scm", false)[1]
			if gotmpl_query and helm_query then
				local query = table.concat(vim.fn.readfile(gotmpl_query), "\n")
					:gsub('%s*"else if"', "")
					.. "\n"
					.. table.concat(vim.fn.readfile(helm_query), "\n"):gsub("^; inherits: gotmpl\n", "")
				vim.treesitter.query.set("helm", "highlights", query)
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
		},
	},
}
