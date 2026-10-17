function dwt --description "Quickly toggle/switch between main project root and Delta worktrees"
    set -l top (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$top"
        echo "❌ Not inside a git repository."
        return 1
    end

    # If currently inside a .delta worktree, jump back to main project root
    if string match -q "*/.delta/worktrees/*" "$top"
        set -l main_root (string replace -r '/\.delta/.*' '' "$top")
        cd "$main_root"
        echo "↩️  Switched back to main project: $main_root"
        return 0
    end

    # Look for .delta/worktrees in current project
    set -l wt_dir "$top/.delta/worktrees"
    if not test -d "$wt_dir"
        echo "ℹ️  No .delta/worktrees directory found in this project."
        return 1
    end

    set -l wts (find "$wt_dir" -mindepth 2 -maxdepth 2 -type d 2>/dev/null)
    set -l count (count $wts)

    if test $count -eq 0
        echo "ℹ️  No active Delta worktrees found in $wt_dir."
        return 1
    else if test $count -eq 1
        cd "$wts[1]"
        set -l session (basename (dirname "$wts[1]"))
        set -l tname (delta_thread_name "$session")
        echo " Switched to Delta worktree: $tname [$session]"
        return 0
    else
        # Multiple worktrees: resolve thread names for clean display
        if command -q fzf
            set -l chosen (for w in $wts
                set -l sess (basename (dirname "$w"))
                set -l tname (delta_thread_name "$sess")
                echo "$tname [$sess] -> $w"
            end | fzf --prompt=" Select Delta Worktree ❯ " --height=~40% --layout=reverse --border)

            if test -n "$chosen"
                set -l target (string replace -r '.*-> ' '' "$chosen")
                cd "$target"
                set -l sess (basename (dirname "$target"))
                set -l tname (delta_thread_name "$sess")
                echo " Switched to Delta worktree: $tname [$sess]"
            end
        else
            echo "Multiple Delta worktrees found:"
            for i in (seq $count)
                set -l sess (basename (dirname "$wts[$i]"))
                set -l tname (delta_thread_name "$sess")
                echo "[$i] $tname [$sess] ($wts[$i])"
            end
            read -P "Select number: " choice
            if test -n "$choice" -a "$choice" -ge 1 -a "$choice" -le $count
                cd "$wts[$choice]"
            end
        end
    end
end
