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

    set -l query "SELECT t.name FROM app_worktree_mounts m JOIN app_worktrees w ON instr(m.state, w.history_id) > 0 JOIN histories hw ON hw.history_uuid = w.history_id LEFT JOIN history_dependencies d ON d.dependency_history_uuid = w.history_id LEFT JOIN histories hd ON hd.history_key = d.history_key JOIN app_threads t ON (t.history_id = hd.history_uuid OR t.history_id = (SELECT history_uuid FROM histories WHERE history_key = hw.history_key - 1)) WHERE m.namespace = '$ns' ORDER BY COALESCE(t.last_prompted_at, t.created_at, 0) DESC LIMIT 1;"
    set -l name (sqlite3 -batch -noheader "$db_files[1]" "$query" 2>/dev/null)

    if test -n "$name"
        echo $name
    else
        echo "delta:$ns"
    end
end
