#!/usr/bin/env bash
# Interactive fuzzy session switcher for tmux with quick creation support

set -euo pipefail

# Check if inside tmux
if [ -z "${TMUX:-}" ]; then
  echo "Error: Must be run inside a tmux session" >&2
  exit 1
fi

# Get list of current sessions formatted as: <name> (<windows> windows, <attached/detached>)
current_session="$(tmux display-message -p '#S')"

selected=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | \
  grep -v "^${current_session}$" || true)

# If only 1 session exists, list it too
if [ -z "$selected" ]; then
  selected="$current_session"
fi

choice=$(echo "$selected" | fzf \
  --reverse \
  --prompt="Switch session > " \
  --header="Enter: switch/create | Esc: cancel" \
  --print-query \
  --preview="tmux list-windows -t {1} -F ' #I: #W #{?window_active,(active),}' 2>/dev/null" \
  --preview-window=right:50%:wrap \
  --height=100%)

query=$(echo "$choice" | head -n 1)
target=$(echo "$choice" | tail -n 1)

# If target is empty, use the typed query
if [ -z "$target" ]; then
  target="$query"
fi

if [ -n "$target" ]; then
  if ! tmux has-session -t "$target" 2>/dev/null; then
    tmux new-session -d -s "$target" -c "$HOME"
  fi
  tmux switch-client -t "$target"
fi
