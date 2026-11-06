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
        -- 2 = Auto (only enable direct scanout when content type is "game").
        -- Matches CachyOS defaults. Direct scanout bypasses compositor rendering for fullscreen games,
        -- eliminating ~1 frame of latency. Pear-desktop song notifications have been disabled to prevent
        -- overlay popups from kicking the compositor in and out of direct scanout.
        direct_scanout = 2,
    },
    xwayland = {
        force_zero_scaling = true
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
})