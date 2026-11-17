function wt --description "Unified switcher for T3 Code and Delta worktrees"
    set -l filter_mode "all"  # "all", "t3", or "delta"
    set -l show_all_projects 0
    set -l force_switch 0
    set -l active_only 0
    set -l tab (printf "\t")

    # ANSI color codes
    set -l c_reset (printf "\033[0m")
    set -l c_bold (printf "\033[1m")
    set -l c_dim (printf "\033[2m")
    set -l c_red (printf "\033[1;31m")
    set -l c_green (printf "\033[32m")
    set -l c_yellow (printf "\033[33m")
    set -l c_blue (printf "\033[1;34m")
    set -l c_magenta (printf "\033[1;35m")
    set -l c_cyan (printf "\033[1;36m")
    set -l c_dim_gray (printf "\033[2;37m")

    # Resolve repo root and worktree state
    set -l top (git rev-parse --show-toplevel 2>/dev/null)
    set -l repo_root "$top"
    set -l is_worktree 0

    if test -n "$top"
        set -l git_first (git worktree list --porcelain 2>/dev/null | head -n 1 | string replace "worktree " "")
        if test -n "$git_first" -a -d "$git_first"
            set repo_root "$git_first"
        else if string match -q "*/.delta/worktrees/*" "$top"
            set repo_root (string replace -r '/\.delta/.*' '' "$top")
        else if string match -q "*/.t3/worktrees/*" "$top"
            set -l common_git (git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
            if test -n "$common_git"
                set repo_root (dirname "$common_git")
            end
        end

        if test "$top" != "$repo_root"
            set is_worktree 1
        end
    else
        # Fallback when current working directory was deleted/unlinked
        if string match -q "*/.t3/worktrees/*/*" "$PWD"
            set -l proj (string split "/" -- "$PWD")[-2]
            if test -d "$HOME/Projects/$proj"
                set repo_root "$HOME/Projects/$proj"
                set is_worktree 1
                echo "$c_yellow⚠️ Current worktree directory does not exist on disk! Detected project: $repo_root$c_reset"
            end
        else if string match -q "*/.delta/worktrees/*/*" "$PWD"
            set -l proj (string split "/" -- "$PWD")[-1]
            if test -d "$HOME/Projects/$proj"
                set repo_root "$HOME/Projects/$proj"
                set is_worktree 1
                echo "$c_yellow⚠️ Current worktree directory does not exist on disk! Detected project: $repo_root$c_reset"
            end
        end
    end

    # Parse arguments
    for arg in $argv
        switch $arg
            case main -m --main
                if test -n "$repo_root" -a -d "$repo_root"
                    cd "$repo_root"
                    echo "🏠 Switched to main project root: $repo_root"
                    return 0
                else
                    echo "❌ Not inside a git repository."
                    return 1
                end
            case -A --active
                set active_only 1
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
            case --clean-deleted
                if test -z "$repo_root" -o ! -d "$repo_root"
                    echo "❌ Not inside a git repository."
                    return 1
                end
                echo "🔍 Scanning worktrees for deleted T3 Code threads in "(basename "$repo_root")"..."
                set -l raw_wts (git -C "$repo_root" worktree list --porcelain 2>/dev/null | string match -r "^worktree (.*/\.t3/worktrees/.*)" | string replace -r "^worktree " "" | sort -u)
                set -l count_cleaned 0
                for w in $raw_wts
                    set -l t_stat (t3_thread_name --status "$w" 2>/dev/null)
                    if test "$t_stat" = "deleted"
                        set -l t_title (t3_thread_name "$w" 2>/dev/null)
                        set -l w_id (basename "$w")
                        set -l st (git -C "$w" status --short 2>/dev/null)
                        if test -n "$st"
                            echo "⚠️  Skipping $w_id ('$t_title'): has uncommitted changes!"
                        else
                            read -l -P "Remove clean worktree for deleted thread '$t_title' ($w_id)? [y/N] " ans
                            if string match -qi "y*" "$ans"
                                git -C "$repo_root" worktree remove "$w" 2>/dev/null
                                or rm -rf "$w"
                                echo "   🗑️ Removed $w_id"
                                set count_cleaned (math $count_cleaned + 1)
                            end
                        end
                    end
                end
                git -C "$repo_root" worktree prune -v
                echo "✨ Cleaned $count_cleaned worktree(s)."
                return 0
            case -h --help
                echo "Usage: wt [options]"
                echo "Quickly switch between main project root and T3 Code / Delta worktrees."
                echo ""
                echo "Options:"
                echo "  wt                Open interactive worktree picker (includes main project root)"
                echo "  wt main, -m       Switch directly to the main project root"
                echo "  wt -A, --active   Filter out worktrees whose T3 threads were deleted"
                echo "  wt -t, --t3       Filter to only T3 Code worktrees"
                echo "  wt -d, --delta    Filter to only Delta worktrees"
                echo "  wt -a, --all      Show worktrees across all projects on this machine"
                echo "  wt --clean-deleted Safely prune worktrees from deleted T3 Code threads"
                echo "  wt -p, --prune    Prune stale/deleted worktrees for this repository"
                echo "  wt -h, --help     Show this help message"
                return 0
        end
    end

    # 1. Gather worktrees for both groups
    set -l t3_wts
    set -l delta_wts

    if test $show_all_projects -eq 1 -o -z "$repo_root"
        # Across all projects
        if test "$filter_mode" != "delta"
            set -l all_t3 (find "$HOME/.t3/worktrees" -mindepth 2 -maxdepth 2 -type d 2>/dev/null)
            for w in $all_t3
                if test -d "$w"
                    if test $active_only -eq 1
                        set -l t_stat (t3_thread_name --status "$w" 2>/dev/null)
                        test "$t_stat" = "deleted"; and continue
                    end
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
                    if test $active_only -eq 1
                        set -l t_stat (t3_thread_name --status "$w" 2>/dev/null)
                        test "$t_stat" = "deleted"; and continue
                    end
                    set -a t3_wts "$w"
                end
            end

            # Fallback to ~/.t3/worktrees/<proj_name>
            if test (count $t3_wts) -eq 0 -a -d "$HOME/.t3/worktrees/$proj_name"
                for w in (find "$HOME/.t3/worktrees/$proj_name" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
                    if test -d "$w" -a ! (contains "$w" $t3_wts)
                        if test $active_only -eq 1
                            set -l t_stat (t3_thread_name --status "$w" 2>/dev/null)
                            test "$t_stat" = "deleted"; and continue
                        end
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

    if test $total_count -eq 0 -a $is_worktree -eq 0
        if test -z "$repo_root"
            echo "❌ Not inside a git repository and no T3 or Delta worktrees found."
        else
            echo "ℹ️  No active T3 or Delta worktrees found for this project."
        end
        return 1
    end

    # If only 1 worktree in total and not in switch mode and NOT inside a worktree, switch immediately
    if test $total_count -eq 1 -a $force_switch -eq 0 -a $is_worktree -eq 0
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

    # 2. Gather timestamps for recency sorting
    set -l raw_items
    for w in $t3_wts
        set -l ts (git -C "$w" log -1 --format=%ct 2>/dev/null)
        test -z "$ts"; and set ts 0
        set -l dir_ts (stat -c %Y "$w" 2>/dev/null)
        if test -n "$dir_ts" -a "$dir_ts" -gt "$ts"
            set ts "$dir_ts"
        end
        set -a raw_items "$ts$tab""t3$tab$w"
    end

    for w in $delta_wts
        set -l ts (git -C "$w" log -1 --format=%ct 2>/dev/null)
        test -z "$ts"; and set ts 0
        set -l dir_ts (stat -c %Y "$w" 2>/dev/null)
        if test -n "$dir_ts" -a "$dir_ts" -gt "$ts"
            set ts "$dir_ts"
        end
        set -a raw_items "$ts$tab""delta$tab$w"
    end

    # Sort descending by timestamp (most recently active first)
    set -l sorted
    if test (count $raw_items) -gt 0
        set sorted (printf "%s\n" $raw_items | sort -r -n -k1,1)
    end

    # 3. Build interactive selection entries
    set -l display_entries
    set -l raw_targets

    for line in $sorted
        set -l parts (string split "$tab" -- $line)
        set -l kind $parts[2]
        set -l w $parts[3]

        set -l branch (git -C "$w" branch --show-current 2>/dev/null)
        set -l cr (git -C "$w" log -1 --format=%cr 2>/dev/null)
        set -l time_str ""
        test -n "$cr"; and set time_str " • $cr"

        # Dirty status indicator
        set -l dirty_str ""
        set -l dirty_sample (git -C "$w" status --porcelain 2>/dev/null | head -n 1)
        if test -n "$dirty_sample"
            set dirty_str " "$c_red"*"$c_reset
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
            set -l c_parts (string split (printf "\t") -- "$counts")
            set -l behind $c_parts[1]
            set -l ahead $c_parts[2]
            set -l ab_inner ""
            test "$ahead" -gt 0 2>/dev/null; and set ab_inner "↑$ahead"
            if test "$behind" -gt 0 2>/dev/null
                test -n "$ab_inner"; and set ab_inner "$ab_inner "
                set ab_inner "$ab_inner↓$behind"
            end
            test -n "$ab_inner"; and set ab_str " "$c_green"$ab_inner"$c_reset
        end

        set -l branch_str ""
        test -n "$branch"; and set branch_str " "$c_yellow"($branch)"$c_reset

        set -l current_str ""
        if test -n "$top" -a "$w" = "$top"
            set current_str " "$c_cyan"(current)"$c_reset
        else if test -n "$PWD" -a "$w" = "$PWD"
            set current_str " "$c_cyan"(current)"$c_reset
        end

        set -l entry
        if test "$kind" = "t3"
            set -l id (basename "$w")
            set -l details (t3_thread_name --details "$w" 2>/dev/null)
            set -l d_parts (string split "$tab" -- "$details")
            set -l tname "$d_parts[1]"
            test -z "$tname"; and set tname (basename "$w")
            set -l t_stat "$d_parts[2]"

            set -l status_tag ""
            if test "$t_stat" = "deleted"
                set status_tag " "$c_red"[deleted]"$c_reset
            else if test "$t_stat" = "archived"
                set status_tag " "$c_yellow"[archived]"$c_reset
            end

            set -l proj (basename (dirname "$w"))
            set -l proj_prefix ""
            if test $show_all_projects -eq 1 -o -z "$repo_root"
                set proj_prefix " "$c_dim"[$proj]"$c_reset
            end
            set entry (printf "%s[T3 Code]%s%s %s%s%s%s%s%s%s%s %s[%s]%s%s%s%s\t%s" \
                "$c_cyan" "$c_reset" \
                "$proj_prefix" \
                "$c_bold" "$tname" "$c_reset" \
                "$status_tag" \
                "$branch_str" "$current_str" "$ab_str" "$dirty_str" \
                "$c_dim" "$id" "$c_reset" \
                "$c_dim_gray" "$time_str" "$c_reset" \
                "$w")
        else
            set -l sess (basename (dirname "$w"))
            set -l tname (delta_thread_name "$sess" 2>/dev/null)
            test -z "$tname"; and set tname "$sess"
            set -l proj (basename "$w")
            set -l proj_prefix ""
            if test $show_all_projects -eq 1 -o -z "$repo_root"
                set proj_prefix " "$c_dim"[$proj]"$c_reset
            end
            set entry (printf "%s[Delta]%s  %s %s%s%s%s%s%s%s %s[%s]%s%s%s%s\t%s" \
                "$c_magenta" "$c_reset" \
                "$proj_prefix" \
                "$c_bold" "$tname" "$c_reset" \
                "$branch_str" "$current_str" "$ab_str" "$dirty_str" \
                "$c_dim" "$sess" "$c_reset" \
                "$c_dim_gray" "$time_str" "$c_reset" \
                "$w")
        end

        set -a display_entries "$entry"
        set -a raw_targets "$w"
    end

    # ALWAYS include [Main] project root entry at the top when scoped to a repository
    if test $show_all_projects -eq 0 -a -n "$repo_root" -a -d "$repo_root"
        set -l main_branch (git -C "$repo_root" branch --show-current 2>/dev/null)
        test -z "$main_branch"; and set main_branch "main"
        set -l main_cr (git -C "$repo_root" log -1 --format=%cr 2>/dev/null)
        set -l main_time ""
        test -n "$main_cr"; and set main_time " • $main_cr"

        set -l main_dirty ""
        set -l main_dirty_sample (git -C "$repo_root" status --porcelain 2>/dev/null | head -n 1)
        test -n "$main_dirty_sample"; and set main_dirty " "$c_red"*"$c_reset

        set -l main_current ""
        if test "$top" = "$repo_root" -o "$PWD" = "$repo_root"
            set main_current " "$c_cyan"(current)"$c_reset
        end

        set -l main_branch_str ""
        test -n "$main_branch"; and set main_branch_str " "$c_yellow"($main_branch)"$c_reset

        set -l main_proj (basename "$repo_root")
        set -l main_entry (printf "%s[Main]%s    %sMain project root (%s)%s%s%s%s %s[root]%s%s%s%s\t%s" \
            "$c_green" "$c_reset" \
            "$c_bold" "$main_proj" "$c_reset" \
            "$main_branch_str" "$main_current" "$main_dirty" \
            "$c_dim" "$c_reset" \
            "$c_dim_gray" "$main_time" "$c_reset" \
            "$repo_root")

        set display_entries "$main_entry" $display_entries
        set raw_targets "$repo_root" $raw_targets
    end

    if command -q fzf
        set -l header_str "[Main] (green) | [T3 Code] (cyan) | [Delta] (purple)  •  ctrl-d: diff  •  ctrl-/: toggle preview"
        if test -n "$repo_root"
            set header_str "Project: "(basename "$repo_root")"  •  [Main] / [T3 Code] / [Delta]  •  ctrl-d: diff  •  ctrl-/: toggle preview"
        end

        set -l chosen (printf "%s\n" $display_entries | fzf --ansi \
            --delimiter=\t \
            --with-nth=1 \
            --prompt=" Select Worktree ❯ " \
            --header="$header_str" \
            --height=~65% \
            --layout=reverse \
            --border \
            --preview="_wt_preview {2} '$repo_root'" \
            --preview-window="right:50%:wrap" \
            --bind="ctrl-d:execute(git -C {2} diff --color=always | less -R),ctrl-/:toggle-preview")

        if test -n "$chosen"
            set -l target (echo "$chosen" | string split "$tab")[-1]
            if test -d "$target"
                cd "$target"
                if test -n "$repo_root" -a "$target" = "$repo_root"
                    echo "↩️  Switched to main project root: $repo_root"
                else if string match -q "*/.delta/*" "$target"
                    set -l sess (basename (dirname "$target"))
                    set -l tname (delta_thread_name "$sess" 2>/dev/null)
                    test -z "$tname"; and set tname "$sess"
                    echo " Switched to Delta worktree: $tname [$sess]"
                else
                    set -l id (basename "$target")
                    set -l tname (t3_thread_name "$target" 2>/dev/null)
                    test -z "$tname"; and set tname "$id"
                    echo " Switched to T3 worktree: $tname [$id]"
                end
            else
                echo "❌ Target directory does not exist on disk: $target"
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
            if test -d "$target"
                cd "$target"
                if test -n "$repo_root" -a "$target" = "$repo_root"
                    echo "↩️  Switched to main project root: $repo_root"
                else if string match -q "*/.delta/*" "$target"
                    set -l sess (basename (dirname "$target"))
                    set -l tname (delta_thread_name "$sess" 2>/dev/null)
                    test -z "$tname"; and set tname "$sess"
                    echo " Switched to Delta worktree: $tname [$sess]"
                else
                    set -l id (basename "$target")
                    set -l tname (t3_thread_name "$target" 2>/dev/null)
                    test -z "$tname"; and set tname "$id"
                    echo " Switched to T3 worktree: $tname [$id]"
                end
            end
        end
    end
end
