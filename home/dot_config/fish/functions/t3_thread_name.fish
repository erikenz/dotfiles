function t3_thread_name --description "Get the T3 Code thread name and status for a given worktree path or ID"
    set -l mode "name" # "name", "status", or "details"
    set -l target ""

    for arg in $argv
        switch $arg
            case -s --status
                set mode "status"
            case -d --details
                set mode "details"
            case '*'
                set target $arg
        end
    end

    # If no argument passed, auto-detect if currently inside a .t3 worktree
    if test -z "$target"
        set -l top (git rev-parse --show-toplevel 2>/dev/null)
        if string match -q "*/.t3/worktrees/*" "$top"
            set target "$top"
        else if string match -q "*/.t3/worktrees/*" "$PWD"
            set target "$PWD"
        else
            return 1
        end
    end

    set -l id (basename "$target")
    set -l db "$HOME/.t3/userdata/statev2.sqlite"
    if not test -f "$db"
        set db "$HOME/.t3/userdata/state.sqlite"
    end

    if not test -f "$db"
        switch $mode
            case status
                echo "unknown"
            case details
                printf "%s\t%s\t%s\n" "t3:$id" "unknown" ""
            case '*'
                echo "t3:$id"
        end
        return 0
    end

    # Escape single quotes in target and id
    set -l safe_target (string replace -a "'" "''" "$target")
    set -l safe_id (string replace -a "'" "''" "$id")

    set -l query "SELECT title, COALESCE(deleted_at, ''), COALESCE(archived_at, '') FROM orchestration_v2_projection_threads WHERE json_extract(payload_json, '\$.worktreePath') = '$safe_target' OR json_extract(payload_json, '\$.worktreePath') LIKE '%/$safe_id' ORDER BY updated_at DESC LIMIT 1;"
    set -l tab (printf '\t')
    set -l raw (sqlite3 -batch -noheader -separator "$tab" "$db" "$query" 2>/dev/null)

    if test -z "$raw"
        set -l query_v1 "SELECT title, COALESCE(deleted_at, ''), '' FROM projection_threads WHERE worktree_path = '$safe_target' OR worktree_path LIKE '%/$safe_id' ORDER BY updated_at DESC LIMIT 1;"
        set raw (sqlite3 -batch -noheader -separator "$tab" "$db" "$query_v1" 2>/dev/null)
    end

    set -l name ""
    set -l t_status "unknown"
    set -l del_ts ""

    if test -n "$raw"
        set -l parts (string split "$tab" -- "$raw")
        test -n "$parts[1]"; and set name $parts[1]
        set -l del $parts[2]
        set -l arc $parts[3]

        if test -n "$del"
            set t_status "deleted"
            set del_ts "$del"
        else if test -n "$arc"
            set t_status "archived"
        else
            set t_status "active"
        end
    end

    if test -z "$name"
        set name "t3:$id"
    end

    switch $mode
        case status
            echo "$t_status"
        case details
            printf "%s\t%s\t%s\n" "$name" "$t_status" "$del_ts"
        case '*'
            echo "$name"
    end
end
