#!/usr/bin/env bash
set -eu

# Target the private_settings.json in the source directory
# Use CHEZMOI_SOURCE_DIR if set, otherwise try to determine it
SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-$HOME/.local/share/chezmoi}"
ZED_FILE="$SOURCE_DIR/home/dot_config/zed/private_settings.json"

if [ ! -f "$ZED_FILE" ]; then
    echo "Warning: Zed settings file not found at $ZED_FILE"
    exit 0
fi

# Use perl to replace env objects with empty objects, preserving comments and formatting
# Matches "env": { ... } and replaces with "env": {}
# -0777 reads the whole file at once (slurp mode)
perl -i -0777 -pe 's/"env"\s*:\s*\{[^}]*\}/"env": {}/g' "$ZED_FILE"

echo "Sanitized secrets from $ZED_FILE"
