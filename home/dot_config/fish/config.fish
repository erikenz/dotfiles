source /usr/share/cachyos-fish-config/cachyos-config.fish

# Initialize Starship prompt
starship init fish | source

# Initialize mise tool manager
mise activate fish | source

# Default Editor (AstroNvim)
set -gx EDITOR "env NVIM_APPNAME=astronvim nvim"
set -gx VISUAL "env NVIM_APPNAME=astronvim nvim"

# Alias to quickly reload Fish configuration and re-evaluate keybindings live
alias fish-reload='source ~/.config/fish/config.fish; fish_user_key_bindings 2>/dev/null; commandline -f repaint'

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

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias zed=zeditor
alias p=pnpm
alias px='pnpm dlx'
alias b='bun'
alias bx='bunx'
alias npm=pnpm

# Shelly Package Manager (Unified)
alias s='shelly'
alias si='shelly install'
alias sin='shelly install'
alias sr='shelly remove'
alias srm='shelly remove'
alias ssearch='shelly search'
alias sup='shelly upgrade'
alias supdate='shelly update'
alias sls='shelly list'
alias slu='shelly list-updates'
alias spurge='shelly purify'
alias ssync='shelly sync'
alias snews='shelly news'
alias sdown='shelly downgrade'
alias spacfiles='shelly utility -p'

# Shelly Backend-Specific Install (Standard/Arch, AUR, Flatpak, AppImage)
alias sis='shelly install standard'
alias sia='shelly install aur'
alias sif='shelly install flatpak'
alias sii='shelly install appimage'

# Shelly Backend-Specific Remove
alias srs='shelly remove standard'
alias sra='shelly remove aur'
alias srf='shelly remove flatpak'
alias sri='shelly remove appimage'

# Shelly Backend-Specific Search
alias sss='shelly search standard'
alias ssa='shelly search aur'
alias ssf='shelly search flatpak'

# Shelly Backend-Specific List
alias slss='shelly list standard'
alias slsa='shelly list aur'
alias slsf='shelly list flatpak'
alias slsi='shelly list appimage'

# Dotfiles
alias conf-fish='cd ~/.config/fish && n'
alias conf-ghostty='cd ~/.config/ghostty && n'
alias conf-hypr='cd ~/.config/hypr && n'
alias conf-astronvim='cd ~/.config/astronvim && astronvim .'
alias conf-lazyvim='cd ~/.config/lazyvim && lazyvim .'
alias conf-nvim='conf-astronvim'

# Neovim Distros (using 'env' for Fish compatibility)
alias astronvim='env NVIM_APPNAME=astronvim nvim'
alias lazyvim='env NVIM_APPNAME=lazyvim nvim'
alias nvim='astronvim' # Default 'nvim' command calls AstroNvim

alias portainer='docker run -p 8000:8000 -p 9443:9443 --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts'

# Herdr
alias h='herdr'
alias hs='herdr status'
alias hw='herdr workspace list'
alias ht='herdr tab list'
alias hp='herdr pane list'
alias ha='herdr agent list'
alias hstop='herdr server stop'

# Herdr Workspace Helpers
function __herdr_open_workspace --description "Open or focus a Herdr workspace by label, optionally running a command"
    set -l label $argv[1]
    set -l init_cmd $argv[2]
    set -l ws_cwd $argv[3]
    if test -z "$ws_cwd"
        set ws_cwd "$HOME"
    end

    if test -z "$label"
        echo "Usage: __herdr_open_workspace <label> [command] [cwd]"
        return 1
    end

    if not herdr status 2>/dev/null | string match -q "*status: running*"
        herdr server &
        sleep 0.5
    end

    set -l existing_ws (herdr workspace list 2>/dev/null | jq -r --arg lbl "$label" '.result.workspaces[]? | select(.label == $lbl) | .workspace_id')
    if test -n "$existing_ws"
        echo "ℹ️ Herdr workspace '$label' ($existing_ws) is already running. Opening workspace..."
        herdr workspace focus $existing_ws >/dev/null 2>&1
        if test "$HERDR_ENV" != "1"
            herdr
        end
        return 0
    end

    set -l ws (herdr workspace create --label "$label" --cwd "$ws_cwd" 2>/dev/null)
    set -l ws_id (echo $ws | jq -r '.result.workspace.workspace_id // empty')
    set -l pane_id (echo $ws | jq -r '.result.root_pane.pane_id')

    if test -n "$pane_id" -a "$pane_id" != "null"
        if test -n "$init_cmd"
            sleep 0.4
            herdr pane run $pane_id "$init_cmd"
            echo "🚀 Started '$label' in Herdr workspace (pane $pane_id)"
        else
            echo "🚀 Created Herdr workspace '$label' (pane $pane_id)"
        end
        if test -n "$ws_id"
            herdr workspace focus $ws_id >/dev/null 2>&1
        end
        if test "$HERDR_ENV" != "1"
            herdr
        end
    else
        echo "❌ Failed to create Herdr workspace for '$label'"
        return 1
    end
end

function __herdr_close_workspace --description "Close Herdr workspace(s) by label"
    set -l label $argv[1]
    if test -z "$label"
        echo "Usage: __herdr_close_workspace <label>"
        return 1
    end

    set -l ws_ids (herdr workspace list 2>/dev/null | jq -r --arg lbl "$label" '.result.workspaces[]? | select(.label == $lbl) | .workspace_id')
    if test (count $ws_ids) -gt 0
        for ws_id in $ws_ids
            herdr workspace close $ws_id >/dev/null 2>&1
            echo "🛑 Closed Herdr workspace '$label' ($ws_id)"
        end
    else
        echo "⚠️ No running '$label' Herdr workspace found"
    end
end

# Local Server (192.168.0.101)
alias server-connect='ssh server'

function server --description "Open or focus Herdr workspace connected to local server"
    __herdr_open_workspace "server" "server-connect" "$HOME"
end

function server-stop --description "Close local server Herdr workspace"
    __herdr_close_workspace "server"
end

# MCP Hub
alias conf-mcphub='cd ~/.config/mcphub && n'
alias mcphub='mcp-hub --port 37373 --config ~/.config/mcphub/servers.json --watch'

# MCP Hub Endpoints & Status
alias mcphub-status='curl -s http://localhost:37373/api/servers | jq .'
alias mcphub-health='curl -s http://localhost:37373/api/health | jq .'
alias mcphub-tools='curl -s http://localhost:37373/api/servers | jq \'[.servers[] | {server: .name, status: .status, tools: [.capabilities.tools[].name]}]\''
alias mcphub-resources='curl -s http://localhost:37373/api/servers | jq \'[.servers[] | {server: .name, resources: [.capabilities.resources[].name]}]\''
alias mcphub-workspaces='curl -s http://localhost:37373/api/workspaces | jq .'
alias mcphub-auth='curl -s http://localhost:37373/api/servers | jq \'.servers[] | select(.authorizationUrl != null) | {name, authorizationUrl}\''
alias mcphub-refresh='curl -s http://localhost:37373/api/refresh | jq .'
alias mcphub-restart='curl -s -X POST http://localhost:37373/api/restart | jq .'
alias mcphub-hard-restart='curl -s -X POST http://localhost:37373/api/hard-restart | jq .'

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

function mcphub-start
    __herdr_open_workspace "mcp-hub" "mcp-hub --port 37373 --config ~/.config/mcphub/servers.json --watch" "$HOME"
end
alias mcphub-herdr=mcphub-start

function mcphub-stop
    __herdr_close_workspace "mcp-hub"
end

# Qt
set -gx QT_QPA_PLATFORMTHEME qt6ct

# pnpm
set -gx PNPM_HOME "/home/erikzen/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
