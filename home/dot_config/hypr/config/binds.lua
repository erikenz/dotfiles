local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- "
local binDir = "/home/erikzen/.config/hypr/bin/"

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + Q",           hl.dsp.window.close())
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + backslash",   hl.dsp.layout("togglesplit"))

-- Change focus (Vim style)
hl.bind(mainMod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",     hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab",           hl.dsp.window.cycle_next())

-- Move active window around workspaces & monitors (Vim style)
hl.bind(mainMod .. " + SHIFT + H",                  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L",                  hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K",                  hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J",                  hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + L",        hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + H",        hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + 1",                  hl.dsp.window.move({ monitor = MONITOR1 }))
hl.bind(mainMod .. " + SHIFT + 2",                  hl.dsp.window.move({ monitor = MONITOR2 }))
-- Move workspace to adjacent monitor
hl.bind(mainMod .. " + CTRL + ALT + H", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + CTRL + ALT + L", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + mouse_up",           hl.dsp.window.move({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down",         hl.dsp.window.move({ monitor = "-1" }))

-- Keyboard-driven window resizing (Vim style)
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }),  { repeating = true })

-- Move & resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Advanced tiling & layout controls
hl.bind(mainMod .. " + O", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin())
end, { desc = "Pop window out (float & pin)" })
hl.bind(mainMod .. " + ALT + F",     hl.dsp.window.fullscreen({ mode = 1 }))
hl.bind(mainMod .. " + CONTROL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }))

------------------
---- LAUNCHER ----
------------------

-- Core app launchers
hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind(mainMod .. " + T",          hl.dsp.exec_cmd(launchPrefix .. EDITOR))
hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(launchPrefix .. BROWSER))

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(launchPrefix .. BROWSER))

-- Noctalia UI launchers
hl.bind(mainMod .. " + Z",          hl.dsp.exec_cmd(noctCall .. "settings-toggle"))
hl.bind(mainMod .. " + X",          hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"))
hl.bind(mainMod .. " + period",     hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"))
hl.bind(mainMod .. " + ALT + L",     hl.dsp.exec_cmd(noctCall .. "session lock"))
hl.bind(mainMod .. " + CONTROL + Escape",    hl.dsp.exec_cmd(noctCall .. "panel-toggle session"))

-- Previous workspace
hl.bind(mainMod .. " + Tab",        hl.dsp.focus({ workspace = "previous" }))

-- System monitor
hl.bind("CONTROL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"))

-- Omarchy-style app launchers
hl.bind(mainMod .. " + ALT + Return",     hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. ' -e bash -c "tmux attach || tmux new -s Work"'))
hl.bind(mainMod .. " + SHIFT + ALT + B",  hl.dsp.exec_cmd(launchPrefix .. BROWSER .. " --private-window"))
hl.bind(mainMod .. " + SHIFT + F",        hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER))
hl.bind("XF86Calculator",                 hl.dsp.exec_cmd(launchPrefix .. CALCULATOR))

-- User custom app launchers (using launch-or-focus)
hl.bind(mainMod .. " + SHIFT + M",           hl.dsp.exec_cmd(binDir .. "launch-or-focus youtube 'uwsm app -- pear-desktop'"))
hl.bind(mainMod .. " + SHIFT + ALT + M",     hl.dsp.exec_cmd(binDir .. "launch-or-focus-tui cliamp"))
hl.bind(mainMod .. " + CONTROL + SHIFT + D", hl.dsp.exec_cmd(binDir .. "launch-or-focus-tui lazydocker"))
hl.bind(mainMod .. " + SHIFT + Escape",      hl.dsp.exec_cmd(binDir .. "launch-or-focus-tui btop"))
hl.bind(mainMod .. " + SHIFT + D",           hl.dsp.exec_cmd(binDir .. "launch-or-focus vesktop 'uwsm app -- vesktop'"))
hl.bind(mainMod .. " + SHIFT + G",           hl.dsp.exec_cmd(binDir .. "launch-or-focus ferdium 'uwsm app -- ferdium'"))
hl.bind(mainMod .. " + SHIFT + O",           hl.dsp.exec_cmd(binDir .. "launch-or-focus obsidian 'uwsm app -- obsidian'"))
hl.bind(mainMod .. " + SHIFT + S",           hl.dsp.exec_cmd(binDir .. "launch-or-focus steam 'uwsm app -- steam'"))
hl.bind(mainMod .. " + SHIFT + Z",           hl.dsp.exec_cmd("uwsm app -- zeditor"))
hl.bind(mainMod .. " + SHIFT + T",           hl.dsp.exec_cmd("uwsm app -- typora --enable-wayland-ime"))
hl.bind(mainMod .. " + SHIFT + B",           hl.dsp.exec_cmd("uwsm app -- bitwarden-desktop"))

-- Chromium Debug launcher
hl.bind(mainMod .. " + SHIFT + R",           hl.dsp.exec_cmd(binDir .. "launch-or-focus chromium 'uwsm app -- chromium --remote-debugging-port=9222 --no-first-run --no-default-browser-check'"))

-- User webapp launchers
hl.bind(mainMod .. " + SHIFT + A",           hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://gemini.google.com/app'"))
hl.bind(mainMod .. " + SHIFT + C",           hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://calendar.google.com'"))
hl.bind(mainMod .. " + SHIFT + E",           hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://mail.google.com'"))
hl.bind(mainMod .. " + SHIFT + X",           hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://x.com/'"))

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio (physical keys)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noctCall .. "mic-mute"),    { locked = true })

-- Audio (keyboard shortcuts)
hl.bind(mainMod .. " + CONTROL + equal", hl.dsp.exec_cmd(noctCall .. "volume-up"),   { locked = true, repeating = true })
hl.bind(mainMod .. " + CONTROL + minus", hl.dsp.exec_cmd(noctCall .. "volume-down"), { locked = true, repeating = true })

-- Media playback (physical keys)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd(noctCall .. "media next"),     { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })

-- Media playback (keyboard shortcuts)
hl.bind(mainMod .. " + CONTROL + backslash",      hl.dsp.exec_cmd(noctCall .. "media toggle"),   { locked = true })
hl.bind(mainMod .. " + CONTROL + SHIFT + equal",  hl.dsp.exec_cmd(noctCall .. "media next"),     { locked = true })
hl.bind(mainMod .. " + CONTROL + SHIFT + minus",  hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true })

-- Screen brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctCall .. "brightness-up"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { locked = true, repeating = true })

-- G600 mouse binds
hl.bind("F19",                  hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86TouchpadToggle",   hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86TouchpadOn",       hl.dsp.exec_cmd("playerctl previous"))
hl.bind("F23",                  hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("F24",                  hl.dsp.exec_cmd("playerctl next"))

-------------------
---- UTILITIES ----
-------------------

-- Screen capture
hl.bind(mainMod .. " + P",     hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("Print",               hl.dsp.exec_cmd(noctCall .. "screenshot-region"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"))

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"))

-- Notifications
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"))

-- Pot translator
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("curl -s \"127.0.0.1:60828/show_window\" || uwsm app -- pot"))
hl.bind(mainMod .. " + ALT + P",   hl.dsp.exec_cmd("grim -g \"$(slurp)\" ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png && curl -s \"127.0.0.1:60828/ocr_recognize?screenshot=false\" || notify-send \"Pot Error\" \"Is Pot running?\""))

-- Translate
hl.bind(mainMod .. " + CONTROL + SHIFT + T", hl.dsp.exec_cmd(binDir .. "hypr-translate"))

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Focus on workspace (absolute, per-monitor)
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end

-- Focus on workspace (absolute, all monitors)
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + TAB + " .. key, hl.dsp.focus({ workspace = i }))
end

-- Focus on monitors
hl.bind(mainMod .. " + CONTROL + 1", hl.dsp.focus({ monitor = MONITOR1 }))
hl.bind(mainMod .. " + CONTROL + 2", hl.dsp.focus({ monitor = MONITOR2 }))
hl.bind(mainMod .. " + CONTROL + 3", hl.dsp.focus({ monitor = MONITOR3 }))

-- Move window to workspace (absolute)
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + CONTROL + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Navigate adjacent workspaces on current monitor
hl.bind(mainMod .. " + CONTROL + Right",       hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + Left",        hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + Down",        hl.dsp.focus({ workspace = "emptym" }))

-- Move window to adjacent workspace on current monitor
hl.bind(mainMod .. " + CONTROL + SHIFT + Right", hl.dsp.window.move({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",  hl.dsp.window.move({ workspace = "m-1" }))

-- Navigate empty workspaces
hl.bind(mainMod .. " + CONTROL + J",       hl.dsp.focus({ workspace = "emptym" }))

-- Scroll through workspaces & monitors
hl.bind(mainMod .. " + mouse_down",           hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_up",             hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m-1" }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + grave",         hl.dsp.workspace.toggle_special())
