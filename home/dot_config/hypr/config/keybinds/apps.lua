-- Application Launching Keybindings
local mainMod = "SUPER"
local noctCall = "qs -c noctalia-shell ipc call "
local launchPrefix = "uwsm app -- "

hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL), { desc = "Launch terminal" })
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), { desc = "Launch file manager" })
hl.bind(mainMod .. " + T",          hl.dsp.exec_cmd(launchPrefix .. EDITOR), { desc = "Launch text editor" })
hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), { desc = "Launch calculator" })
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launchPrefix .. BROWSER), { desc = "Launch web browser" })
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. "btop"), { desc = "Launch system monitor (btop)" })

-- Noctalia UI Launchers
hl.bind(mainMod .. " + Z",      hl.dsp.exec_cmd(noctCall .. "settings toggle"), { desc = "Toggle settings panel" })
hl.bind(mainMod .. " + X",      hl.dsp.exec_cmd(noctCall .. "controlCenter toggle"), { desc = "Toggle control center" })
hl.bind(mainMod .. " + Space",  hl.dsp.exec_cmd(noctCall .. "launcher toggle"), { desc = "Toggle application launcher" })
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(noctCall .. "launcher emoji"), { desc = "Toggle emoji picker" })

-- Omarchy-style App Launchers
hl.bind(mainMod .. " + ALT + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. ' -e bash -c "tmux attach || tmux new -s Work"'), { desc = "Launch terminal inside tmux session (attach or create 'Work')" })
hl.bind(mainMod .. " + SHIFT + ALT + B",  hl.dsp.exec_cmd(launchPrefix .. BROWSER .. " --private-window"), { desc = "Launch private web browser" })
hl.bind(mainMod .. " + SHIFT + F",        hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), { desc = "Launch file manager alternate" })
hl.bind("XF86Calculator",                 hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), { desc = "Launch calculator key" })

-- User Custom Ported App Launchers (using launch-or-focus)
local binDir = "/home/erikzen/.config/hypr/bin/"
hl.bind(mainMod .. " + SHIFT + M",           hl.dsp.exec_cmd(binDir .. "launch-or-focus youtube 'uwsm app -- pear-desktop'"), { desc = "Launch or focus YouTube Music" })
hl.bind(mainMod .. " + SHIFT + ALT + M",     hl.dsp.exec_cmd(binDir .. "launch-or-focus-tui cliamp"), { desc = "Launch or focus Cliamp Music TUI" })
hl.bind(mainMod .. " + CONTROL + SHIFT + D", hl.dsp.exec_cmd(binDir .. "launch-or-focus-tui lazydocker"), { desc = "Launch or focus LazyDocker TUI" })
hl.bind(mainMod .. " + SHIFT + D",           hl.dsp.exec_cmd(binDir .. "launch-or-focus vesktop 'uwsm app -- vesktop'"), { desc = "Launch or focus Discord (Vesktop)" })
hl.bind(mainMod .. " + SHIFT + G",           hl.dsp.exec_cmd(binDir .. "launch-or-focus ferdium 'uwsm app -- ferdium'"), { desc = "Launch or focus Ferdium" })
hl.bind(mainMod .. " + SHIFT + O",           hl.dsp.exec_cmd(binDir .. "launch-or-focus obsidian 'uwsm app -- obsidian'"), { desc = "Launch or focus Obsidian" })
hl.bind(mainMod .. " + SHIFT + S",           hl.dsp.exec_cmd(binDir .. "launch-or-focus steam 'uwsm app -- steam'"), { desc = "Launch or focus Steam" })
hl.bind(mainMod .. " + SHIFT + Z",           hl.dsp.exec_cmd("uwsm app -- zeditor"), { desc = "Launch Zed Editor" })
hl.bind(mainMod .. " + SHIFT + W",           hl.dsp.exec_cmd("uwsm app -- typora --enable-wayland-ime"), { desc = "Launch Typora" })
hl.bind(mainMod .. " + SHIFT + slash",       hl.dsp.exec_cmd("uwsm app -- bitwarden-desktop"), { desc = "Launch Bitwarden" })

-- User Webapp Launchers
hl.bind(mainMod .. " + SHIFT + A",           hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://gemini.google.com/app'"), { desc = "Launch Gemini Web App" })
hl.bind(mainMod .. " + SHIFT + C",           hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://calendar.google.com'"), { desc = "Launch Google Calendar Web App" })
hl.bind(mainMod .. " + SHIFT + E",           hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://mail.google.com'"), { desc = "Launch Google Mail Web App" })
hl.bind(mainMod .. " + SHIFT + X",           hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://x.com/'"), { desc = "Launch X (Twitter) Web App" })

