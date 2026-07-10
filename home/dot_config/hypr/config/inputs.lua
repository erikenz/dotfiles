-- Input configuration

hl.config({
    input = {
        accel_profile = "flat",
        kb_layout = "us",
        kb_variant = "altgr-intl",
        kb_options = "compose:caps",
        repeat_rate = 40,
        repeat_delay = 250,
        numlock_by_default = true,

        touchpad = {
            clickfinger_behavior = true,
            scroll_factor = 0.4,
        },
    },
})

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 3, direction = "left",       action = "float" })
