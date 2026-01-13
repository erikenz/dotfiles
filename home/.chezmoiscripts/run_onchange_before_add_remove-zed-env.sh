#!/usr/bin/env bash
set -euo pipefail

ZED_CFG="$HOME/.config/zed/settings.json"

# Only run if the file exists
[ -f "$ZED_CFG" ] || exit 0

tmp="$(mktemp)"

# Remove all `.context_servers.*.env` keys
jq '
  if .context_servers then
    .context_servers |= with_entries(
      .value |= del(.env)
    )
  else
    .
  end
' "$ZED_CFG" >"$tmp"

# Overwrite the file ONLY for chezmoi to read
mv "$tmp" "$ZED_CFG"
