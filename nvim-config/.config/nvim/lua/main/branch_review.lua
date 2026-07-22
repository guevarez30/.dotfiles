local M = {}

local default_base = "origin/dev"
local ns = vim.api.nvim_create_namespace("branch-review")

local state = {
	active = false,
	base_ref = default_base,
	mode = "branch",
	merge_base = nil,
	root = nil,
	hunks_by_file = {},
}

local function notify_error(message)
	vim.notify(message, vim.log.levels.ERROR)
end

local function git_output(args)
	local output = vim.fn.systemlist(vim.list_extend({ "git" }, args))
	if vim.v.shell_error ~= 0 then
		notify_error(table.concat(output, "\n"))
		return nil
	end

	return output
end

local function parse_count(value)
	if not value or value == "" then
		return 1
	end

	return tonumber(value:sub(2)) or 1
end

local function hunk_kind(old_count, new_count)
	if old_count == 0 then
		return "Added"
	end
	if new_count == 0 then
		return "Deleted"
	end
	return "Changed"
end

local function abs_path(root, file)
	if not file or file == "/dev/null" then
		return nil
	end
	return root .. "/" .. file
end

local function add_hunk(hunks_by_file, hunk)
	if not hunks_by_file[hunk.file] then
		hunks_by_file[hunk.file] = {}
	end
	table.insert(hunks_by_file[hunk.file], hunk)
end

local function parse_diff(root, lines)
	local hunks_by_file = {}
	local old_file
	local new_file
	local current_hunk

	for _, line in ipairs(lines) do
		if line:sub(1, 4) == "--- " then
			old_file = line:sub(5)
		elseif line:sub(1, 4) == "+++ " then
			new_file = line:sub(5)
		elseif line:sub(1, 3) == "@@ " then
			local old_start, old_count_raw, new_start, new_count_raw, heading =
				line:match("^@@ %-(%d+)(,?%d*) %+(%d+)(,?%d*) @@%s*(.*)$")

			if old_start and new_start then
				local old_count = parse_count(old_count_raw)
				local new_count = parse_count(new_count_raw)
				local file = abs_path(root, new_file ~= "/dev/null" and new_file or old_file)

				if file then
					current_hunk = {
						file = file,
						old_start = tonumber(old_start),
						old_count = old_count,
						new_start = tonumber(new_start),
						new_count = new_count,
						heading = heading or "",
						kind = hunk_kind(old_count, new_count),
						added_lines = {},
						deleted_lines = {},
					}
					add_hunk(hunks_by_file, current_hunk)
				else
					current_hunk = nil
				end
			else
				current_hunk = nil
			end
		elseif current_hunk and line ~= [[\ No newline at end of file]] then
			local prefix = line:sub(1, 1)
			local text = line:sub(2)
			if prefix == "+" then
				table.insert(current_hunk.added_lines, text)
			elseif prefix == "-" then
				table.insert(current_hunk.deleted_lines, text)
			end
		end
	end

	return hunks_by_file
end

local function clear_buffer(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
end

function M.render_buffer(bufnr)
	if not state.active then
		return
	end

	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(bufnr)
	local hunks = state.hunks_by_file[file]
	clear_buffer(bufnr)

	if not hunks then
		return
	end

	local line_count = vim.api.nvim_buf_line_count(bufnr)
	for _, hunk in ipairs(hunks) do
		local sign_text = hunk.kind == "Added" and "+" or hunk.kind == "Deleted" and "_" or "~"
		local line_hl = hunk.kind == "Added" and "BranchReviewAdd" or hunk.kind == "Deleted" and "BranchReviewDelete"
			or "BranchReviewChange"

		if hunk.new_count > 0 then
			local start_line = math.max(hunk.new_start - 1, 0)
			local end_line = math.min(start_line + hunk.new_count, line_count)
			for lnum = start_line, end_line - 1 do
				vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, 0, {
					sign_text = sign_text,
					sign_hl_group = line_hl,
				})
			end
		end

		if #hunk.deleted_lines > 0 then
			local anchor = math.min(math.max(hunk.new_start - 1, 0), math.max(line_count - 1, 0))
			local virt_lines = {}
			for _, deleted in ipairs(hunk.deleted_lines) do
				table.insert(virt_lines, { { "- " .. deleted, "BranchReviewDeleteLine" } })
			end

			local opts = {
				virt_lines = virt_lines,
				virt_lines_above = true,
			}

			if hunk.new_count > 0 then
				opts.sign_text = sign_text
				opts.sign_hl_group = line_hl
			end

			vim.api.nvim_buf_set_extmark(bufnr, ns, anchor, 0, opts)
		end
	end
end

local function render_loaded_buffers()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			M.render_buffer(bufnr)
		end
	end
end

local function build_quickfix()
	local items = {}
	for _, hunks in pairs(state.hunks_by_file) do
		for _, hunk in ipairs(hunks) do
			table.insert(items, {
				filename = hunk.file,
				lnum = math.max(hunk.new_start, 1),
				col = 1,
				text = ("%s -%d,%d +%d,%d %s"):format(
					hunk.kind,
					hunk.old_start,
					hunk.old_count,
					hunk.new_start,
					hunk.new_count,
					hunk.heading
				),
			})
		end
	end

	table.sort(items, function(a, b)
		if a.filename == b.filename then
			return a.lnum < b.lnum
		end
		return a.filename < b.filename
	end)

	vim.fn.setqflist({}, "r", { title = "Branch review " .. state.base_ref, items = items })
	return items
end

local function set_root()
	local root_output = git_output({ "rev-parse", "--show-toplevel" })
	if not root_output or not root_output[1] or root_output[1] == "" then
		return false
	end
	state.root = root_output[1]
	return true
end

local function open_diff(label, diff_args)
	local diff = git_output(diff_args)
	if not diff then
		return
	end

	state.hunks_by_file = parse_diff(state.root, diff)
	state.active = true
	state.base_ref = label

	local items = build_quickfix()
	render_loaded_buffers()

	if #items > 0 then
		pcall(vim.cmd, "cfirst")
		vim.cmd("botright copen")
	else
		vim.notify("No hunks " .. label, vim.log.levels.INFO)
	end
end

function M.open(base_ref)
	base_ref = base_ref and base_ref ~= "" and base_ref or default_base

	if not set_root() then
		return
	end

	if base_ref == "--uncommitted" or base_ref == "uncommitted" then
		state.mode = "uncommitted"
		state.merge_base = nil
		open_diff("uncommitted", {
			"diff",
			"--no-ext-diff",
			"--no-color",
			"--no-prefix",
			"--find-renames",
			"--histogram",
			"--unified=0",
		})
		return
	end

	if base_ref == "--staged" or base_ref == "staged" then
		state.mode = "staged"
		state.merge_base = nil
		open_diff("staged", {
			"diff",
			"--cached",
			"--no-ext-diff",
			"--no-color",
			"--no-prefix",
			"--find-renames",
			"--histogram",
			"--unified=0",
		})
		return
	end

	state.mode = "branch"
	local merge_base = git_output({ "merge-base", base_ref, "HEAD" })
	if not merge_base or not merge_base[1] or merge_base[1] == "" then
		notify_error("No merge-base found for " .. base_ref)
		return
	end
	state.merge_base = merge_base[1]

	open_diff("vs " .. base_ref, {
		"diff",
		"--no-ext-diff",
		"--no-color",
		"--no-prefix",
		"--find-renames",
		"--histogram",
		"--unified=0",
		state.merge_base,
	})
end

function M.close()
	state.active = false
	state.merge_base = nil
	state.mode = "branch"
	state.hunks_by_file = {}
	vim.fn.setqflist({}, "r", { title = "Branch review", items = {} })
	pcall(vim.cmd, "cclose")

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			clear_buffer(bufnr)
		end
	end
end

function M.refresh()
	if state.mode == "uncommitted" then
		M.open("--uncommitted")
	elseif state.mode == "staged" then
		M.open("--staged")
	else
		M.open((state.base_ref or default_base):gsub("^vs ", ""))
	end
end

function M.pick_branch()
	if not set_root() then
		return
	end

	local refs = git_output({ "branch", "--all", "--format=%(refname:short)" })
	if not refs then
		return
	end

	local seen = {}
	local choices = {}
	for _, ref in ipairs(refs) do
		ref = ref:gsub("^origin/HEAD -> ", "")
		ref = ref:gsub("^remotes/", "")
		if ref ~= "" and not seen[ref] then
			seen[ref] = true
			table.insert(choices, ref)
		end
	end

	table.sort(choices)
	if #choices == 0 then
		vim.notify("No branches found", vim.log.levels.INFO)
		return
	end

	vim.ui.select(choices, { prompt = "Branch review base" }, function(choice)
		if choice and choice ~= "" then
			M.open(choice)
		end
	end)
end

local function set_highlights()
	vim.api.nvim_set_hl(0, "BranchReviewAdd", { fg = "#50fa7b", bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "BranchReviewChange", { fg = "#8be9fd", bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "BranchReviewDelete", { fg = "#ff5555", bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "BranchReviewDeleteLine", { link = "DiffDelete" })
end

function M.setup()
	set_highlights()

	vim.api.nvim_create_user_command("BranchReviewOpen", function(opts)
		M.open(opts.args)
	end, { nargs = "?" })

	vim.api.nvim_create_user_command("BranchReviewClose", M.close, {})
	vim.api.nvim_create_user_command("BranchReviewRefresh", M.refresh, {})
	vim.api.nvim_create_user_command("BranchReviewPick", M.pick_branch, {})

	vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter", "TextChanged", "TextChangedI" }, {
		callback = function(event)
			M.render_buffer(event.buf)
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "*",
		callback = set_highlights,
	})
end

return M
