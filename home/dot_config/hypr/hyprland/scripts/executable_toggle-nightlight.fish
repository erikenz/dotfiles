#!/usr/bin/env fish

# Default temperature values
set ON_TEMP 4000
set OFF_TEMP 6000

# Ensure hyprsunset is running
if not pgrep -x hyprsunset > /dev/null
    setsid uwsm app -- hyprsunset &
    sleep 1 # Give it time to register
end

# Query the current temperature
set CURRENT_TEMP (hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+')

function restart_nightlighted_waybar
    if grep -q "custom/nightlight" ~/.config/waybar/config.jsonc
        omarchy-restart-waybar # restart waybar in case user has waybar module for hyprsunset
    end
end

if test "$CURRENT_TEMP" = "$OFF_TEMP"
    hyprctl hyprsunset temperature $ON_TEMP
    notify-send "  Nightlight screen temperature"
    restart_nightlighted_waybar
else
    hyprctl hyprsunset temperature $OFF_TEMP
    notify-send "   Daylight screen temperature"
    restart_nightlighted_waybar
end
