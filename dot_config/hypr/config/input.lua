-- Input configuration

hl.config({
    input = {
        accel_profile = "flat",
        kb_layout = "us",
        kb_variant = "altgr-intl",
        kb_options = "compose:caps",
        repeat_rate = 40,
        repeat_delay = 250,
        -- Start with numlock on by default.
        numlock_by_default = true,

        -- Increase sensitivity for mouse/trackpad (default: 0).
        -- sensitivity = 0.35,

        -- Turn off mouse acceleration (default: adaptive).
        -- accel_profile = "flat",

        touchpad = {
            -- Use natural (inverse) scrolling.
            -- natural_scroll = true,

            -- Use two-finger clicks for right-click instead of lower-right corner.
            clickfinger_behavior = true,

            -- Control the speed of your scrolling.
            scroll_factor = 0.4,

            -- Enable the touchpad while typing.
            -- disable_while_typing = false,

            -- Left-click-and-drag with three fingers.
            -- drag_3fg = 1,
        },
    },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", action = "close" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left", action = "float" })
