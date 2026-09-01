local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- "
local binDir = "/home/erikzen/.config/hypr/bin/"

---------------------------
---- WINDOW MANAGEMENT ----
---------------------------

-- Window manipulation
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hyprctl kill"), { desc = "Kill active window" })
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { desc = "Close active window" })
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }), { desc = "Toggle floating" })
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = 1 }), { desc = "Fullscreen (maximize)" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { desc = "Toggle fullscreen" })
hl.bind(mainMod .. " + backslash", hl.dsp.layout("togglesplit"), { desc = "Toggle split layout" })

-- Change focus (Vim style)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { desc = "Focus window left" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { desc = "Focus window right" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), { desc = "Focus window up" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { desc = "Focus window down" })
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { desc = "Cycle windows" })

-- Move active window around workspaces & monitors (Vim style)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { desc = "Move window left" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { desc = "Move window right" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { desc = "Move window up" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { desc = "Move window down" })
hl.bind(mainMod .. " + CONTROL + SHIFT + L", hl.dsp.window.move({ workspace = "r+1" }),
    { desc = "Move window to next workspace" })
hl.bind(mainMod .. " + CONTROL + SHIFT + H", hl.dsp.window.move({ workspace = "r-1" }),
    { desc = "Move window to previous workspace" })
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ monitor = MONITOR1 }), { desc = "Move window to monitor 1" })
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ monitor = MONITOR2 }), { desc = "Move window to monitor 2" })
-- Move workspace to adjacent monitor
hl.bind(mainMod .. " + CTRL + ALT + H", hl.dsp.workspace.move({ monitor = "l" }),
    { desc = "Move workspace to left monitor" })
hl.bind(mainMod .. " + CTRL + ALT + L", hl.dsp.workspace.move({ monitor = "r" }),
    { desc = "Move workspace to right monitor" })
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.window.move({ monitor = "+1" }),
    { desc = "Move window to next monitor" })
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ monitor = "-1" }),
    { desc = "Move window to previous monitor" })

-- Keyboard-driven window resizing (Vim style)
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }),
    { repeating = true, desc = "Resize window left" })
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }),
    { repeating = true, desc = "Resize window right" })
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }),
    { repeating = true, desc = "Resize window up" })
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }),
    { repeating = true, desc = "Resize window down" })

-- Move & resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { desc = "Drag window with mouse" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { desc = "Resize window with mouse" })

-- Advanced tiling & layout controls
hl.bind(mainMod .. " + O", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin())
end, { desc = "Pop window out (float & pin)" })
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = 1 }), { desc = "Fullscreen (maximize)" })
hl.bind(mainMod .. " + CONTROL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }),
    { desc = "Toggle fullscreen state (client)" })

------------------
---- LAUNCHER ----
------------------

-- Core app launchers
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(launchPrefix .. TERMINAL), { desc = "Launch terminal" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), { desc = "Open file manager" })
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(launchPrefix .. EDITOR), { desc = "Open editor" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), { desc = "Open calculator" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(launchPrefix .. BROWSER), { desc = "Open browser" })

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(launchPrefix .. BROWSER), { desc = "Open browser" })

-- Noctalia UI launchers
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(noctCall .. "settings-toggle"), { desc = "Toggle settings panel" })
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"), { desc = "Toggle control center" })
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"), { desc = "Open app launcher" })
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"), { desc = "Open emoji picker" })
hl.bind(mainMod .. " + CONTROL + Escape", hl.dsp.exec_cmd(noctCall .. "panel-toggle session"),
    { desc = "Open session menu" })

-- Previous workspace
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }), { desc = "Focus previous workspace" })


-- Omarchy-style app launchers
hl.bind(mainMod .. " + ALT + Return",
    hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. ' -e bash -c "tmux attach || tmux new -s Work"'),
    { desc = "Terminal with tmux session" })
hl.bind(mainMod .. " + SHIFT + ALT + B", hl.dsp.exec_cmd(launchPrefix .. BROWSER .. " --private-window"),
    { desc = "Open private browser window" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), { desc = "Open file manager" })
hl.bind("XF86Calculator", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), { desc = "Open calculator" })

-- User custom app launchers (using launch-or-focus)
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd(binDir .. "launch-or-focus youtube 'uwsm app -- pear-desktop'"),
    { desc = "Open YouTube (Pear Desktop)" })
hl.bind(mainMod .. " + SHIFT + ALT + M", hl.dsp.exec_cmd(binDir .. "launch-or-focus-tui cliamp"),
    { desc = "Open cliamp (TUI music player)" })
hl.bind(mainMod .. " + CONTROL + SHIFT + D", hl.dsp.exec_cmd(binDir .. "launch-or-focus-tui lazydocker"),
    { desc = "Open lazydocker (TUI)" })
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.exec_cmd(binDir .. "launch-or-focus-tui btm"),
    { desc = "Open bottom (TUI)" })
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(binDir .. "launch-or-focus vesktop 'uwsm app -- vesktop'"),
    { desc = "Open Vesktop (Discord)" })
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(binDir .. "launch-or-focus ferdium 'uwsm app -- ferdium'"),
    { desc = "Open Ferdium" })
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(binDir .. "launch-or-focus obsidian 'uwsm app -- obsidian'"),
    { desc = "Open Obsidian" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(binDir .. "launch-or-focus steam 'uwsm app -- steam'"),
    { desc = "Open Steam" })
hl.bind(mainMod .. " + SHIFT + Z", hl.dsp.exec_cmd("uwsm app -- zeditor"), { desc = "Open Zed editor" })
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("uwsm app -- typora --enable-wayland-ime"), { desc = "Open Typora" })
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("uwsm app -- bitwarden-desktop"), { desc = "Open Bitwarden" })

-- Chromium Debug launcher
hl.bind(mainMod .. " + SHIFT + R",
    hl.dsp.exec_cmd(binDir ..
        "launch-or-focus chromium 'uwsm app -- chromium --remote-debugging-port=9222 --no-first-run --no-default-browser-check'"),
    { desc = "Open Chromium (debug port 9222)" })

-- User webapp launchers
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://gemini.google.com/app'"),
    { desc = "Open Gemini webapp" })
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://calendar.google.com'"),
    { desc = "Open Google Calendar" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://mail.google.com'"),
    { desc = "Open Gmail" })
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd(binDir .. "launch-webapp 'https://x.com/'"),
    { desc = "Open X (Twitter)" })

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

-- Audio (physical keys)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),
    { locked = true, repeating = true, desc = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"),
    { locked = true, repeating = true, desc = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctCall .. "volume-mute"), { locked = true, desc = "Mute volume" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctCall .. "mic-mute"), { locked = true, desc = "Mute microphone" })

-- Audio (keyboard shortcuts)
hl.bind(mainMod .. " + CONTROL + equal", hl.dsp.exec_cmd(noctCall .. "volume-up"),
    { locked = true, repeating = true, desc = "Volume up" })
hl.bind(mainMod .. " + CONTROL + minus", hl.dsp.exec_cmd(noctCall .. "volume-down"),
    { locked = true, repeating = true, desc = "Volume down" })

-- Media playback (physical keys)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(noctCall .. "media toggle"), { locked = true, desc = "Toggle play/pause" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(noctCall .. "media toggle"), { locked = true, desc = "Toggle play/pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(noctCall .. "media next"), { locked = true, desc = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(noctCall .. "media previous"), { locked = true, desc = "Previous track" })

-- Media playback (keyboard shortcuts)
hl.bind(mainMod .. " + CONTROL + backslash", hl.dsp.exec_cmd(noctCall .. "media toggle"),
    { locked = true, desc = "Toggle play/pause" })
hl.bind(mainMod .. " + CONTROL + SHIFT + equal", hl.dsp.exec_cmd(noctCall .. "media next"),
    { locked = true, desc = "Next track" })
hl.bind(mainMod .. " + CONTROL + SHIFT + minus", hl.dsp.exec_cmd(noctCall .. "media previous"),
    { locked = true, desc = "Previous track" })

-- Screen brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctCall .. "brightness-up"),
    { locked = true, repeating = true, desc = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"),
    { locked = true, repeating = true, desc = "Brightness down" })

-- G600 mouse binds
hl.bind("F19", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"), { desc = "Volume down (G600)" })
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
    { desc = "Volume up (G600)" })
hl.bind("XF86TouchpadOn", hl.dsp.exec_cmd("playerctl previous"), { desc = "Previous track (G600)" })
hl.bind("F23", hl.dsp.exec_cmd("playerctl play-pause"), { desc = "Play/pause (G600)" })
hl.bind("F24", hl.dsp.exec_cmd("playerctl next"), { desc = "Next track (G600)" })

-------------------
---- UTILITIES ----
-------------------

-- Screen capture
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprpicker -a -n"), { desc = "Pick color (hyprpicker)" })
hl.bind("Print", hl.dsp.exec_cmd(noctCall .. "screenshot-region"), { desc = "Screenshot region" })
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"), { desc = "Screenshot fullscreen" })

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"), { desc = "Open clipboard" })

-- Notifications
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"),
    { desc = "Open notifications" })

-- Pot translator
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("curl -s \"127.0.0.1:60828/show_window\" || uwsm app -- pot"),
    { desc = "Open Pot translator" })
hl.bind(mainMod .. " + ALT + P",
    hl.dsp.exec_cmd(
        "grim -g \"$(slurp)\" ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png && curl -s \"127.0.0.1:60828/ocr_recognize?screenshot=false\" || notify-send \"Pot Error\" \"Is Pot running?\""),
    { desc = "OCR screenshot (Pot)" })

-- Translate
hl.bind(mainMod .. " + CONTROL + SHIFT + T", hl.dsp.exec_cmd(binDir .. "hypr-translate"),
    { desc = "Translate selection" })

-- Zoom
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + Minus", function() zoomfunction(-0.3) end, { repeating = true, desc = "Zoom out" })
hl.bind(mainMod .. " + Equal", function() zoomfunction(0.3) end, { repeating = true, desc = "Zoom in" })

--# Zoom with keypad
hl.bind(mainMod .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true, desc = "Zoom out (keypad)" })
hl.bind(mainMod .. " + code:86", function() zoomfunction(0.3) end, { repeating = true, desc = "Zoom in (keypad)" })

-------------------------------
---- WORKSPACES & MONITORS ----
-------------------------------

-- Focus on workspace (absolute, per-monitor)
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { desc = "Focus workspace " .. i })
end

-- Focus on workspace (absolute, all monitors)
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + TAB + " .. key, hl.dsp.focus({ workspace = i }),
        { desc = "Focus workspace " .. i .. " (all monitors)" })
end

-- Focus on monitors
hl.bind(mainMod .. " + CONTROL + 1", hl.dsp.focus({ monitor = MONITOR1 }), { desc = "Focus monitor 1" })
hl.bind(mainMod .. " + CONTROL + 2", hl.dsp.focus({ monitor = MONITOR2 }), { desc = "Focus monitor 2" })
hl.bind(mainMod .. " + CONTROL + 3", hl.dsp.focus({ monitor = MONITOR3 }), { desc = "Focus monitor 3" })

-- Move window to workspace (absolute)
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + CONTROL + " .. key, hl.dsp.window.move({ workspace = i }),
        { desc = "Move window to workspace " .. i })
end

-- Navigate adjacent workspaces on current monitor
hl.bind(mainMod .. " + CONTROL + Right", hl.dsp.focus({ workspace = "m+1" }), { desc = "Focus next workspace" })
hl.bind(mainMod .. " + CONTROL + Left", hl.dsp.focus({ workspace = "m-1" }), { desc = "Focus previous workspace" })
hl.bind(mainMod .. " + CONTROL + Down", hl.dsp.focus({ workspace = "emptym" }), { desc = "Focus empty workspace" })

-- Move window to adjacent workspace on current monitor
hl.bind(mainMod .. " + CONTROL + SHIFT + Right", hl.dsp.window.move({ workspace = "m+1" }),
    { desc = "Move window to next workspace" })
hl.bind(mainMod .. " + CONTROL + SHIFT + Left", hl.dsp.window.move({ workspace = "m-1" }),
    { desc = "Move window to previous workspace" })

-- Navigate empty workspaces
hl.bind(mainMod .. " + CONTROL + J", hl.dsp.focus({ workspace = "emptym" }), { desc = "Focus empty workspace" })

-- Scroll through workspaces & monitors
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }), { desc = "Focus next workspace (scroll)" })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "m-1" }), { desc = "Focus previous workspace (scroll)" })
hl.bind(mainMod .. " + CONTROL + mouse_up", hl.dsp.focus({ workspace = "m+1" }),
    { desc = "Focus next workspace (scroll)" })
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m-1" }),
    { desc = "Focus previous workspace (scroll)" })

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special(), { desc = "Toggle scratchpad" })
