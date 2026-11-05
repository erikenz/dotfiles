function herdr --description "Wrapper for herdr to prevent stealing TUI focus on split/create"
    set -l real_herdr /usr/bin/herdr
    if not test -x "$real_herdr"
        set real_herdr (command -v herdr)
    end

    # Check if user or agent passed an explicit focus flag
    set -l has_focus_flag 0
    if contains -- --focus $argv; or contains -- --no-focus $argv
        set has_focus_flag 1
    end

    set -l should_inject 0
    if test $has_focus_flag -eq 0
        # Parse arguments, skipping optional --session <name> or --session=<name>
        set -l remaining_args
        set -l idx 1
        set -l total (count $argv)

        while test $idx -le $total
            set -l item $argv[$idx]
            if string match -q -- "--session" -- "$item"
                set idx (math $idx + 2)
            else if string match -q -- "--session=*" -- "$item"
                set idx (math $idx + 1)
            else
                set remaining_args $argv[$idx..$total]
                break
            end
        end

        if test (count $remaining_args) -ge 2
            set -l sub1 $remaining_args[1]
            set -l sub2 $remaining_args[2]

            if string match -q -- "pane" -- "$sub1"; and string match -q -- "split" -- "$sub2"
                set should_inject 1
            else if string match -q -- "workspace" -- "$sub1"; and string match -q -- "create" -- "$sub2"
                set should_inject 1
            end
        end
    end

    if test $should_inject -eq 1
        command $real_herdr $argv --no-focus
    else
        command $real_herdr $argv
    end
end
