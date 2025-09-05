#!/usr/bin/env fish

# Check if idle inhibitor is enabled and trim whitespace
set IDLE_INHIBITOR_ENABLED (qs -c caelestia ipc call idleInhibitor isEnabled | tr -d '[:space:]')

switch (string lower -- $IDLE_INHIBITOR_ENABLED)
    case "true"
        qs -c caelestia ipc call idleInhibitor disable
        notify-send "󰛊  Stop locking computer when idle"
    case "false"
        qs -c caelestia ipc call idleInhibitor enable
        notify-send "󰛊  Now locking computer when idle"
    case '*'
        notify-send "󰛊  Idle inhibitor state unknown: $IDLE_INHIBITOR_ENABLED"
end
