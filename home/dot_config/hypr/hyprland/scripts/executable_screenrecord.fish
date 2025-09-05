#!/usr/bin/env fish

# Load user directories if available
if test -f ~/.config/user-dirs.dirs
    source ~/.config/user-dirs.dirs
end

set OUTPUT_DIR $OMARCHY_SCREENRECORD_DIR
if test -z "$OUTPUT_DIR"
    set OUTPUT_DIR $XDG_VIDEOS_DIR
end
if test -z "$OUTPUT_DIR"
    set OUTPUT_DIR "$HOME/Videos"
end

if not test -d "$OUTPUT_DIR"
    notify-send "Screen recording directory does not exist: $OUTPUT_DIR" -u critical -t 3000
    exit 1
end

function screenrecording
    set filename "$OUTPUT_DIR/screenrecording-(date +'%Y-%m-%d_%H-%M-%S').mp4"
    notify-send "Screen recording starting..." -t 1000
    sleep 1

    if lspci | grep -Eqi 'nvidia|intel.*graphics'
        wf-recorder -f "$filename" -c libx264 -p crf=23 -p preset=medium -p movflags=+faststart $argv
    else
        wl-screenrec -f "$filename" --ffmpeg-encoder-options="-c:v libx264 -crf 23 -preset medium -movflags +faststart" $argv
    end
end

if pgrep -x wl-screenrec > /dev/null; or pgrep -x wf-recorder > /dev/null
    pkill -x wl-screenrec
    pkill -x wf-recorder
    notify-send "Screen recording saved to $OUTPUT_DIR" -t 2000
else if test (count $argv) -ge 1; and test "$argv[1]" = "output"
    screenrecording
else
    set region (slurp)
    if test -z "$region"
        exit 1
    end
    screenrecording -g "$region"
end
