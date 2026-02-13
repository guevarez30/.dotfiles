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

-- Force all splits to open vertically on the right at 33% width
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		local filetype = vim.bo.filetype
		local buftype = vim.bo.buftype

		-- Handle quickfix and location lists
		if buftype == "quickfix" then
			-- Move window to the right if it's not already there
			vim.schedule(function()
				local win_width = vim.fn.winwidth(0)
				local total_width = vim.o.columns
				-- If quickfix is full width (horizontal), move it to vertical right
				if win_width == total_width then
					vim.cmd("wincmd L")
					-- Set width to 33% of total columns
					local target_width = math.floor(total_width * 0.33)
					vim.cmd("vertical resize " .. target_width)
				end
			end)
			return
		end

		-- Handle Fugitive windows
		if filetype == "fugitive" or filetype == "git" then
			-- Only move if not already in a vertical split on the right
			local win_width = vim.fn.winwidth(0)
			local total_width = vim.o.columns
			if win_width == total_width then
				vim.cmd("wincmd L")
				-- Set width to 33% of total columns
				local target_width = math.floor(total_width * 0.33)
				vim.cmd("vertical resize " .. target_width)
			end
		end
	end,
})

vim.cmd.colorscheme("catppuccin")
