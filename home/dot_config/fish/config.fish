source /usr/share/cachyos-fish-config/cachyos-config.fish

# Initialize Starship prompt
starship init fish | source

# Initialize mise tool manager
mise activate fish | source

# Default Editor (AstroNvim)
set -gx EDITOR "env NVIM_APPNAME=astronvim nvim"
set -gx VISUAL "env NVIM_APPNAME=astronvim nvim"

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
