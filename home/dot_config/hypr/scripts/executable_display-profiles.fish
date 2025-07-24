#!/usr/bin/env fish
# This script creates different display profiles for each
# monitor setup and switches between them when moving between setups

# Monitor description contains the monitor name and where its plugged in, these should be good enough to ID with
function setupHash
    hyprctl monitors | grep description | sort | sha1sum | awk '{ print $1 }'
end

function updateMonitorConfig
    set hash (setupHash)
    set base "$HOME/.config/hypr/hyprland"

    if test -f "$base/monitors.conf.d/$hash.conf"
        echo "Using existing config for $hash"
    else
        echo "Creating new monitor config for $hash"
        cp "$base/monitors.conf.d/default.conf" "$base/monitors.conf.d/$hash.conf"
    end

    echo "Linking $hash.conf to active monitors.conf"
    ln -sf "$base/monitors.conf.d/$hash.conf" "$base/monitors.conf"

    hyprctl reload
end

function monitorDaemon
    if test -z "$HYPRLAND_INSTANCE_SIGNATURE"
        echo "HYPRLAND_INSTANCE_SIGNATURE is not set. Are you inside a Hyprland session?"
        exit 1
    end

    set socket "/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

    if not test -S "$socket"
        echo "Hyprland socket $socket does not exist"
        exit 1
    end

    echo "Listening to Hyprland events for monitor changes..."

    socat - "UNIX-CONNECT:$socket" | while read -l line
        if string match -qr '^monitor(added|removed)' "$line"
            echo "Monitor change detected: $line"
            updateMonitorConfig
        end
    end
end

# Run update immediately
updateMonitorConfig

# Start watching
monitorDaemon
