function wt --description "Unified switcher for T3 Code and Delta worktrees"
    set -l filter_mode "all"  # "all", "t3", or "delta"
    set -l show_all_projects 0
    set -l force_switch 0

    # Parse arguments
    for arg in $argv
        switch $arg
            case -t --t3
                set filter_mode "t3"
            case -d --delta
                set filter_mode "delta"
            case -a --all
                set show_all_projects 1
            case -s --switch -l --list
                set force_switch 1
            case -h --help
                echo "Usage: wt [options]"
                echo "Quickly toggle/switch between main project root and T3 Code / Delta worktrees."
                echo ""
                echo "Options:"
                echo "  wt                Toggle between current worktree and main project root"
                echo "  wt -s, --switch   Switch to another worktree even when currently inside one"
                echo "  wt -t, --t3       Filter to only T3 Code worktrees"
                echo "  wt -d, --delta    Filter to only Delta worktrees"
                echo "  wt -a, --all      Show worktrees across all projects on this machine"
                echo "  wt -h, --help     Show this help message"
                return 0
        end
    end

    set -l top (git rev-parse --show-toplevel 2>/dev/null)

    # 1. If currently inside a worktree and not forcing switch, jump back to main project root
    if test $force_switch -eq 0 -a $show_all_projects -eq 0 -a -n "$top"
        # Delta worktree check
        if string match -q "*/.delta/worktrees/*" "$top"
            set -l main_root (string replace -r '/\.delta/.*' '' "$top")
            if test -d "$main_root"
                cd "$main_root"
                echo "↩️  Switched back to main project: $main_root"
                return 0
            end
        end

        # T3 Code worktree check
        if string match -q "*/.t3/worktrees/*" "$top"
            set -l main_root (git worktree list --porcelain 2>/dev/null | head -n 1 | string replace "worktree " "")
            if test -z "$main_root"
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

    # 2. Gather worktrees for both groups
    set -l t3_wts
    set -l delta_wts

    if test $show_all_projects -eq 1 -o -z "$top"
        # Across all projects
        if test "$filter_mode" != "delta"
            set -l all_t3 (find "$HOME/.t3/worktrees" -mindepth 2 -maxdepth 2 -type d 2>/dev/null)
            for w in $all_t3
                if test -d "$w"
                    set -a t3_wts "$w"
                end
            end
        end

        if test "$filter_mode" != "t3"
            set -l all_delta (find "$HOME/Projects" -maxdepth 4 -path "*/.delta/worktrees/*/*" -type d 2>/dev/null)
            for w in $all_delta
                if test -d "$w"
                    set -a delta_wts "$w"
                end
            end
        end
    else
        # Scoped to current repository
        set -l proj_name (basename "$top")

        # Resolve main root if currently inside a worktree with -s/--switch
        set -l repo_root "$top"
        if string match -q "*/.delta/worktrees/*" "$top"
            set repo_root (string replace -r '/\.delta/.*' '' "$top")
        else if string match -q "*/.t3/worktrees/*" "$top"
            set -l git_first (git worktree list --porcelain 2>/dev/null | head -n 1 | string replace "worktree " "")
            if test -n "$git_first"
                set repo_root "$git_first"
            end
        end

        # T3 worktrees for this repo
        if test "$filter_mode" != "delta"
            set -l raw_t3 (git -C "$repo_root" worktree list --porcelain 2>/dev/null | string match -r "^worktree (.*/\.t3/worktrees/.*)" | string replace -r "^worktree " "" | sort -u)
            for w in $raw_t3
                if test -d "$w"
                    set -a t3_wts "$w"
                end
            end

            # Fallback to ~/.t3/worktrees/<proj_name>
            if test (count $t3_wts) -eq 0 -a -d "$HOME/.t3/worktrees/$proj_name"
                for w in (find "$HOME/.t3/worktrees/$proj_name" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
                    if test -d "$w" -a ! (contains "$w" $t3_wts)
                        set -a t3_wts "$w"
                    end
                end
            end
        end

        # Delta worktrees for this repo
        if test "$filter_mode" != "t3"
            set -l delta_dir "$repo_root/.delta/worktrees"
            if test -d "$delta_dir"
                set -l raw_delta (find "$delta_dir" -mindepth 2 -maxdepth 2 -type d 2>/dev/null)
                for w in $raw_delta
                    if test -d "$w"
                        set -a delta_wts "$w"
                    end
                end
            end
        end
    end

    set -l total_count (math (count $t3_wts) + (count $delta_wts))

    if test $total_count -eq 0
        if test -z "$top"
            echo "❌ Not inside a git repository and no T3 or Delta worktrees found."
        else
            echo "ℹ️  No active T3 or Delta worktrees found for this project."
        end
        return 1
    end

    # If only 1 worktree in total, switch immediately
    if test $total_count -eq 1
        set -l target
        set -l group_name
        set -l id
        set -l tname

        if test (count $t3_wts) -eq 1
            set target "$t3_wts[1]"
            set group_name "T3 Code"
            set id (basename "$target")
            set tname (t3_thread_name "$target")
        else
            set target "$delta_wts[1]"
            set group_name "Delta"
            set id (basename (dirname "$target"))
            set tname (delta_thread_name "$id")
        end

        cd "$target"
        echo " Switched to $group_name worktree: $tname [$id]"
        return 0
    end

    # Multiple worktrees: build interactive selection entries
    set -l display_entries
    set -l raw_targets

    # Group 1: T3 Code
    for w in $t3_wts
        set -l id (basename "$w")
        set -l tname (t3_thread_name "$w")
        set -l branch (git -C "$w" branch --show-current 2>/dev/null)
        set -l proj (basename (dirname "$w"))

        set -l proj_prefix ""
        if test $show_all_projects -eq 1 -o -z "$top"
            set proj_prefix "[$proj] "
        end

        set -l branch_info ""
        if test -n "$branch"
            set branch_info " \e[33m($branch)\e[0m"
        end

        set -l entry (printf "\e[1;36m[T3 Code]\e[0m %s\e[1m%s\e[0m \e[2m[%s]\e[0m%s \e[2m-> %s\e[0m" "$proj_prefix" "$tname" "$id" "$branch_info" "$w")
        set -a display_entries "$entry"
        set -a raw_targets "$w"
    end

    # Group 2: Delta
    for w in $delta_wts
        set -l sess (basename (dirname "$w"))
        set -l tname (delta_thread_name "$sess")
        set -l proj (basename "$w")

        set -l proj_prefix ""
        if test $show_all_projects -eq 1 -o -z "$top"
            set proj_prefix "[$proj] "
        end

        set -l entry (printf "\e[1;35m[Delta]\e[0m   %s\e[1m%s\e[0m \e[2m[%s]\e[0m \e[2m-> %s\e[0m" "$proj_prefix" "$tname" "$sess" "$w")
        set -a display_entries "$entry"
        set -a raw_targets "$w"
    end

    if command -q fzf
        set -l chosen (printf "%s\n" $display_entries | fzf --ansi \
            --prompt=" Select Worktree ❯ " \
            --header="Groups: [T3 Code] (cyan) | [Delta] (purple)  •  Type 't3' or 'delta' to filter" \
            --height=~50% \
            --layout=reverse \
            --border)

        if test -n "$chosen"
            set -l target (string replace -r '.*-> ' '' "$chosen" | string trim)
            if test -d "$target"
                cd "$target"
                if string match -q "*/.delta/*" "$target"
                    set -l sess (basename (dirname "$target"))
                    set -l tname (delta_thread_name "$sess")
                    echo " Switched to Delta worktree: $tname [$sess]"
                else
                    set -l id (basename "$target")
                    set -l tname (t3_thread_name "$target")
                    echo " Switched to T3 worktree: $tname [$id]"
                end
            end
        end
    else
        # Fallback numbered list grouped cleanly
        echo "Select worktree to switch to:"
        set -l idx 1

        if test (count $t3_wts) -gt 0
            echo ""
            echo "--- T3 Code Worktrees ---"
            for w in $t3_wts
                set -l id (basename "$w")
                set -l tname (t3_thread_name "$w")
                set -l branch (git -C "$w" branch --show-current 2>/dev/null)
                if test -n "$branch"
                    echo "[$idx] $tname [$id] ($branch)"
                else
                    echo "[$idx] $tname [$id]"
                end
                set idx (math $idx + 1)
            end
        end

        if test (count $delta_wts) -gt 0
            echo ""
            echo "--- Delta Worktrees ---"
            for w in $delta_wts
                set -l sess (basename (dirname "$w"))
                set -l tname (delta_thread_name "$sess")
                echo "[$idx] $tname [$sess]"
                set idx (math $idx + 1)
            end
        end

        echo ""
        read -P "Select number: " choice
        if test -n "$choice" -a "$choice" -ge 1 -a "$choice" -le (count $raw_targets)
            set -l target "$raw_targets[$choice]"
            cd "$target"
            if string match -q "*/.delta/*" "$target"
                set -l sess (basename (dirname "$target"))
                set -l tname (delta_thread_name "$sess")
                echo " Switched to Delta worktree: $tname [$sess]"
            else
                set -l id (basename "$target")
                set -l tname (t3_thread_name "$target")
                echo " Switched to T3 worktree: $tname [$id]"
            end
        end
    end
end
