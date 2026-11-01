#!/usr/bin/env bash
# ==============================================================================
#  TMUX DELAYED WHICH-KEY AUTO-POPUP (Neovim-style delay trigger)
# ==============================================================================
# Triggers the Which-Key popup automatically after a brief delay if the user
# has pressed the prefix key (Ctrl-Space) and hasn't pressed any subsequent key.
# ==============================================================================

set -euo pipefail

client="${1:-}"
clean_client="$(echo "$client" | tr -cd '[:alnum:]_')"
[ -z "$clean_client" ] && clean_client="default"

token="$(date +%s%N)"
tmux set-option -q "@wk_token_${clean_client}" "$token"

# Delay before auto-opening (in seconds, 0.35s = 350ms)
sleep 0.35

# Ensure this is still the latest token (avoid race conditions on rapid taps)
current_token=$(tmux show-option -qv "@wk_token_${clean_client}" 2>/dev/null || echo "")
if [ "$token" != "$current_token" ]; then
    exit 0
fi

# Check if client is still in the prefix key table
if [ -n "$client" ]; then
    current_table=$(tmux display-message -p -t "$client" "#{client_key_table}" 2>/dev/null || echo "root")
else
    current_table=$(tmux display-message -p "#{client_key_table}" 2>/dev/null || echo "root")
fi

if [ "$current_table" = "prefix" ]; then
    # Hesitation detected: automatically open Which-Key!
    bash "$HOME/.config/tmux/scripts/which-key.sh"
fi
