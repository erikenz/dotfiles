function _wt_remove --description "Safely remove a git worktree with interactive confirmation"
    set -l target $argv[1]
    set -l repo_root $argv[2]

    if test -z "$target"
        echo "No worktree specified."
        return 1
    end

    if test -n "$repo_root" -a "$target" = "$repo_root"
        echo "❌ Cannot remove the main project root!"
        read -P "Press Enter to continue..."
        return 1
    end

    if not test -d "$target"
        echo "ℹ️  Directory does not exist on disk. Pruning git registration..."
        if test -n "$repo_root"
            git -C "$repo_root" worktree prune -v
        end
        read -P "Press Enter to continue..."
        return 0
    end

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "⚠️  WORKTREE REMOVAL"
    echo "   Target: $target"
    set -l branch (git -C "$target" branch --show-current 2>/dev/null)
    test -n "$branch"; and echo "   Branch: $branch"
    set -l st (git -C "$target" status --short 2>/dev/null)
    if test -n "$st"
        echo "   ⚠️  WARNING: Worktree has uncommitted changes!"
        for line in $st[1..5]
            echo "     $line"
        end
        if test (count $st) -gt 5
            echo "     ..."
        end
    end
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -l -P "Are you sure you want to remove this worktree? [y/N] " confirm
    if string match -qi "y*" "$confirm"
        if test -n "$st"
            read -l -P "Force remove worktree with uncommitted changes? [y/N] " force_confirm
            if string match -qi "y*" "$force_confirm"
                if test -n "$repo_root"
                    git -C "$repo_root" worktree remove --force "$target"
                else
                    git worktree remove --force "$target"
                end
            else
                echo "Aborted."
                sleep 0.5
                return 1
            end
        else
            if test -n "$repo_root"
                git -C "$repo_root" worktree remove "$target"
            else
                git worktree remove "$target"
            end
        end
        echo "✅ Worktree removed."
        if test -n "$repo_root"
            git -C "$repo_root" worktree prune -v
        end
        sleep 0.5
    else
        echo "Aborted."
        sleep 0.4
    end
end
