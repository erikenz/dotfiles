hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        -- Only workspace 4 (browser + Android emulator) uses this layout.
        -- Hyprland can only control tiled widths through layout ratios, so the emulator's
        -- column width is set here: mfact is the master (browser) share, the slave column
        -- next to it gets the rest (~513px of the ~1890px usable width, which is the phone
        -- frame plus the floating emulator toolbar that docks beside it).
        -- orientation "right" keeps the browser master on the right, so the emulator's
        -- narrow column sits on the left. new_status "slave" means a newly opened window
        -- joins as the narrow column, whichever order you launch things in.
        mfact = 0.727,
        orientation = "right",
        new_status = "slave",
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