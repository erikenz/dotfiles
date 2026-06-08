-- Utility & Desktop Controls Keybindings
local mainMod = "SUPER"
local noctCall = "qs -c noctalia-shell ipc call "

-- Window actions
hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"), { desc = "Kill unresponsive window" })
hl.bind(mainMod .. " + Q",           hl.dsp.window.close(), { desc = "Close active window" })
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }), { desc = "Toggle floating state" })
hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }), { desc = "Toggle window maximized state" })
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen(), { desc = "Toggle window fullscreen state" })
hl.bind(mainMod .. " + backslash",   hl.dsp.layout("togglesplit"), { desc = "Toggle layout split orientation" })
hl.bind(mainMod .. " + ALT + Escape", hl.dsp.exec_cmd(noctCall .. " lockScreen lock"), { desc = "Lock system screen" })
hl.bind(mainMod .. " + ALT + C",     hl.dsp.exec_cmd(noctCall .. " sessionMenu toggle"), { desc = "Toggle system power/session menu" })

-- Screen Capture & Toolkit (Reference: https://noctalia.dev/plugins/screen-toolkit)
hl.bind(mainMod .. " + P",     hl.dsp.exec_cmd(noctCall .. "plugin:screen-toolkit colorPicker"), { desc = "Screen color picker tool" })
hl.bind("Print",               hl.dsp.exec_cmd(noctCall .. "plugin:screen-toolkit annotate"), { desc = "Take screenshot & annotate area" })
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctCall .. "plugin:screen-toolkit annotateWindow"), { desc = "Take screenshot & annotate window" })
hl.bind(mainMod .. " + R",     hl.dsp.exec_cmd(noctCall .. "plugin:screen-toolkit toggle"), { desc = "Screen recorder tool" })
hl.bind(mainMod .. " + CONTROL + SHIFT + O", hl.dsp.exec_cmd(noctCall .. "plugin:screen-toolkit ocr"), { desc = "Extract text from screen (OCR)" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(noctCall .. "plugin:screen-toolkit qr"), { desc = "Scan QR code from screen" })
hl.bind(mainMod .. " + CONTROL + M", hl.dsp.exec_cmd(noctCall .. "plugin:screen-toolkit measure"), { desc = "Screen measuring ruler tool" })

-- Theming and Wallpaper
hl.bind(mainMod .. " + CONTROL + SHIFT + W", hl.dsp.exec_cmd(noctCall .. " wallpaper toggle"), { desc = "Toggle desktop wallpaper menu" })

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "launcher clipboard"), { desc = "Toggle clipboard history launcher" })

-- Notifications
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "notifications toggleHistory"), { desc = "Toggle notifications history panel" })

-- Keybind Cheatsheet (Vim style help using '?') (Reference: https://noctalia.dev/plugins/keybind-cheatsheet)
hl.bind(mainMod .. " + SHIFT + slash", hl.dsp.exec_cmd(noctCall .. "plugin:keybind-cheatsheet toggle"), { desc = "Toggle keyboard shortcuts cheatsheet" })

