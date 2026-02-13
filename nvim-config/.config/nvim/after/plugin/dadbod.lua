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

local dbs = {
  staging = vim.env.STAGING_DB,
  -- Data-fabric cluster (requires: kubectl port-forward svc/rdp-postgres 15432:5432 -n data-fabric --context kind-rdp)
  rdp_platform = "postgresql://rdp_platform:6vHqLeCg7Rz3OnUYs4x14cxN@localhost:15432/rdp_platform",
  rdp_catalog_api = "postgresql://rdp_catalog_api:hhNOEDyTRvM9LBq8DACxQmrn@localhost:15432/rdp_catalog_api",
  rdp_backend = "postgresql://rdp_backend:KsK5uHPYepGh0P47SDXyEYju@localhost:15432/rdp_backend",
}
vim.g.dbs = dbs
vim.g.db = dbs.rdp_platform
