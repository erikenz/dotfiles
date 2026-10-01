-- Environmental variables
-- if you don't use UWSM, define your variables here (e.g. hl.env("QT_QPA_PLATFORM", "wayland"))
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
local home = os.getenv("HOME") or "/home/erikzen"
hl.env("PATH", home .. "/.local/share/mise/shims:" .. home .. "/.local/bin:" .. (os.getenv("PATH") or ""))
