hl.config({
    dwindle = {
        preserve_split = true,
    },
    misc = {
        col = {
            splash = CACHYLGREEN,
        },
        middle_click_paste = false,
        enable_swallow = true,
        swallow_regex = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",
        -- 0 = disabled: neither internal eDP-1 nor external HDMI-A-1 supports VRR/Adaptive Sync
        vrr = 0,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
    },
    render = {
        -- Direct scanout allows fullscreen games to bypass compositor rendering and scan out
        -- directly to the display hardware, reducing latency and GPU compositing load.
        direct_scanout = 1,
    },
    xwayland = {
        force_zero_scaling = true
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})