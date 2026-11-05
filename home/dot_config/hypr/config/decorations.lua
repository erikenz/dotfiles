-- Look and feel configuration

hl.config({
    general = {
        -- Tearing (immediate presentation) triggers atomic async flip failures (EINVAL)
        -- on Intel i915 hybrid setups under Aquamarine / Hyprland 0.57+. Disabled for smooth 144Hz VBlank.
        allow_tearing = false,
        gaps_in = 3,
        gaps_out = 8,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = {
                colors = { CACHYLGREEN, CACHYDGREEN },
                angle = 45,
            },
            inactive_border = CACHYGRAY,
        },
    },
    group = {
        col = {
            border_active = CACHYLBLUE,
            border_inactive = CACHYGRAY,
            border_locked_active = CACHYDBLUE,
            border_locked_inactive = CACHYGRAY,
        },
        groupbar = {
            col = {
                active = CACHYLGREEN,
                inactive = CACHYGRAY,
                locked_active = CACHYDBLUE,
                locked_inactive = CACHYGRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 10,
        active_opacity = 0.95,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1,
        blur = {
            size = 5,
            -- Lowered passes from 4 to 2 to significantly reduce Intel iGPU compositing load
            -- and memory bandwidth, saving battery and GPU power while maintaining smooth blur.
            passes = 2,
            special = true,
        },
    },
})
