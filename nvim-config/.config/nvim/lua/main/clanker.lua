local M = {}

local function comment_line(text, indent)
	local commentstring = vim.bo.commentstring
	if commentstring == "" or not commentstring:find("%%s") then
		commentstring = "# %s"
	end

	return indent .. commentstring:format(text)
end

local function target_line(opts)
	if opts and opts.visual then
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")
		return math.min(start_line, end_line)
	end

	return vim.fn.line(".")
end

function M.insert(opts)
	vim.ui.input({ prompt = "CLANKER: " }, function(input)
		if not input or input == "" then
			return
		end

		local lnum = target_line(opts)
		local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
		local indent = line:match("^%s*") or ""
		local comment = comment_line("CLANKER: " .. input, indent)

		vim.api.nvim_buf_set_lines(0, lnum - 1, lnum - 1, false, { comment })
	end)
end

return M
