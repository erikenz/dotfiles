function delta_thread_name --description "Get the Delta thread name for a given worktree session ID"
    set -l ns $argv[1]

    # If no argument passed, auto-detect if currently inside a .delta worktree
    if test -z "$ns"
        set -l top (git rev-parse --show-toplevel 2>/dev/null)
        if string match -q "*/.delta/worktrees/*" "$top"
            set ns (basename (dirname "$top"))
        else
            return 1
        end
    end

    set -l db_files "$HOME"/.local/share/delta/user_*/data.sqlite
    if not test -f "$db_files[1]"
        echo "delta:$ns"
        return 0
    end

    set -l query "SELECT t.name FROM app_worktree_mounts m JOIN history_timelines wt ON printf('%08X', wt.timeline_timestamp + 2) = substr(hex(m.worktree_id), 5, 8) JOIN histories ht ON wt.history_key = ht.history_key + 1 JOIN app_threads t ON t.history_id = ht.history_uuid WHERE m.namespace = '$ns' LIMIT 1;"
    set -l name (sqlite3 -batch -noheader "$db_files[1]" "$query" 2>/dev/null)

    if test -n "$name"
        echo $name
    else
        echo "delta:$ns"
    end
end
