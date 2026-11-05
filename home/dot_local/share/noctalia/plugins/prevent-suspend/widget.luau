--!nonstrict
-- Prevent Suspend - Top Bar Widget

local lockAndSuspendEnabled = noctalia.getSetting("idle.behavior.lock-and-suspend.enabled")
local active = (lockAndSuspendEnabled == false)

local function render()
    local glyphName = if active then "device-desktop-off" else "device-desktop"
    local glyphColor = if active then "primary" else "on_surface_variant"

    local children = {
        ui.glyph({
            name = glyphName,
            size = 16,
            color = glyphColor,
        }),
    }

    local container = if barWidget.isVertical() then ui.column else ui.row
    barWidget.render(container({ gap = 4, align = "center" }, children))
    barWidget.setTooltip(if active then "Prevent Suspend: Active (Screen-Off Allowed)" else "Prevent Suspend: Inactive (Normal Sleep)")
end

render()

function update()
    render()
end

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
