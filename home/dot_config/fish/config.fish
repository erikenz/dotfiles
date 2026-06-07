source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Initialize Starship prompt
starship init fish | source

# Initialize mise tool manager
mise activate fish | source

function n
    if test (count $argv) -eq 0
        nvim .
    else
        nvim $argv
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

# dotfiles
alias conf-fish='cd ~/.config/fish && n'
alias conf-nvim='cd ~/.config/nvim && n'
alias conf-ghostty='cd ~/.config/ghostty && n'
alias conf-hypr='cd ~/.config/hypr && n'

alias portainer='docker run -p 8000:8000 -p 9443:9443 --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts'
