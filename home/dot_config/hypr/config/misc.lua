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
        -- 0 = disabled: Direct scanout causes noticeable hitching/frame drops whenever overlays
        -- or desktop popups (such as song notifications or bar updates from pear-desktop) appear,
        -- as the compositor is forced to repeatedly drop and re-acquire direct KMS hardware scanout.
        -- Keeping it disabled ensures smooth, consistent compositor frame pacing without stutter.
        direct_scanout = 0,
    },
    xwayland = {
        force_zero_scaling = true
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})