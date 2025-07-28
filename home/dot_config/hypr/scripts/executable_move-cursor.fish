#!/usr/bin/env fish

function move-cursor
    if test (count $argv) -ne 2
        echo "Usage: ./move-cursor.fish <dx> <dy>"
        return 1
    end

    set dx $argv[1]
    set dy $argv[2]

    # Get current cursor position (e.g. "123, 456")
    set pos (hyprctl cursorpos)

    # Extract x and y by splitting on comma and trimming spaces
    set cur_x (echo $pos | string split ',' | head -n1 | string trim)
    set cur_y (echo $pos | string split ',' | tail -n1 | string trim)

    # Calculate new position
    set new_x (math "$cur_x + $dx")
    set new_y (math "$cur_y + $dy")

    # Move the cursor
    hyprctl dispatch movecursor $new_x $new_y
end

move-cursor $argv
