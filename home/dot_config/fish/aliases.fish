# ==============================================================================
# Fish Shell Aliases & Command Shortcuts (~/.config/fish/aliases.fish)
# ==============================================================================

# --- 1. Navigation & System ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias r-fish='source ~/.config/fish/config.fish; fish_user_key_bindings 2>/dev/null; commandline -f repaint'

# --- 2. Runtimes, Package Managers & Editors ---
alias p='pnpm'
alias px='pnpm dlx'
alias b='bun'
alias bx='bunx'
alias npm='pnpm'
alias npx='pnpm dlx'
alias zed='zeditor'
alias astronvim='env NVIM_APPNAME=astronvim nvim'
alias lazyvim='env NVIM_APPNAME=lazyvim nvim'
alias nvim='astronvim'
alias portainer='docker run -p 8000:8000 -p 9443:9443 --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts'

# --- 3. Configuration Jumpers (Prefix: cf-*) ---
alias cf-fish='cd ~/.config/fish && n'
alias cf-hypr='cd ~/.config/hypr && n'
alias cf-ghostty='cd ~/.config/ghostty && n'
alias cf-nvim='cd ~/.config/astronvim && n'
alias cf-lazyvim='cd ~/.config/lazyvim && n'
alias cf-mcp='cd ~/.config/mcphub && n'
alias cf-mcphub='cf-mcp'
alias cf-herdr='cd ~/.config/herdr && n'
alias cf-cz='cd ~/.local/share/chezmoi && n'
alias cf-mise='cd ~/.config/mise && n'

# --- 4. Shelly Package Manager (Prefix: s*) ---
# Note: 'ssearch' is used to avoid collision with iproute2's /usr/bin/ss
alias s='shelly'
alias si='shelly install'
alias sr='shelly remove'
alias ssearch='shelly search'
alias sup='shelly upgrade'
alias sls='shelly list'
alias slu='shelly list-updates'
alias spurge='shelly purify'
alias ssync='shelly sync'
alias snews='shelly news'
alias sdown='shelly downgrade'
alias spacfiles='shelly utility -p'

# Backend-specific targets: Standard (sis), AUR (sia), Flatpak (sif), AppImage (sii)
alias sis='shelly install standard'
alias sia='shelly install aur'
alias sif='shelly install flatpak'
alias sii='shelly install appimage'
alias srs='shelly remove standard'
alias sra='shelly remove aur'
alias srf='shelly remove flatpak'
alias sri='shelly remove appimage'
alias sss='shelly search standard'
alias ssa='shelly search aur'
alias ssf='shelly search flatpak'
alias slss='shelly list standard'
alias slsa='shelly list aur'
alias slsf='shelly list flatpak'
alias slsi='shelly list appimage'

# --- 5. Herdr Local Multiplexer (Prefix: h*) ---
alias h='herdr'
alias hs='herdr status'
alias hw='herdr workspace list'
alias ht='herdr tab list'
alias hp='herdr pane list'
alias ha='herdr agent list'
alias hstop='herdr server stop'

# --- 6. Remote Sessions (Server & Laptop) ---
# Home Server
alias server-ssh='ssh server'
alias server-herdr='herdr_server_session_start'
alias server-stop='herdr_server_session_stop'
alias server-tg-start='ssh server "systemctl --user start telegram-bot"'
alias server-tg-stop='ssh server "systemctl --user stop telegram-bot"'
alias server-tg-restart='ssh server "systemctl --user restart telegram-bot"'
alias server-tg-status='ssh server "systemctl --user status telegram-bot"'
alias server-tg-logs='ssh server "journalctl --user -u telegram-bot -f"'

# Remote Laptop (for Termux / Mobile)
alias laptop-ssh='ssh laptop'
alias laptop-herdr='ssh -t laptop "herdr"'
alias laptop-agents='ssh laptop "herdr agent list"'
alias laptop-status='ssh laptop "herdr status"'
alias laptop-wake='ssh server "wakeonlan d8:43:ae:d7:2f:86"'
alias laptop-workspaces='ssh laptop "herdr workspace list"'
alias laptop-lock='ssh laptop "loginctl lock-session 2>/dev/null; or hyprctl dispatch exit"'

# Mobile <-> Laptop Clipboard Sync
alias clip-push='termux_clipboard_push'
alias clip-pull='termux_clipboard_pull'

# --- 7. MCP Hub Controls (Prefix: mcp-*) ---
# Starts mcp-hub daemon in foreground with servers.json
alias mcp-up='mcp-hub --port 37373 --config ~/.config/mcphub/servers.json --watch'
alias mcp-start='__herdr_open_workspace "mcp-hub" "mcp-up" "$HOME"'
alias mcp-stop='__herdr_close_workspace "mcp-hub"'
alias mcp-status='curl -s http://localhost:37373/api/servers | jq .'
alias mcp-health='curl -s http://localhost:37373/api/health | jq .'
alias mcp-tools='curl -s http://localhost:37373/api/servers | jq \'[.servers[] | {server: .name, status: .status, tools: [.capabilities.tools[].name]}]\''
alias mcp-resources='curl -s http://localhost:37373/api/servers | jq \'[.servers[] | {server: .name, resources: [.capabilities.resources[].name]}]\''
alias mcp-workspaces='curl -s http://localhost:37373/api/workspaces | jq .'
alias mcp-auth='curl -s http://localhost:37373/api/servers | jq \'.servers[] | select(.authorizationUrl != null) | {name, authorizationUrl}\''
alias mcp-refresh='curl -s http://localhost:37373/api/refresh | jq .'
alias mcp-server-restart='mcphub-server-restart'

# --- 8. Chezmoi Dotfiles Manager (Prefix: cz*) ---
alias cz='chezmoi'
alias cza='chezmoi apply'
alias czav='chezmoi apply -v'
alias czd='chezmoi diff'
alias czs='chezmoi status'
alias cze='chezmoi edit'
alias czcd='chezmoi cd'
alias czadd='chezmoi add'
alias czra='chezmoi re-add'
alias czu='chezmoi update'
alias czdoc='chezmoi doctor'
