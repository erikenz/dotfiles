## Useful aliases
# Configs
alias nvimconf="cd ~/.config/nvim && nvim ."
alias ghosttyconf="cd ~/.config/ghostty && nvim ."
alias shellconf="cd ~/.config/quickshell && nvim ."
alias hyprconf="cd ~/.config/hypr && nvim ."
alias fishconf="cd ~/.config/fish && nvim ."
alias starshipconf="nvim ~/.config/starship.toml"
alias vault="cd ~/obsidian-vault/ && nvim ."
alias p="pnpm"
alias zed="zeditor"

alias pamcan pacman
alias ls 'eza --icons'
alias clear "printf '\033[2J\033[3J\033[1;1H'"

# Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles

# Common use
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short' # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl" # Sort installed packages according to size in MB
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
# alias update='sudo cachyos-rate-mirrors && sudo pacman -Syu'
# alias update='sudo pacman -Syu'
alias update='paru'
alias mirror="sudo cachyos-rate-mirrors"
# alias mirrorupdate='sudo cachyos-rate-mirrors && sudo pacman -Syu'
alias mirrorupdate='mirror && paru'

# Get fastest mirrors

# Help people new to Arch
alias apt='man pacman'
alias apt-get='man pacman'
alias tb='nc termbin.com 9999'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
