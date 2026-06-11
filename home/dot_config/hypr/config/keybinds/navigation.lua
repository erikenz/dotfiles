-- Navigation Keybindings
local mainMod = "SUPER"

-- Change focus (Neovim style)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { desc = "Focus window left" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { desc = "Focus window right" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), { desc = "Focus window up" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { desc = "Focus window down" })
hl.bind("ALT + Tab",       hl.dsp.window.cycle_next(), { desc = "Cycle to next window" })

-- Move active window around current workspace (Neovim style)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { desc = "Move window left" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { desc = "Move window right" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { desc = "Move window up" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { desc = "Move window down" })
hl.bind(mainMod .. " + CONTROL + SHIFT + L", hl.dsp.window.move({ workspace = "r+1" }), { desc = "Move window to next workspace" })
hl.bind(mainMod .. " + CONTROL + SHIFT + H", hl.dsp.window.move({ workspace = "r-1" }), { desc = "Move window to previous workspace" })

-- Keyboard-driven window resizing (Neovim style)
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true, desc = "Shrink window width" })
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }),  { repeating = true, desc = "Grow window width" })
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true, desc = "Shrink window height" })
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }),  { repeating = true, desc = "Grow window height" })

-- Mouse move & resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { desc = "Drag floating window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { desc = "Resize floating window" })

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }), { desc = "Switch to workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }), { desc = "Move window to workspace " .. i })
    hl.bind(mainMod .. " + ALT + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }), { desc = "Move window silently to workspace " .. i })
end

hl.bind(mainMod .. " + CONTROL + L",       hl.dsp.focus({ workspace = "r+1" }), { desc = "Switch to next workspace" })
hl.bind(mainMod .. " + CONTROL + H",       hl.dsp.focus({ workspace = "r-1" }), { desc = "Switch to previous workspace" })
hl.bind(mainMod .. " + CONTROL + J",       hl.dsp.focus({ workspace = "empty" }), { desc = "Switch to first empty workspace" })
hl.bind(mainMod .. " + CONTROL + ALT + L", hl.dsp.window.move({ workspace = "r+1" }), { desc = "Move window to next workspace and follow" })
hl.bind(mainMod .. " + CONTROL + ALT + H", hl.dsp.window.move({ workspace = "r-1" }), { desc = "Move window to previous workspace and follow" })

-- Omarchy-style workspace navigation (using comma and period)
hl.bind(mainMod .. " + SHIFT + period",    hl.dsp.focus({ workspace = "r+1" }), { desc = "Switch to next workspace (Omarchy style)" })
hl.bind(mainMod .. " + SHIFT + comma",     hl.dsp.focus({ workspace = "r-1" }), { desc = "Switch to previous workspace (Omarchy style)" })
hl.bind(mainMod .. " + CONTROL + SHIFT + period", hl.dsp.window.move({ workspace = "r+1", follow = false }), { desc = "Move window silently to next workspace" })
hl.bind(mainMod .. " + CONTROL + SHIFT + comma",  hl.dsp.window.move({ workspace = "r-1", follow = false }), { desc = "Move window silently to previous workspace" })

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { desc = "Focus next workspace" })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { desc = "Focus previous workspace" })

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + CONTROL + SHIFT + S", hl.dsp.window.move({ workspace = "special" }), { desc = "Move window to scratchpad" })
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special(), { desc = "Toggle scratchpad workspace" })

-- Advanced Tiling & Layout Controls (from Omarchy)
hl.bind(mainMod .. " + O", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.pin())
end, { desc = "Pop window out (float & pin)" })
hl.bind(mainMod .. " + ALT + F",     hl.dsp.window.fullscreen({ mode = 1 }), { desc = "Toggle maximized window" })
hl.bind(mainMod .. " + CONTROL + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }), { desc = "Toggle tiled fullscreen (show panel)" })

-- Move current workspace to monitor (Vim style)
hl.bind(mainMod .. " + ALT + SHIFT + H", hl.dsp.workspace.move({ monitor = "l" }), { desc = "Move current workspace to left monitor" })
hl.bind(mainMod .. " + ALT + SHIFT + L", hl.dsp.workspace.move({ monitor = "r" }), { desc = "Move current workspace to right monitor" })
hl.bind(mainMod .. " + Tab",           hl.dsp.focus({ workspace = "previous" }), { desc = "Switch to previous active workspace" })

