#!/usr/bin/env bash
# ==============================================================================
#  TMUX INTERACTIVE SESSION DASHBOARD & SWITCHER
# ==============================================================================
# Designed for managing AI agent dev servers, background processes, and interactive commands.
#
# Features:
# - Live ANSI color preview of the selected session's terminal output
# - Enter: Switch to session (or create new if typed query does not exist)
# - Ctrl-x: Kill session immediately & refresh list
# - Ctrl-c: Send SIGINT (Ctrl-C) to interrupt running command & refresh list
# - Ctrl-k: Send Ctrl-D / EOF to session
# ==============================================================================

set -euo pipefail

if [ -z "${TMUX:-}" ]; then
  echo "Error: Must be run inside tmux" >&2
  exit 1
fi

get_sessions() {
  tmux list-sessions -F "#{session_name}	#{pane_current_command}	#{session_windows} win#{?session_attached, (attached),}" 2>/dev/null || true
}

export -f get_sessions

choice=$(get_sessions | fzf \
  --delimiter='\t' \
  --with-nth=1,2,3 \
  --reverse \
  --prompt="Sessions > " \
  --header="Enter: Switch/Create | C-x: Kill Session | C-c: Send SIGINT | Esc: Cancel" \
  --preview="tmux capture-pane -ep -t {1} 2>/dev/null | tail -n 50" \
  --preview-window="right:65%:wrap" \
  --bind "ctrl-x:execute-silent(tmux kill-session -t {1})+reload(get_sessions)" \
  --bind "ctrl-c:execute-silent(tmux send-keys -t {1} C-c)+reload(sleep 0.1; get_sessions)" \
  --bind "ctrl-r:reload(get_sessions)" \
  --print-query \
  --height=100%) || true

query=$(echo "$choice" | head -n 1)
target_line=$(echo "$choice" | tail -n 1)
target=$(echo "$target_line" | awk -F'\t' '{print $1}')

# If target is empty, use typed query
if [ -z "$target" ]; then
  target="$query"
fi

# Clean up whitespace
target="$(echo "$target" | xargs)"

if [ -n "$target" ]; then
  if ! tmux has-session -t "$target" 2>/dev/null; then
    tmux new-session -d -s "$target" -c "$HOME"
  fi
  tmux switch-client -t "$target"
fi
