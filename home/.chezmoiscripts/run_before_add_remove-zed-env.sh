#!/usr/bin/env bash
set -euo pipefail

ZED_CFG="$HOME/.config/zed/settings.json"

[ -f "$ZED_CFG" ] || exit 0

tmp="$(mktemp)"

jq '
  if .context_servers then
    .context_servers |= with_entries(
      .value |= del(.env)
    )
  else
    .
  end
' "$ZED_CFG" >"$tmp"

# Overwrite only long enough for chezmoi add to read it
mv "$tmp" "$ZED_CFG"
