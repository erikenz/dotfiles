#!/usr/bin/env fish

# --- Configuration ---
set state_dir "$HOME/.local/state/quickshell"
set sequences_file "$state_dir/sequences.txt"
mkdir -p $state_dir
touch $sequences_file

# --- Helpers ---
function window_exists
    hyprctl clients -j | jq -e --arg class "$argv[1]" '[.[] | select(.class == $class)] | length > 0' >/dev/null
end

function move_to_special_ws
    set ws_name $argv[2]
    set class_name $argv[1]
    if window_exists $class_name
        set addresses (hyprctl clients -j | jq -r --arg class "$class_name" '.[] | select(.class == $class) | .address')
        for addr in $addresses
            hyprctl dispatch movetoworkspacesilent "special:$ws_name,address:$addr"
        end
    end
end

function wait_for_window
    set class_name $argv[1]
    for i in (seq 1 10)
        if window_exists $class_name
            return 0
        end
        sleep 0.5
    end
    echo "Timeout waiting for $class_name window to appear."
    return 1
end

function spawn_app
    set app $argv[1]
    echo "Spawning $app..."
    nohup $app >/dev/null 2>&1 &
end

function specialws
    set target_ws (cat $sequences_file)
    if test -z "$target_ws"
        echo "No special workspace stored in sequences.txt"
        return
    end

    set current_ws (hyprctl activeworkspace -j | jq -r '.name')
    if string match -q "special:$target_ws" $current_ws
        echo "Special workspace '$target_ws' is already active."
    else
        echo "Switching to special workspace: $target_ws"
        hyprctl dispatch togglespecialworkspace $target_ws
    end
end

# --- Commands ---
function communication
    set ws_name communication
    set discord discord
    move_to_special_ws $discord $ws_name
    move_to_special_ws whatsapp $ws_name

    if not window_exists $discord
        spawn_app $discord
        wait_for_window $discord
    end

    echo "$ws_name" >$sequences_file
    hyprctl dispatch togglespecialworkspace $ws_name
end

function music
    set ws_name music
    set ytmusic_class "com.github.th_ch.youtube_music"
    set ytmusic_exec youtube-music
    if not window_exists $ytmusic_class
        spawn_app $ytmusic_exec
        wait_for_window $ytmusic_class
    end
    move_to_special_ws $ytmusic_class $ws_name

    echo "$ws_name" >$sequences_file
    hyprctl dispatch togglespecialworkspace $ws_name
end

function sysmon
    set ws_name sysmon
    if not window_exists btop
        spawn_app btop
        wait_for_window btop
    end
    move_to_special_ws btop $ws_name

    echo "$ws_name" >$sequences_file
    hyprctl dispatch togglespecialworkspace $ws_name
end

function todo
    set ws_name todo
    if not window_exists obsidian
        spawn_app obsidian
        wait_for_window obsidian
    end
    move_to_special_ws obsidian $ws_name

    echo "$ws_name" >$sequences_file
    hyprctl dispatch togglespecialworkspace $ws_name
end

# --- Usage ---
function print_usage
    echo "Usage: ./toggle.fish {communication|music|sysmon|specialws|todo}"
end

# --- Main ---
if test (count $argv) -lt 1
    print_usage
    exit 1
end

switch $argv[1]
    case -h --help
        print_usage
    case communication music sysmon specialws todo
        eval "$argv[1]"
    case '*'
        echo "Unknown command: $argv[1]"
        print_usage
        exit 1
end
