#!/usr/bin/bash
# This script creates different display profiles for each
# monitor setup and switches between them when moving between setups

# Monitor description contains the monitor name and where its plugged in, these should be good enough to ID with
function setupHash {
    hyprctl monitors | grep description | sort | sha1sum | awk '{ print $1 }'
}

function changeProfile {
    # Get monitor setup hash
    hash=$(setupHash)
    base="$HOME/.config/hypr/hyprland"

    # Check config exists for hash
    if [[ -f "$base/monitors.conf.d/$hash.conf" ]]; then
        # Switch to this setup's config
        ln -sf "$base/monitors.conf.d/$hash.conf" "$base/monitors.conf" 
    else
        # Create and switch to this monitor's config
        cp "$base/monitors.conf.d/default.conf" "$base/monitors.conf.d/$hash.conf"
        ln -sf "$base/monitors.conf.d/$hash.conf" "$base/monitors.conf" 
    fi

    # Reload display config!
    hyprctl reload
}

function handle {
    if [[ ${1:0:12} == "monitoradded" ]]; then
        changeProfile
    elif [[ ${1:0:14} == "monitorremoved" ]]; then
        changeProfile
    fi
}

# Set the profile on startup
changeProfile

# Connect to Hyprland socket and handle each event
socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
