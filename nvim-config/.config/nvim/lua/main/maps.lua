vim.g.mapleader = " "
vim.keymap.set("v", "<Space>", "<Nop>", { noremap = true })

-- Add empty lines
vim.keymap.set("n", "<Leader>o", "o<Esc>", { noremap = true })
vim.keymap.set("n", "<Leader>O", "O<Esc>", { noremap = true })

-- Move HighLighted Lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true })

-- Make J not suck by keeping cursor in place
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })

-- Vertical Page Movements
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Move across line
-- vim.keymap.set("n", "gh", "_", { noremap = true })
-- vim.keymap.set("n", "gl", "$", { noremap = true })

-- Search terms in middle
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })
vim.keymap.set("n", "*", "*zzzv", { noremap = true })

-- Telescope
vim.keymap.set("n", "<leader>p", ":Telescope find_files <CR>", { noremap = true })
vim.keymap.set("n", "<leader>f", ":Telescope live_grep <CR>", { noremap = true })
vim.keymap.set("n", "<leader>b", ":Telescope git_status <CR>", { noremap = true })
vim.keymap.set("n", "<leader>d", ":Telescope diagnostics<CR>", { noremap = true })

-- Visual mode telescope grep
vim.keymap.set("v", "<leader>f", function()
	local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	require("telescope.builtin").grep_string({ search = table.concat(text, "\n") })
end, { noremap = true, desc = "Grep visual selection" })

-- QuickFix
vim.keymap.set("n", "cn", ":cnext <CR>", { noremap = true })
vim.keymap.set("n", "cp", ":cprevious <CR>", { noremap = true })
vim.keymap.set("n", "co", ":vertical copen <CR>", { noremap = true })

-- Split
vim.keymap.set("n", "<leader>sv", ":Vexplore <CR>", { noremap = true })
vim.keymap.set("n", "<leader>sh", ":Hexplore <CR>", { noremap = true })

-- Git
vim.keymap.set("n", "<leader>gg", ":Git <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit! <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gp", ":Git -c push.default=current push <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gl", ":Git log -n 20 --decorate <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gb", ":Git blame <CR>", { noremap = true })
vim.keymap.set("n", "<leader>gm", function()
	local files = vim.fn.systemlist("git diff --name-only")
	local qf_list = {}
	for _, file in ipairs(files) do
		table.insert(qf_list, { filename = file, lnum = 1 })
	end
	vim.fn.setqflist(qf_list)
	vim.cmd("copen")
end, { noremap = true, desc = "Modified files to quickfix" })

-- Remap Esc in Terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Curl
vim.keymap.set("n", "<leader>cu", function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local curl_dir = vim.fn.stdpath("data") .. "/curl_cache/custom"
	local files = vim.fn.globpath(curl_dir, "*.curl", false, true)
	local collections = {}

	for i = 1, #files do
		local name = vim.fn.fnamemodify(files[i], ":t:r")
		collections[#collections + 1] = name
	end

	pickers.new({}, {
		prompt_title = "Curl Collections",
		finder = finders.new_table({
			results = collections,
		}),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				if selection then
					require("curl.api").open_global_collection(selection[1])
				end
			end)
			return true
		end,
	}):find()
end, { noremap = true, desc = "Pick global curl collection" })

-- Harpoon
local harpoon = require("harpoon")

harpoon:setup({
	settings = {
		save_on_toggle = true,
	},
	default = {
		display = function(list_item)
			-- Abbreviate path: src/components/ui/Button.tsx -> ../ui/Button.tsx
			local path = list_item.value
			local parts = vim.split(path, "/")
			if #parts <= 2 then
				return path
			end
			-- Keep last 2 parts, replace rest with ..
			local last_two = table.concat({ parts[#parts - 1], parts[#parts] }, "/")
			return "../" .. last_two
		end,
	},
})

vim.keymap.set("n", "<leader>h", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

-- Error
vim.keymap.set("n", "<Leader>ee", function()
	filetype = vim.bo.filetype
	if filetype == "go" then
		vim.cmd.normal("iif err != nil {\n\n}")
		return vim.cmd.normal("k")
	elseif filetype == "javascript" or filetype == "typescript" then
		vim.cmd.normal("itry {\n\n} catch(err) {\n  console.error(err)\n}")
		return vim.cmd.normal("3k")
	elseif filetype == "java" then
		vim.cmd.normal("itry {\n\n} catch (Exception e) {\n  e.printStackTrace();\n}")
		return vim.cmd.normal("3k")
	end
end)

