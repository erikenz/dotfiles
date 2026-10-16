-- ~/.config/yazi/init.lua

local home = os.getenv("HOME")
local bookmarks = {
  { tag = "Projects",  path = home .. "/Projects/",     key = "p" },
  { tag = "Vault",     path = home .. "/Vault/",        key = "v" },
  { tag = "Downloads", path = home .. "/Downloads/",    key = "d" },
  { tag = "Documents", path = home .. "/Documents/",    key = "D" },
  { tag = "Config",    path = home .. "/.config/",      key = "c" },
  { tag = "Hyprland",  path = home .. "/.config/hypr/", key = "h" },
}

require("yamb"):setup {
  bookmarks = bookmarks,
  jump_notify = true,
  cli = "fzf",
  path = home .. "/.config/yazi/bookmark",
}
