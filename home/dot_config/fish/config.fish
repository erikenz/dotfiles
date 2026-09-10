# Source CachyOS fish config if available
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# Initialize Starship prompt
if command -q starship
    starship init fish | source
end

# Initialize mise tool manager
if command -q mise
    mise activate fish | source
end

# pi coding agent config directory (settings, auth, sessions, packages)
set -gx PI_CODING_AGENT_DIR "$HOME/.config/pi/agent"

# Default Editor (AstroNvim)
set -gx EDITOR "env NVIM_APPNAME=astronvim nvim"
set -gx VISUAL "env NVIM_APPNAME=astronvim nvim"

# Qt platform theme (Desktop Linux)
if test -n "$WAYLAND_DISPLAY" -o -n "$DISPLAY"
    set -gx QT_QPA_PLATFORMTHEME qt6ct
end

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end

# Canonical Fish User Keybindings override
function fish_user_key_bindings
    # Remap default Fish clear-screen to Alt+L
    bind \el clear-screen

    # Native Fish Ctrl+h/j/k/l bindings to focus adjacent Herdr panes quietly (stdout & stderr suppressed)
    bind ctrl-h 'herdr pane focus --current --direction left >/dev/null 2>&1; commandline -f repaint'
    bind ctrl-j 'herdr pane focus --current --direction down >/dev/null 2>&1; commandline -f repaint'
    bind ctrl-k 'herdr pane focus --current --direction up >/dev/null 2>&1; commandline -f repaint'
    bind ctrl-l 'herdr pane focus --current --direction right >/dev/null 2>&1; commandline -f repaint'

    bind -M insert ctrl-h 'herdr pane focus --current --direction left >/dev/null 2>&1; commandline -f repaint'
    bind -M insert ctrl-j 'herdr pane focus --current --direction down >/dev/null 2>&1; commandline -f repaint'
    bind -M insert ctrl-k 'herdr pane focus --current --direction up >/dev/null 2>&1; commandline -f repaint'
    bind -M insert ctrl-l 'herdr pane focus --current --direction right >/dev/null 2>&1; commandline -f repaint'
end

# Unified Upgrade Function (Shelly + Mise)
function upgrade
    echo "📦 Upgrading Arch, AUR, and Flatpaks via Shelly..."
    shelly upgrade $argv
    echo "⚡ Upgrading Mise tools (agy, etc.)..."
    mise upgrade
end

# Convenience 'n' function
function n
    if test (count $argv) -eq 0
        astronvim .
    else
        astronvim $argv
    end
end

# Interactive Neovim Distro Selector (requires fzf)
function nvims
    set -l config (string split " " "astronvim lazyvim" | fzf --prompt=" Select Neovim Config ❯ " --height=~40% --layout=reverse --border)
    if test -n "$config"
        env NVIM_APPNAME=$config nvim $argv
    end
end

# Herdr Workspace Helpers
function __herdr_open_workspace --description "Open or focus a Herdr workspace by label, optionally running a command in a session"
    set -l label $argv[1]
    set -l init_cmd $argv[2]
    set -l ws_cwd $argv[3]
    set -l session $argv[4]
    if test -z "$ws_cwd"
        set ws_cwd "$HOME"
    end
    if test -z "$session"
        set session (set -q HERDR_DEFAULT_SESSION; and echo $HERDR_DEFAULT_SESSION; or echo "dev")
    end

    if test -z "$label"
        echo "Usage: __herdr_open_workspace <label> [command] [cwd] [session]"
        return 1
    end

    if not herdr --session "$session" status 2>/dev/null | string match -q "*status: running*"
        setsid herdr --session "$session" server >/dev/null 2>&1 &
        set -l attempts 0
        while not herdr --session "$session" status 2>/dev/null | string match -q "*status: running*"
            set attempts (math $attempts + 1)
            if test $attempts -ge 20
                echo "❌ Failed to start Herdr server for session '$session'"
                return 1
            end
            sleep 0.2
        end
    end

    set -l existing_ws (herdr --session "$session" workspace list 2>/dev/null | jq -r --arg lbl "$label" '.result.workspaces[]? | select(.label == $lbl) | .workspace_id')
    if test -n "$existing_ws"
        echo "ℹ️ Herdr workspace '$label' ($existing_ws) in session '$session' is already running. Opening workspace..."
        herdr --session "$session" workspace focus $existing_ws >/dev/null 2>&1
        if test "$HERDR_ENV" != "1" -a -t 1
            herdr session attach "$session"
        end
        return 0
    end

    set -l ws (herdr --session "$session" workspace create --label "$label" --cwd "$ws_cwd" 2>/dev/null)
    set -l ws_id (echo $ws | jq -r '.result.workspace.workspace_id // empty')
    set -l pane_id (echo $ws | jq -r '.result.root_pane.pane_id')

    if test -n "$pane_id" -a "$pane_id" != "null"
        if test -n "$init_cmd"
            sleep 0.4
            herdr --session "$session" pane run $pane_id "$init_cmd"
            echo "🚀 Started '$label' in Herdr session '$session' (pane $pane_id)"
        else
            echo "🚀 Created Herdr workspace '$label' in session '$session' (pane $pane_id)"
        end
        if test -n "$ws_id"
            herdr --session "$session" workspace focus $ws_id >/dev/null 2>&1
        end
        if test "$HERDR_ENV" != "1" -a -t 1
            herdr session attach "$session"
        end
    else
        echo "❌ Failed to create Herdr workspace for '$label' in session '$session'"
        return 1
    end
end

function __herdr_close_workspace --description "Close Herdr workspace(s) by label in a session"
    set -l label $argv[1]
    set -l session $argv[2]
    if test -z "$session"
        set session (set -q HERDR_DEFAULT_SESSION; and echo $HERDR_DEFAULT_SESSION; or echo "dev")
    end

    if test -z "$label"
        echo "Usage: __herdr_close_workspace <label> [session]"
        return 1
    end

    set -l ws_ids (herdr --session "$session" workspace list 2>/dev/null | jq -r --arg lbl "$label" '.result.workspaces[]? | select(.label == $lbl) | .workspace_id')
    if test (count $ws_ids) -gt 0
        for ws_id in $ws_ids
            herdr --session "$session" workspace close $ws_id >/dev/null 2>&1
            echo "🛑 Closed Herdr workspace '$label' ($ws_id) in session '$session'"
        end
    else
        echo "⚠️ No running '$label' Herdr workspace found in session '$session'"
    end
end

# Persistent Herdr Session for Local Development
function herdr_dev_session_start --description "Launch or attach to the persistent 'dev' Herdr session"
    herdr session attach dev
end

function herdr_dev_session_stop --description "Stop the 'dev' Herdr session"
    herdr session stop dev
end

# Isolated Herdr Session for Home Server (192.168.0.101)
function herdr_server_session_start --description "Launch or attach to an isolated Herdr session for the home server"
    herdr session attach server
end

function herdr_server_session_stop --description "Stop the isolated 'server' Herdr session"
    herdr session stop server
end

# Two-Way Mobile <-> Laptop Clipboard Sync (Termux API <-> Wayland wl-clipboard)
function termux_clipboard_push --description "Push local Android clipboard to remote laptop Hyprland clipboard"
    if command -q termux-clipboard-get
        termux-clipboard-get | ssh laptop "wl-copy"
        echo "📋 Pushed mobile clipboard to laptop"
    else
        echo "termux-clipboard-get not found (requires Termux:API)"
    end
end

function termux_clipboard_pull --description "Pull remote laptop Hyprland clipboard to local Android clipboard"
    if command -q termux-clipboard-set
        ssh laptop "wl-paste" | termux-clipboard-set
        echo "📋 Pulled laptop clipboard to mobile"
    else
        echo "termux-clipboard-set not found (requires Termux:API)"
    end
end

# MCP Hub Management Functions
function mcphub-server-info
    if test (count $argv) -eq 0
        echo "Usage: mcphub-server-info <server_name>"
        return 1
    end
    curl -s -X POST http://localhost:37373/api/servers/info \
        -H "Content-Type: application/json" \
        -d "{\"server_name\": \"$argv[1]\"}" | jq .
end

function mcphub-server-start
    if test (count $argv) -eq 0
        echo "Usage: mcphub-server-start <server_name>"
        return 1
    end
    curl -s -X POST http://localhost:37373/api/servers/start \
        -H "Content-Type: application/json" \
        -d "{\"server_name\": \"$argv[1]\"}" | jq .
end

function mcphub-server-stop
    if test (count $argv) -eq 0
        echo "Usage: mcphub-server-stop <server_name>"
        return 1
    end
    curl -s -X POST http://localhost:37373/api/servers/stop \
        -H "Content-Type: application/json" \
        -d "{\"server_name\": \"$argv[1]\"}" | jq .
end

function mcphub-server-restart
    if test (count $argv) -eq 0
        echo "Usage: mcphub-server-restart <server_name>"
        return 1
    end
    mcphub-server-stop $argv[1]
    mcphub-server-start $argv[1]
end

function mcphub-call-tool
    if test (count $argv) -lt 2
        echo "Usage: mcphub-call-tool <server_name> <tool_name> [arguments_json]"
        return 1
    end
    set -l args "{}"
    if test (count $argv) -ge 3
        set args "$argv[3]"
    end
    curl -s -X POST http://localhost:37373/api/servers/tools \
        -H "Content-Type: application/json" \
        -d "{\"server_name\": \"$argv[1]\", \"tool\": \"$argv[2]\", \"arguments\": $args}" | jq .
end

# Load external aliases
if test -f ~/.config/fish/aliases.fish
    source ~/.config/fish/aliases.fish
end

# sentry
fish_add_path "/home/erikzen/.local/share/mise/installs/node/24.20.0/bin"
