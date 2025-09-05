#!/bin/bash
# toggle-ws.sh: Toggle Hyprland special workspaces with priority app lists and tag-based window management.
# Usage: ./toggle-ws.sh <workspace>
# Example: ./toggle-ws.sh communication
# Optional config: ~/.config/caelestia/cli.json

set -euo pipefail

# --- CONFIGURATION ---

CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/caelestia/cli.json"
LAST_WS_FILE="${XDG_RUNTIME_DIR:-/tmp}/hyprland_last_specialws"

# Default workspace tags and app lists (used if config file is missing or incomplete)
declare -A WS_TAGS=(
    [music]="special-music"
    [communication]="special-communication"
    [sysmon]="special-sysmon"
    [todo]="special-todo"
)
declare -A WS_APPS=(
    [special-music]="youtube-music spotify"
    [special-communication]="discord whatsapp vesktop equibop"
    [special-sysmon]="btop"
    [special-todo]="todoist"
)

# --- FUNCTIONS ---

print_usage() {
    cat <<EOF
Usage: $0 <workspace>
Toggle/focus Hyprland special workspaces and manage apps.

Arguments:
  <workspace>      Workspace name (e.g., communication, music, sysmon, todo)
  specialws        Focus the last used special workspace

Options:
  -h, --help       Show this help message

Config file:
  ~/.config/caelestia/cli.json (optional)
    {
      "toggles": {
        "music": {
          "tag": "special-music",
          "apps": ["youtube-music", "spotify"]
        },
        "communication": {
          "tag": "special-communication",
          "apps": ["discord", "whatsapp", "vesktop", "equibop"]
        }
      }
    }
EOF
}

# Atomic write to state file
atomic_write() {
    local file="$1"
    local content="$2"
    local tmpfile
    tmpfile="$(mktemp "${file}.XXXXXX")"
    echo "$content" > "$tmpfile"
    mv "$tmpfile" "$file"
}

# Read config file if present, override defaults
load_config() {
    if [[ -f "$CONFIG_FILE" ]] && command -v jq >/dev/null; then
        # Read workspace toggles
        local workspaces
        workspaces=$(jq -r '.toggles | keys[]' "$CONFIG_FILE" 2>/dev/null || true)
        for ws in $workspaces; do
            local tag apps
            tag=$(jq -r ".toggles.\"$ws\".tag // empty" "$CONFIG_FILE")
            apps=$(jq -r ".toggles.\"$ws\".apps // empty | join(\" \")" "$CONFIG_FILE")
            if [[ -n "$tag" && -n "$apps" ]]; then
                WS_TAGS["$ws"]="$tag"
                WS_APPS["$tag"]="$apps"
            fi
        done
    fi
}

get_current_ws() {
    hyprctl activeworkspace | awk '/name:/ {print $2}'
}

get_last_specialws() {
    [[ -f "$LAST_WS_FILE" ]] && cat "$LAST_WS_FILE"
}

set_last_specialws() {
    atomic_write "$LAST_WS_FILE" "$1"
}

focus_ws() {
    hyprctl dispatch workspace "$1"
}

move_window_to_ws() {
    local ws="$1"
    local win_id="$2"
    hyprctl dispatch movetoworkspacesilent "$ws" "$win_id"
}

launch_app_in_ws() {
    local ws="$1"
    local app="$2"
    hyprctl dispatch exec "[workspace:$ws] $app"
}

find_window_by_tag_and_app() {
    local tag="$1"
    local app="$2"
    # Search for a window with the given tag and class
    hyprctl clients | awk -v tag="$tag" -v app="$app" '
        $0 ~ "tags: "tag {found_tag=1}
        found_tag && $0 ~ "class: "app {getline; print $2; exit}
        found_tag=0
    '
}

# --- MAIN LOGIC ---

if [[ $# -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
    print_usage
    exit 0
fi

cmd="$1"

load_config

if [[ "$cmd" == "specialws" ]]; then
    ws=$(get_last_specialws)
    if [[ -n "$ws" ]]; then
        focus_ws "$ws"
    else
        echo "No last special workspace found."
    fi
    exit 0
fi

ws="special:$cmd"
tag="${WS_TAGS[$cmd]:-}"
apps=(${WS_APPS[$tag]:-})

if [[ -z "$tag" || ${#apps[@]} -eq 0 ]]; then
    echo "Unknown workspace or no apps configured: $cmd"
    print_usage
    exit 2
fi

current_ws=$(get_current_ws)

if [[ "$current_ws" == "$ws" ]]; then
    # Toggle back to previous non-special workspace
    prev_ws=$(hyprctl workspaces | awk '!/special:/ {print $2}' | tail -n1)
    if [[ -n "$prev_ws" ]]; then
        focus_ws "$prev_ws"
    fi
else
    set_last_specialws "$ws"
    focus_ws "$ws"
    win_found=""
    # Try to move/focus the highest-priority window with the tag
    for app in "${apps[@]}"; do
        win_id=$(find_window_by_tag_and_app "$tag" "$app")
        if [[ -n "$win_id" ]]; then
            move_window_to_ws "$ws" "$win_id"
            win_found=1
            break
        fi
    done
    # If no window found, launch the first app in the list
    if [[ -z "$win_found" && -n "${apps[0]}" ]]; then
        launch_app_in_ws "$ws" "${apps[0]}"
    fi
fi
