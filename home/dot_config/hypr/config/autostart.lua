-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("kdeconnect-indicator")
    hl.exec_cmd("input-remapper-control --command autoload")
    hl.exec_cmd("mcp-ctl up")
    -- In mixed refresh rate setups (144Hz eDP-1 + 60Hz HDMI-A-1), mark 144Hz display as
    -- primary in XWayland so X11/Proton games sync their internal timers to 144Hz.
    hl.exec_cmd("xrandr --output eDP-1 --primary")
end)

