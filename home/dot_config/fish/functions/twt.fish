function twt --description "Quickly toggle/switch between main project root and T3 Code worktrees"
    set -l show_all 0
    set -l force_switch 0

    # Parse flags
    for arg in $argv
        switch $arg
            case -a --all
                set show_all 1
            case -s --switch -l --list
                set force_switch 1
            case -h --help
                echo "Usage: twt [-s|--switch] [-a|--all]"
                echo "  twt             Toggle between current T3 worktree and main project root"
                echo "  twt -s, --switch  Switch to another T3 worktree even if currently in one"
                echo "  twt -a, --all     Show T3 worktrees across all projects"
                return 0
        end
    end

    set -l top (git rev-parse --show-toplevel 2>/dev/null)

    # If currently inside a .t3 worktree and not forcing switch, jump back to main project root
    if test $force_switch -eq 0 -a $show_all -eq 0 -a -n "$top"
        if string match -q "*/.t3/worktrees/*" "$top"
            set -l main_root (git worktree list --porcelain 2>/dev/null | head -n 1 | string replace "worktree " "")
            if test -z "$main_root"
                # Fallback via git-common-dir
                set -l common_git (git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
                set main_root (dirname "$common_git")
            end

            if test -d "$main_root"
                cd "$main_root"
                echo "↩️  Switched back to main project: $main_root"
                return 0
            end
        end
    end

    set -l valid_wts

    # If --all specified or not inside a git repo, gather worktrees across all projects
    if test $show_all -eq 1 -o -z "$top"
        set -l all_candidates (find "$HOME/.t3/worktrees" -mindepth 2 -maxdepth 2 -type d 2>/dev/null)
        for w in $all_candidates
            if test -d "$w"
                set -a valid_wts "$w"
            end
        end

        if test (count $valid_wts) -eq 0
            if test -z "$top"
                echo "❌ Not inside a git repository and no T3 worktrees found."
            else
                echo "ℹ️  No T3 worktrees found in ~/.t3/worktrees."
            end
            return 1
        end
    else
        # In git repo: collect registered worktrees for this repo
        set -l repo_wts (git -C "$top" worktree list --porcelain 2>/dev/null | string match -r "^worktree (.*/\.t3/worktrees/.*)" | string replace -r "^worktree " "" | sort -u)
        for w in $repo_wts
            if test -d "$w"
                set -a valid_wts "$w"
            end
        end

        # Fallback: check ~/.t3/worktrees/(basename $top) if git worktree list didn't catch any
        if test (count $valid_wts) -eq 0
            set -l proj_name (basename "$top")
            set -l fallback_candidates (find "$HOME/.t3/worktrees/$proj_name" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
            for w in $fallback_candidates
                if test -d "$w"
                    set -a valid_wts "$w"
                end
            end
        end

        if test (count $valid_wts) -eq 0
            echo "ℹ️  No active T3 worktrees found for this project."
            return 1
        end
    end

    set -l count (count $valid_wts)

    if test $count -eq 1
        cd "$valid_wts[1]"
        set -l id (basename "$valid_wts[1]")
        set -l tname (t3_thread_name "$valid_wts[1]")
        echo " Switched to T3 worktree: $tname [$id]"
        return 0
    else
        # Multiple worktrees: resolve thread and branch names for display
        if command -q fzf
            set -l chosen (for w in $valid_wts
                set -l id (basename "$w")
                set -l tname (t3_thread_name "$w")
                set -l branch (git -C "$w" branch --show-current 2>/dev/null)
                set -l proj (basename (dirname "$w"))

                set -l prefix ""
                if test $show_all -eq 1 -o -z "$top"
                    set prefix "[$proj] "
                end

                if test -n "$branch"
                    echo "$prefix$tname [$id] ($branch) -> $w"
                else
                    echo "$prefix$tname [$id] -> $w"
                end
            end | fzf --prompt=" Select T3 Worktree ❯ " --height=~40% --layout=reverse --border)

            if test -n "$chosen"
                set -l target (string replace -r '.*-> ' '' "$chosen")
                cd "$target"
                set -l id (basename "$target")
                set -l tname (t3_thread_name "$target")
                echo " Switched to T3 worktree: $tname [$id]"
            end
        else
            echo "Multiple T3 worktrees found:"
            for i in (seq $count)
                set -l id (basename "$valid_wts[$i]")
                set -l tname (t3_thread_name "$valid_wts[$i]")
                set -l branch (git -C "$valid_wts[$i]" branch --show-current 2>/dev/null)
                set -l proj (basename (dirname "$valid_wts[$i]"))

                set -l prefix ""
                if test $show_all -eq 1 -o -z "$top"
                    set prefix "[$proj] "
                end

                if test -n "$branch"
                    echo "[$i] $prefix$tname [$id] ($branch) ($valid_wts[$i])"
                else
                    echo "[$i] $prefix$tname [$id] ($valid_wts[$i])"
                end
            end
            read -P "Select number: " choice
            if test -n "$choice" -a "$choice" -ge 1 -a "$choice" -le $count
                cd "$valid_wts[$choice]"
                set -l id (basename "$valid_wts[$choice]")
                set -l tname (t3_thread_name "$valid_wts[$choice]")
                echo " Switched to T3 worktree: $tname [$id]"
            end
        end
    end
end
