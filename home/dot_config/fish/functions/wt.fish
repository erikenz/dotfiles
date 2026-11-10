function wt --description "Unified switcher for T3 Code and Delta worktrees"
    set -l filter_mode "all"  # "all", "t3", or "delta"
    set -l show_all_projects 0
    set -l force_switch 0
    set -l tab (printf "\t")

    set -l top (git rev-parse --show-toplevel 2>/dev/null)
    set -l repo_root "$top"
    if string match -q "*/.delta/worktrees/*" "$top"
        set repo_root (string replace -r '/\.delta/.*' '' "$top")
    else if string match -q "*/.t3/worktrees/*" "$top"
        set -l git_first (git worktree list --porcelain 2>/dev/null | head -n 1 | string replace "worktree " "")
        if test -n "$git_first"
            set repo_root "$git_first"
        else
            set -l common_git (git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
            if test -n "$common_git"
                set repo_root (dirname "$common_git")
            end
        end
    end

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
            case -p --prune
                echo "🧹 Pruning stale git worktree registrations..."
                if test -n "$repo_root" -a -d "$repo_root"
                    git -C "$repo_root" worktree prune -v
                else
                    echo "ℹ️  Run within a git project to prune worktrees."
                end
                return 0
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
                echo "  wt -p, --prune    Prune stale/deleted worktrees for this repository"
                echo "  wt -h, --help     Show this help message"
                return 0
        end
    end

    # 1. If currently inside a worktree and not forcing switch, jump back to main project root
    if test $force_switch -eq 0 -a $show_all_projects -eq 0 -a -n "$top"
        # Delta worktree check
        if string match -q "*/.delta/worktrees/*" "$top"
            if test -d "$repo_root"
                cd "$repo_root"
                echo "↩️  Switched back to main project: $repo_root"
                return 0
            end
        end

        # T3 Code worktree check
        if string match -q "*/.t3/worktrees/*" "$top"
            if test -d "$repo_root"
                cd "$repo_root"
                echo "↩️  Switched back to main project: $repo_root"
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
        set -l proj_name (basename "$repo_root")

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

    # If only 1 worktree in total and not in switch mode, switch immediately
    if test $total_count -eq 1 -a $force_switch -eq 0
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

    # 3. Gather timestamps for recency sorting
    set -l raw_items
    for w in $t3_wts
        set -l ts (git -C "$w" log -1 --format=%ct 2>/dev/null)
        test -z "$ts" && set ts 0
        set -l dir_ts (stat -c %Y "$w" 2>/dev/null)
        if test -n "$dir_ts" -a "$dir_ts" -gt "$ts"
            set ts "$dir_ts"
        end
        set -a raw_items "$ts$tab""t3$tab$w"
    end

    for w in $delta_wts
        set -l ts (git -C "$w" log -1 --format=%ct 2>/dev/null)
        test -z "$ts" && set ts 0
        set -l dir_ts (stat -c %Y "$w" 2>/dev/null)
        if test -n "$dir_ts" -a "$dir_ts" -gt "$ts"
            set ts "$dir_ts"
        end
        set -a raw_items "$ts$tab""delta$tab$w"
    end

    # Sort descending by timestamp (most recently active first)
    set -l sorted (printf "%s\n" $raw_items | sort -r -n -k1,1)

    # 4. Build interactive selection entries
    set -l display_entries
    set -l raw_targets

    for line in $sorted
        set -l parts (string split "$tab" -- $line)
        set -l kind $parts[2]
        set -l w $parts[3]

        set -l branch (git -C "$w" branch --show-current 2>/dev/null)
        set -l cr (git -C "$w" log -1 --format=%cr 2>/dev/null)
        set -l time_str ""
        test -n "$cr" && set time_str " • $cr"

        # Dirty status indicator
        set -l dirty_str ""
        if test -n (git -C "$w" status --porcelain 2>/dev/null | head -n 1)
            set dirty_str " \e[1;31m*\e[0m"
        end

        # Ahead / Behind counter against base branch
        set -l ab_str ""
        set -l base_branch "origin/main"
        if not git -C "$w" rev-parse --verify origin/main >/dev/null 2>&1
            for candidate in origin/master main master
                if git -C "$w" rev-parse --verify "$candidate" >/dev/null 2>&1
                    set base_branch "$candidate"
                    break
                end
            end
        end
        set -l counts (git -C "$w" rev-list --left-right --count "$base_branch...HEAD" 2>/dev/null)
        if test -n "$counts"
            set -l c_parts (string split "$tab" -- $counts)
            set -l behind $c_parts[1]
            set -l ahead $c_parts[2]
            set -l ab_inner ""
            test "$ahead" -gt 0 && set ab_inner "↑$ahead"
            if test "$behind" -gt 0
                test -n "$ab_inner" && set ab_inner "$ab_inner "
                set ab_inner "$ab_inner↓$behind"
            end
            test -n "$ab_inner" && set ab_str " \e[32m$ab_inner\e[0m"
        end

        set -l branch_str ""
        test -n "$branch" && set branch_str " \e[33m($branch)\e[0m"

        set -l entry
        if test "$kind" = "t3"
            set -l id (basename "$w")
            set -l tname (t3_thread_name "$w")
            set -l proj (basename (dirname "$w"))
            set -l proj_prefix ""
            if test $show_all_projects -eq 1 -o -z "$top"
                set proj_prefix " \e[2m[$proj]\e[0m"
            end
            set entry (printf "\e[1;36m[T3 Code]\e[0m%s \e[1m%s\e[0m%s%s%s \e[2m[%s]\e[0m\e[2;37m%s\e[0m\t%s" "$proj_prefix" "$tname" "$branch_str" "$ab_str" "$dirty_str" "$id" "$time_str" "$w")
        else
            set -l sess (basename (dirname "$w"))
            set -l tname (delta_thread_name "$sess")
            set -l proj (basename "$w")
            set -l proj_prefix ""
            if test $show_all_projects -eq 1 -o -z "$top"
                set proj_prefix " \e[2m[$proj]\e[0m"
            end
            set entry (printf "\e[1;35m[Delta]\e[0m%s   \e[1m%s\e[0m%s%s%s \e[2m[%s]\e[0m\e[2;37m%s\e[0m\t%s" "$proj_prefix" "$tname" "$branch_str" "$ab_str" "$dirty_str" "$sess" "$time_str" "$w")
        end

        set -a display_entries "$entry"
        set -a raw_targets "$w"
    end

    if command -q fzf
        set -l preview_script 'w="{2}"; printf "\033[1;34m📁 Worktree:\033[0m %s\n" "$w"; b="$(git -C "$w" branch --show-current 2>/dev/null)"; [ -n "$b" ] && printf "\033[1;33m🌿 Branch:\033[0m   %s\n" "$b"; echo ""; printf "\033[1;32m📋 Changes:\033[0m\n"; st="$(git -C "$w" status -s 2>/dev/null)"; if [ -n "$st" ]; then echo "$st"; else echo "  Clean working tree"; fi; echo ""; printf "\033[1;35m📜 Recent Commits:\033[0m\n"; git -C "$w" log -5 --oneline --decorate --color=always 2>/dev/null'

        set -l chosen (printf "%s\n" $display_entries | fzf --ansi \
            --delimiter=\t \
            --with-nth=1 \
            --prompt=" Select Worktree ❯ " \
            --header="[T3 Code] (cyan) | [Delta] (purple)  •  ctrl-d: diff  •  ctrl-/: toggle preview" \
            --height=~65% \
            --layout=reverse \
            --border \
            --preview="$preview_script" \
            --preview-window="right:50%:wrap" \
            --bind="ctrl-d:execute(git -C {2} diff --color=always | less -R),ctrl-/:toggle-preview")

        if test -n "$chosen"
            set -l target (echo "$chosen" | string split "$tab")[-1]
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
        # Fallback numbered list
        echo "Select worktree to switch to:"
        set -l idx 1
        for e in $display_entries
            set -l label (echo "$e" | string split "$tab")[1]
            echo "[$idx] $label"
            set idx (math $idx + 1)
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
