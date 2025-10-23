# mise
if type -q mise
    mise activate fish | source
end

# starship
if type -q starship
    starship init fish | source
end

# zoxide
if type -q zoxide
    zoxide init fish | source
end

# fzf
if type -q fzf
    # These are optional: completions and key bindings
    if test -f /usr/share/fzf/shell/key-bindings.fish
        source /usr/share/fzf/shell/key-bindings.fish
    end
    if test -f /usr/share/fzf/shell/completion.fish
        source /usr/share/fzf/shell/completion.fish
    end
end
