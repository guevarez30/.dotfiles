-- require("onedark").setup({
-- 	style = "deep",
-- })
-- require("onedark").load()

-- Load custom Shift4 colorscheme
pcall(function()
  require("shift4").setup()
end)
vim.cmd("colorscheme shift4")
