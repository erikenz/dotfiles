#!/usr/bin/env fish

# Check if idle inhibitor is enabled and trim whitespace
set IDLE_INHIBITOR_ENABLED (qs -c caelestia ipc call idleInhibitor isEnabled | tr -d '[:space:]')

switch (string lower -- $IDLE_INHIBITOR_ENABLED)
    case true
        qs -c caelestia ipc call idleInhibitor disable
        caelestia shell toaster info "Idle inhibitor disabled" "System will lock when idle." "󰛊"
    case false
        qs -c caelestia ipc call idleInhibitor enable
        caelestia shell toaster info "Idle inhibitor enabled" "System will not lock when idle." "󰛊"
    case '*'
        caelestia shell toaster error "Idle inhibitor state unknown: $IDLE_INHIBITOR_ENABLED" "Please check the logs." "󰛊"
end
