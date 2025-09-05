#!/usr/bin/env fish

# Load user directories if available
if test -f ~/.config/user-dirs.dirs
    source ~/.config/user-dirs.dirs
end

set OUTPUT_DIR $OMARCHY_SCREENSHOT_DIR
if test -z "$OUTPUT_DIR"
    set OUTPUT_DIR $XDG_PICTURES_DIR
end
if test -z "$OUTPUT_DIR"
    set OUTPUT_DIR "$HOME/Pictures"
end

if not test -d "$OUTPUT_DIR"
    notify-send "Screenshot directory does not exist: $OUTPUT_DIR" -u critical -t 3000
    exit 1
end

# Take screenshot
pkill slurp ^/dev/null
or hyprshot -m (test -n "$argv[1]"; and echo $argv[1]; or echo region) -z --raw |
    satty --filename - \
        --output-filename "$OUTPUT_DIR/screenshot-(date +'%Y-%m-%d_%H-%M-%S').png" \
        --early-exit \
        --actions-on-enter save-to-clipboard \
        --save-after-copy \
        --copy-command 'wl-copy'
