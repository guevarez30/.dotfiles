require("neogit").setup {
  disable_hint = false,
  disable_commit_confirmation = true,
  auto_refresh = true,
  kind = "vsplit",
  disable_builtin_notifications = true,
  disable_commit_confirmation = true,
  integrations = {
    diffview = true
  },
  commit_popup = {
    kind = "vsplit",
  },
  -- Change the default way of opening popups
  popup = {
    kind = "vsplit",
  },
}
