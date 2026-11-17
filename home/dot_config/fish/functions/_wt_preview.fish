function _wt_preview --description "Rich preview generator for wt worktree switcher"
    set -l target $argv[1]
    set -l repo_root $argv[2]

    # Guard against empty target
    if test -z "$target"
        echo "No worktree selected."
        return 0
    end

    # ANSI colors
    set -l c_reset (printf "\033[0m")
    set -l c_bold (printf "\033[1m")
    set -l c_dim (printf "\033[2m")
    set -l c_red (printf "\033[1;31m")
    set -l c_green (printf "\033[1;32m")
    set -l c_yellow (printf "\033[1;33m")
    set -l c_blue (printf "\033[1;34m")
    set -l c_magenta (printf "\033[1;35m")
    set -l c_cyan (printf "\033[1;36m")
    set -l c_dim_gray (printf "\033[2;37m")

    # If the target directory doesn't exist on disk
    if not test -d "$target"
        printf "%s❌ Directory does not exist on disk:%s\n" "$c_red" "$c_reset"
        echo "   $target"
        echo ""
        printf "%sℹ️  This worktree reference is stale or was deleted.%s\n" "$c_dim" "$c_reset"
        printf "%s   Run 'wt -p' to prune stale git references.%s\n" "$c_dim" "$c_reset"
        return 0
    end

    # Ensure CWD is clean to avoid inheriting broken/deleted parent CWD errors
    builtin cd "$target" 2>/dev/null; or builtin cd /tmp 2>/dev/null

    set -l is_root 0
    if test -n "$repo_root" -a "$target" = "$repo_root"
        set is_root 1
    end

    set -l display_path (string replace "$HOME" "~" "$target")

    # 1. Header Card & Worktree Identity
    if test $is_root -eq 1
        set -l proj_name (basename "$repo_root")
        printf "%s%s🏠 [Main] Project Root%s %s• %s%s\n" "$c_green" "$c_bold" "$c_reset" "$c_dim" "$proj_name" "$c_reset"
    else if string match -q "*/.t3/worktrees/*" "$target"
        set -l wt_id (basename "$target")
        set -l db "$HOME/.t3/userdata/statev2.sqlite"
        if not test -f "$db"
            set db "$HOME/.t3/userdata/state.sqlite"
        end

        set -l title "$wt_id"
        set -l status_badge ""

        if test -f "$db"
            set -l safe_target (string replace -a "'" "''" "$target")
            set -l safe_id (string replace -a "'" "''" "$wt_id")
            set -l query "SELECT title, COALESCE(deleted_at, ''), COALESCE(archived_at, '') FROM orchestration_v2_projection_threads WHERE json_extract(payload_json, '\$.worktreePath') = '$safe_target' OR json_extract(payload_json, '\$.worktreePath') LIKE '%/$safe_id' ORDER BY updated_at DESC LIMIT 1;"
            set -l tab (printf '\t')
            set -l raw (sqlite3 -batch -noheader -separator "$tab" "$db" "$query" 2>/dev/null)

            if test -z "$raw"
                set -l query_v1 "SELECT title, COALESCE(deleted_at, ''), '' FROM projection_threads WHERE worktree_path = '$safe_target' OR worktree_path LIKE '%/$safe_id' ORDER BY updated_at DESC LIMIT 1;"
                set raw (sqlite3 -batch -noheader -separator "$tab" "$db" "$query_v1" 2>/dev/null)
            end

            if test -n "$raw"
                set -l parts (string split "$tab" -- "$raw")
                test -n "$parts[1]"; and set title $parts[1]
                set -l del $parts[2]
                set -l arc $parts[3]

                if test -n "$del"
                    set -l del_date (string sub -l 10 "$del")
                    set status_badge (printf "%s⚠️  THREAD DELETED IN T3 CODE%s %s(deleted %s)%s" "$c_red" "$c_reset" "$c_dim" "$del_date" "$c_reset")
                else if test -n "$arc"
                    set -l arc_date (string sub -l 10 "$arc")
                    set status_badge (printf "%s📦 THREAD ARCHIVED%s %s(archived %s)%s" "$c_yellow" "$c_reset" "$c_dim" "$arc_date" "$c_reset")
                else
                    set status_badge (printf "%s🟢 ACTIVE THREAD%s" "$c_green" "$c_reset")
                end
            end
        end

        printf "%s%s[T3 Code]%s %s%s%s\n" "$c_cyan" "$c_bold" "$c_reset" "$c_bold" "$title" "$c_reset"
        printf "%sID: %s%s\n" "$c_dim" "$wt_id" "$c_reset"
        if test -n "$status_badge"
            echo "$status_badge"
        end
    else if string match -q "*/.delta/worktrees/*" "$target"
        set -l sess (basename (dirname "$target"))
        set -l tname (delta_thread_name "$sess" 2>/dev/null)
        test -z "$tname"; and set tname "$sess"
        printf "%s%s[Delta]%s %s%s%s\n" "$c_magenta" "$c_bold" "$c_reset" "$c_bold" "$tname" "$c_reset"
        printf "%sSession: %s%s\n" "$c_dim" "$sess" "$c_reset"
    else
        set -l wt_name (basename "$target")
        printf "%s%s[Worktree]%s %s\n" "$c_bold" "$wt_name" "$c_reset" "$wt_name"
    end

    # 2. Branch & Tracking Info
    set -l branch (git -C "$target" branch --show-current 2>/dev/null)
    set -l branch_display "$branch"
    if test -z "$branch"
        set -l short_sha (git -C "$target" rev-parse --short HEAD 2>/dev/null)
        set branch_display "(detached at $short_sha)"
    end

    # Upstream comparison
    set -l upstream (git -C "$target" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
    set -l ab_info ""
    if test -n "$upstream"
        set -l counts (git -C "$target" rev-list --left-right --count "$upstream...HEAD" 2>/dev/null)
        if test -n "$counts"
            set -l c_parts (string split (printf "\t") -- "$counts")
            set -l behind $c_parts[1]
            set -l ahead $c_parts[2]
            set -l ab_parts
            test "$ahead" -gt 0 2>/dev/null; and set -a ab_parts "↑$ahead"
            test "$behind" -gt 0 2>/dev/null; and set -a ab_parts "↓$behind"
            if test (count $ab_parts) -gt 0
                set -l ab_str (string join " " $ab_parts)
                set ab_info (printf " %s(%s%s%s%s vs %s)%s" "$c_dim" "$c_green" "$ab_str" "$c_reset" "$c_dim" "$upstream" "$c_reset")
            end
        end
    else
        # Fallback comparison vs origin/main or origin/master
        set -l base_branch "origin/main"
        if not git -C "$target" rev-parse --verify origin/main >/dev/null 2>&1
            for candidate in origin/master main master
                if git -C "$target" rev-parse --verify "$candidate" >/dev/null 2>&1
                    set base_branch "$candidate"
                    break
                end
            end
        end
        set -l counts (git -C "$target" rev-list --left-right --count "$base_branch...HEAD" 2>/dev/null)
        if test -n "$counts"
            set -l c_parts (string split (printf "\t") -- "$counts")
            set -l behind $c_parts[1]
            set -l ahead $c_parts[2]
            set -l ab_parts
            test "$ahead" -gt 0 2>/dev/null; and set -a ab_parts "↑$ahead"
            test "$behind" -gt 0 2>/dev/null; and set -a ab_parts "↓$behind"
            if test (count $ab_parts) -gt 0
                set -l ab_str (string join " " $ab_parts)
                set ab_info (printf " %s(%s%s%s%s vs %s)%s" "$c_dim" "$c_green" "$ab_str" "$c_reset" "$c_dim" "$base_branch" "$c_reset")
            end
        end
    end

    printf "%s🌿 Branch:%s  %s%s%s%s\n" "$c_yellow" "$c_reset" "$c_bold" "$branch_display" "$c_reset" "$ab_info"
    printf "%s📁 Path:%s    %s\n" "$c_blue" "$c_reset" "$display_path"

    # 3. Working Tree Status
    echo ""
    printf "%s📋 Working Tree Status:%s\n" "$c_green" "$c_reset"
    set -l st_lines (git -C "$target" status --short 2>/dev/null)
    if test (count $st_lines) -eq 0
        echo "  ✨ Clean working tree"
    else
        set -l total_changes (count $st_lines)
        printf "  %s⚠️  %d uncommitted file change(s):%s\n" "$c_red" "$total_changes" "$c_reset"
        set -l limit 6
        set -l count_shown 0
        for line in $st_lines
            set count_shown (math $count_shown + 1)
            if test $count_shown -le $limit
                echo "     $line"
            end
        end
        if test $total_changes -gt $limit
            set -l remaining (math $total_changes - $limit)
            printf "     %s... and %d more file(s)%s\n" "$c_dim" "$remaining" "$c_reset"
        end
        set -l diff_stat (git -C "$target" diff --stat 2>/dev/null | tail -n 1 | string trim)
        if test -n "$diff_stat"
            printf "     %s%s%s\n" "$c_dim_gray" "$diff_stat" "$c_reset"
        end
    end

    # Stash indicator
    set -l stash_count (git -C "$target" stash list 2>/dev/null | count)
    if test $stash_count -gt 0
        printf "  %s📦 %d stash entry(ies) saved%s\n" "$c_dim" "$stash_count" "$c_reset"
    end

    # 4. Commit History
    echo ""
    printf "%s📜 Recent Commits:%s\n" "$c_magenta" "$c_reset"
    set -l commits (git -C "$target" log -4 --color=always --format="%C(yellow)%h%C(reset) %C(auto)%d%C(reset) %s %C(dim)(%cr)%C(reset)" 2>/dev/null)
    if test -n "$commits"
        printf "%s\n" $commits
    else
        printf "  %s(no commits found)%s\n" "$c_dim" "$c_reset"
    end
end
