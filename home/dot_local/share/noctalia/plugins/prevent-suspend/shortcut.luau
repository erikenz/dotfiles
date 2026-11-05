--!nonstrict
-- Prevent Suspend - Control Center Shortcut Tile
-- Keeps the system awake while allowing screen-off / DPMS on idle timeout.

local lockAndSuspendEnabled = noctalia.getSetting("idle.behavior.lock-and-suspend.enabled")
-- If lock-and-suspend is disabled (false), Prevent Suspend is active (ON)
local active = (lockAndSuspendEnabled == false)

local function render()
    shortcut.setLabel("No Suspend")
    shortcut.setIcon("device-desktop-off", "device-desktop")
    shortcut.setActive(active)
    shortcut.setEnabled(true)
end

render()

function onClick()
    active = not active
    local newLockAndSuspendEnabled = not active

    noctalia.runAsync({
        "noctalia",
        "msg",
        "config-set",
        "idle.behavior.lock-and-suspend.enabled",
        tostring(newLockAndSuspendEnabled),
    })

    render()
end

function onRightClick()
    noctalia.runAsync({ "noctalia", "msg", "settings-open", "power" })
end
