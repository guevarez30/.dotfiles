local function get_bookmark_file(dir)
	dir = dir or vim.fn.getcwd()
	local result = vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel")
	if vim.v.shell_error == 0 and result[1] and result[1] ~= "" then
		return result[1] .. "/.bookmarks"
	end
	return dir .. "/.bookmarks"
end

return {
	"tomasky/bookmarks.nvim",
	dependencies = { "nvim-telescope/telescope.nvim" },
	config = function()
		local bm_config = require("bookmarks.config")
		local bm = require("bookmarks")

		bm.setup({
			save_file = get_bookmark_file(),
			keywords = {
				["@t"] = "☑ ",
				["@w"] = "⚠ ",
				["@f"] = "⛏ ",
				["@n"] = " ",
			},
		})

		local telescope = require("telescope").load_extension("bookmarks")
		vim.keymap.set("n", "]b", bm.bookmark_next, { desc = "Next bookmark" })
		vim.keymap.set("n", "[b", bm.bookmark_prev, { desc = "Previous bookmark" })
		vim.keymap.set("n", "mm", bm.bookmark_toggle, { desc = "Toggle bookmark" })
		vim.keymap.set("n", "ma", bm.bookmark_ann, { desc = "Bookmark with annotation" })
		vim.keymap.set("n", "mc", bm.bookmark_clean, { desc = "Clear file bookmarks" })
		vim.keymap.set("n", "mx", function()
			bm.bookmark_clear_all()
			bm.refresh()
		end, { desc = "Clear all bookmarks" })
		vim.keymap.set("n", "ml", telescope.list, { desc = "List bookmarks" })

		vim.api.nvim_create_autocmd("DirChanged", {
			group = vim.api.nvim_create_augroup("BookmarksProjectLocal", { clear = true }),
			callback = function(ev)
				local new_file = get_bookmark_file(ev.file)
				if new_file ~= bm_config.config.save_file then
					bm_config.config.save_file = new_file
					bm_config.config.cache = { data = {} }
					require("bookmarks.actions").loadBookmarks()
					bm.refresh()
				end
			end,
		})
	end,
}
