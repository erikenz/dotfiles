hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        -- Master layout is used only by workspace 4 (Android emulator + browser).
        -- mfact 0.273 = ~516px of the ~1890px usable width: the AVD phone frame
        -- (~460px) plus the floating emulator toolbar (~54px) that docks next to it.
        -- new_status defaults to "master", so the newest window is the narrow one
        -- (open the emulator last and it takes the left column).
        mfact = 0.273,
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