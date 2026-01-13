#!/usr/bin/env bash
set -eu

# Determine the repository root relative to this script
# Script is in <repo_root>/scripts/sanitize-zed-env.sh
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Target the private_settings.json file
ZED_FILE="$REPO_ROOT/home/dot_config/zed/private_settings.json"

if [ ! -f "$ZED_FILE" ]; then
    echo "Warning: Zed settings file not found at $ZED_FILE"
    # Do not exit with 0 if we expect the file to be there, or keep 0 if it's optional.
    # Given the user wants to strip secrets, if the file is missing something is wrong with the path logic.
    # But if the user deleted the file, we shouldn't fail the commit?
    # Let's verify the path by listing what we found if missing.
    echo "Current repo root determined as: $REPO_ROOT"
    exit 0
fi

# Use perl to replace env objects with empty objects
perl -i -0777 -pe 's/"env"\s*:\s*\{[^}]*\}/"env": {}/g' "$ZED_FILE"

echo "Sanitized secrets from $ZED_FILE"
