local set = vim.opt

set.nu = true
set.relativenumber = true
set.hlsearch = false
set.incsearch = true
set.hidden = true
set.errorbells = false
set.smartindent = true
set.wrap = false
set.swapfile = false
set.backup = false
set.undofile = true
set.showmode = false
set.showmatch = true
set.smarttab = true
set.autoread = true
set.cursorline = true
set.termguicolors = true
-- Keep normal yanks inside Neovim. Use <leader>y when copying to the host clipboard.
set.clipboard = ""
vim.g.clipboard = "osc52"
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = false -- Use actual tab characters
set.copyindent = true
set.preserveindent = true
set.scrolloff = 8
set.winborder = "rounded"
set.pumheight = 12
if vim.fn.exists("&pummaxwidth") == 1 then
	set.pummaxwidth = 80
end
set.completeopt = { "menu", "menuone", "noselect" }
if vim.fn.has("nvim-0.12") == 1 then
	set.completeopt:append({ "popup", "fuzzy" })
end
set.diffopt:append({ "indent-heuristic" })
if vim.fn.has("nvim-0.12") == 1 then
	set.diffopt:append({ "inline:word" })
end
set.signcolumn = "yes:1"

-- Split behavior: always vertical, always on the right
set.splitright = true
set.splitbelow = false
set.equalalways = false  -- Don't automatically equalize window sizes

-- Prevent automatic comment continuation
set.formatoptions:remove("o")
set.formatoptions:remove("r")
