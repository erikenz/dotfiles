-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output    = MONITOR1,
    mode      = "1920x1080",
    position  = "0x0",
    scale     = 1,
})

hl.monitor({
    output    = MONITOR2,
    mode      = "1920x1080@144",
    position  = "1920x0",
    scale     = 1,
})
