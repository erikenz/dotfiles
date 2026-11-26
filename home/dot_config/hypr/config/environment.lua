-- Environmental variables
-- if you don't use UWSM, define your variables here (e.g. hl.env("QT_QPA_PLATFORM", "wayland"))
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
local home = os.getenv("HOME") or "/home/erikzen"
hl.env("PATH", home .. "/.local/share/mise/shims:" .. home .. "/.local/bin:" .. (os.getenv("PATH") or ""))

-- Android SDK (Android Studio / AVD emulator, adb). Kept in sync with fish's config.fish so
-- processes spawned by Hyprland (`hyprctl dispatch exec`, keybinds, agents) can find them.
hl.env("ANDROID_HOME", home .. "/Android/Sdk")
hl.env("ANDROID_SDK_ROOT", home .. "/Android/Sdk")
local androidPaths = { "emulator", "platform-tools", "cmdline-tools/latest/bin" }
local androidPath = ""
for _, dir in ipairs(androidPaths) do
	androidPath = androidPath .. home .. "/Android/Sdk/" .. dir .. ":"
end
hl.env("PATH", androidPath .. (os.getenv("PATH") or ""))
