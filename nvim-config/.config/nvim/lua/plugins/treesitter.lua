return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		opts = {
			ensure_installed = {
				"bash", "c", "css", "go", "gomod", "gosum", "gotmpl",
				"helm", "html", "java", "javascript", "json", "lua",
				"markdown", "markdown_inline", "python", "rust",
				"typescript", "tsx", "vim", "vimdoc", "yaml",
			},
			sync_install = false,
			auto_install = true,
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
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "an",
					node_incremental = "an",
					node_decremental = "in",
					scope_incremental = false,
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			local ok, configs = pcall(require, "nvim-treesitter.configs")
			if ok then
				configs.setup(opts)
			else
				require("nvim-treesitter").setup(opts)
			end

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
