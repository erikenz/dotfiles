-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/

if MONITOR_PRESET == "dp-left" then
    -- eDP-1 (primary) on left, HDMI-A-1 (secondary) on right
    hl.monitor({
        output    = MONITOR1,
        mode      = "1920x1080@144",
        position  = "0x0",
        scale     = 1,
    })

    hl.monitor({
        output    = MONITOR2,
        mode      = "1920x1080@60",
        position  = "1920x0",
        scale     = 1,
    })
else
    -- HDMI-A-1 (secondary) on left, eDP-1 (primary) on right
    hl.monitor({
        output    = MONITOR1,
        mode      = "1920x1080@144",
        position  = "1920x0",
        scale     = 1,
    })

    hl.monitor({
        output    = MONITOR2,
        mode      = "3840x2160@60",
        position  = "0x0",
        scale     = 2,
    })
end
