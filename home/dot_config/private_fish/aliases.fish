# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"

# Use a function instead of alias cd="zd"
function zd
    if test (count $argv) -eq 0
        builtin cd ~
        return
    else if test -d $argv[1]
        builtin cd $argv[1]
    else
        z $argv
        and printf "\U000F17A9 "
        and pwd
        or echo "Error: Directory not found"
    end
end
alias cd='zd'

function open
    xdg-open $argv >/dev/null 2>&1 &
end

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# --- Tools ---
alias d='docker'
alias r='rails'

function n
    if test (count $argv) -eq 0
        nvim .
    else
        nvim $argv
    end
end

# Git
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
