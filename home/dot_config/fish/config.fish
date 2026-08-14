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

# Qt
set -gx QT_QPA_PLATFORMTHEME qt6ct

# pnpm
set -gx PNPM_HOME "/home/erikzen/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
