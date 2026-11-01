function t3_thread_name --description "Get the T3 Code thread name for a given worktree path or ID"
    set -l target $argv[1]

    # If no argument passed, auto-detect if currently inside a .t3 worktree
    if test -z "$target"
        set -l top (git rev-parse --show-toplevel 2>/dev/null)
        if string match -q "*/.t3/worktrees/*" "$top"
            set target "$top"
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
        echo "t3:$id"
        return 0
    end

    # Escape single quotes in target and id
    set -l safe_target (string replace -a "'" "''" "$target")
    set -l safe_id (string replace -a "'" "''" "$id")

    set -l query "SELECT title FROM orchestration_v2_projection_threads WHERE json_extract(payload_json, '\$.worktreePath') = '$safe_target' OR json_extract(payload_json, '\$.worktreePath') LIKE '%/$safe_id' ORDER BY updated_at DESC LIMIT 1;"
    set -l name (sqlite3 -batch -noheader "$db" "$query" 2>/dev/null)

    if test -z "$name"
        set -l query_v1 "SELECT title FROM projection_threads WHERE worktree_path = '$safe_target' OR worktree_path LIKE '%/$safe_id' ORDER BY updated_at DESC LIMIT 1;"
        set name (sqlite3 -batch -noheader "$db" "$query_v1" 2>/dev/null)
    end

    if test -n "$name"
        echo $name
    else
        echo "t3:$id"
    end
end
