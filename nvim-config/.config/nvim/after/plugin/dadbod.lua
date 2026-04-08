-- Clear vim-dadbod-ui connection history
vim.api.nvim_create_user_command("DBUIClear", function()
  local paths = {
    vim.fn.stdpath("data") .. "/db_ui/connections.json",                           -- Linux
    vim.fn.expand("~/.local/share/nvim/db_ui/connections.json"),                   -- Linux alt
    vim.fn.expand("~/Library/Application Support/nvim/db_ui/connections.json"),    -- macOS
  }

  for _, path in ipairs(paths) do
    if vim.fn.filereadable(path) == 1 then
      vim.fn.delete(path)
      print("Deleted: " .. path)
    end
  end

  -- Reload DBUI if it's open
  if vim.fn.exists(":DBUI") == 2 then
    vim.cmd("DBUI")
  end
end, { desc = "Clear vim-dadbod-ui connection history" })




-- Database connections are sourced from environment variables (see ~/.raftrc)
-- Data-fabric cluster requires: kubectl port-forward svc/rdp-postgres 15432:5432 -n data-fabric --context kind-rdp
local dbs = {
  staging = vim.env.STAGING_DB,
  rdp_platform = vim.env.DB_RDP_PLATFORM,
  rdp_catalog_api = vim.env.DB_RDP_CATALOG_API,
  rdp_backend = vim.env.DB_RDP_BACKEND,
}
vim.g.dbs = dbs

