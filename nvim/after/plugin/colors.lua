-- require("onedark").setup({
-- 	style = "deep",
-- })
-- require("onedark").load()

-- Load colorscheme based on ~/.dotfiles/themes/current-theme
local current_theme_file = vim.fn.expand("~/.dotfiles/themes/current-theme")
local theme_name = "shift4"  -- default

if vim.fn.filereadable(current_theme_file) == 1 then
  local file = io.open(current_theme_file, "r")
  if file then
    theme_name = file:read("*l") or "shift4"
    file:close()
  end
end

vim.cmd("colorscheme " .. theme_name)
