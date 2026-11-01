#!/usr/bin/env bash
# ==============================================================================
#  TMUX WHICH-KEY (Inspired by which-key.nvim & alexwforsythe/tmux-which-key)
# ==============================================================================
# Displays a native modal popup menu with mnemonic keybindings, submenus, and
# instant execution without extra dependencies.
# ==============================================================================

set -euo pipefail

script_path="$HOME/.config/tmux/scripts/which-key.sh"
menu_name="${1:-Root}"

show_menu() {
    tmux menu -x C -y C -T "#[align=centre,bold] $menu_name " "$@"
}

reopen() {
    echo "run-shell 'bash \"$script_path\" \"$1\"'"
}

case "$menu_name" in
Root)
    show_menu \
        "󰒋 Session Dashboard (Alt-s)" s "run-shell 'bash ~/.config/tmux/scripts/session-switcher.sh'" \
        "󰒋 Sesh Picker (Alt-o)" o "display-popup -E -w 85% -h 75% 'sesh picker --icons --preview'" \
        "󰒋 Last Active Session (Tab)" Tab "switch-client -l" \
        "+󰒋 Sessions Menu" S "$(reopen Sessions)" \
        "" \
        "+󰖲 Windows Menu" w "$(reopen Windows)" \
        "+󰖲 Panes Menu" p "$(reopen Panes)" \
        "" \
        "󰊢 Lazygit Popup (g)" g "display-popup -d '#{pane_current_path}' -xC -yC -w 90% -h 90% -E 'lazygit'" \
        "󰞕 Scratch Terminal (t)" t "display-popup -d '#{pane_current_path}' -xC -yC -w 85% -h 80% -E '$SHELL'" \
        "󰆏 Vi Copy Mode ([)" [ "copy-mode" \
        "" \
        "󰑓 Reload Config (r)" r "source-file ~/.config/tmux/tmux.conf; display-message ' tmux.conf reloaded!'" \
        "󰘥 All Keybindings (?)" ? "list-keys"
    ;;

Windows)
    show_menu \
        "New Window (c)" c "new-window -c '#{pane_current_path}'" \
        "Rename Window (,)" , "command-prompt -I '#W' 'rename-window -- \"%%\"'" \
        "" \
        "Split Horizontal (-)" - "split-window -v -c '#{pane_current_path}'" \
        "Split Vertical (|)" | "split-window -h -c '#{pane_current_path}'" \
        "" \
        "Next Window (n)" n "next-window" \
        "Previous Window (p)" p "previous-window" \
        "Next Layout (Space)" Space "next-layout" \
        "" \
        "Close Window (X)" X "kill-window" \
        "<-- Back" b "$(reopen Root)"
    ;;

Panes)
    show_menu \
        "Select Left (h)" h "select-pane -L" \
        "Select Down (j)" j "select-pane -D" \
        "Select Up (k)" k "select-pane -U" \
        "Select Right (l)" l "select-pane -R" \
        "" \
        "Toggle Maximize (m / z)" m "resize-pane -Z" \
        "+Resize Submenu" r "$(reopen Resize)" \
        "" \
        "Swap Pane Down (>)" > "swap-pane -D" \
        "Swap Pane Up (<)" < "swap-pane -U" \
        "Show Pane Numbers (q)" q "display-panes" \
        "" \
        "Kill Pane (x)" x "kill-pane" \
        "<-- Back" b "$(reopen Root)"
    ;;

Resize)
    tmux_resize() {
        echo "resize-pane $1 5; run-shell 'bash \"$script_path\" Resize'"
    }

    show_menu \
        "Left 5 (h)" h "$(tmux_resize -L)" \
        "Down 5 (j)" j "$(tmux_resize -D)" \
        "Up 5 (k)" k "$(tmux_resize -U)" \
        "Right 5 (l)" l "$(tmux_resize -R)" \
        "" \
        "Toggle Maximize (m)" m "resize-pane -Z; run-shell 'bash \"$script_path\" Resize'" \
        "<-- Back to Panes" b "$(reopen Panes)"
    ;;

Sessions)
    show_menu \
        "Fuzzy Dashboard (Alt-s)" s "run-shell 'bash ~/.config/tmux/scripts/session-switcher.sh'" \
        "Interactive Tree (S)" S "choose-tree -Zs" \
        "Toggle Last Session (Tab)" Tab "switch-client -l" \
        "" \
        "Next Session ()" ')' "switch-client -n" \
        "Previous Session ()" '(' "switch-client -p" \
        "Rename Session ($)" '$' "command-prompt -I '#S' 'rename-session -- \"%%\"'" \
        "" \
        "Detach Client (d)" d "detach-client" \
        "<-- Back" b "$(reopen Root)"
    ;;
esac
