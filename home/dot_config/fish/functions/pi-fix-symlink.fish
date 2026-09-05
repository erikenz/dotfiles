# ~/.config/fish/functions/pi-fix-symlink.fish  (fish auto-loads this on first use)
#
# Stopgap for earendil-works/pi#8092 (fix PR #8112, unmerged):
# pnpm installs extensions as symlinks into .pnpm/, and pi's jiti loader doesn't
# realpath the entry, so bare-importing the package's own deps fails with
# "Cannot find module '<dep>'" (e.g. @pi-unipi/notify -> @pi-unipi/core).
# This links each missing dep to the top-level node_modules/, exactly where
# pnpm would have put it if the dep were a direct dependency.
#
# Usage:  pi-fix-symlink @pi-unipi/notify [@pi-unipi/compactor @pi-unipi/memory ...]

function pi-fix-symlink
    set -l npm_root "$HOME/.config/pi/agent/npm/node_modules"
    if not test -d "$npm_root"
        echo "pi-fix-symlink: no managed npm dir at $npm_root" >&2
        return 1
    end

    set -l linked 0
    for pkg in $argv
        set -l entry "$npm_root/$pkg"
        if not test -e "$entry"
            echo "pi-fix-symlink: '$pkg' not installed (missing $entry)" >&2
            continue
        end
        # Only pnpm-symlinked installs need fixing (git/hoisted real dirs resolve fine)
        if not test -L "$entry"
            echo "pi-fix-symlink: '$pkg' is a real dir, nothing to fix" >&2
            continue
        end

        set -l real (readlink -f "$entry")
        # pnpm layout: .../.pnpm/<pkg>@<ver>[_<peers>]/node_modules/<pkg>
        # the sibling node_modules/ dir holds this package's deps
        set -l store_nodes (dirname (dirname "$real"))
        set -l self_name (basename "$real")

        # unscoped deps (e.g. node-notifier, typebox)
        for dep in (command find "$store_nodes" -maxdepth 1 -mindepth 1 \
                        ! -name '@*' ! -name '.*' ! -name "$self_name" -printf '%f\n' 2>/dev/null)
            if pi_fix_link "$npm_root" "$store_nodes" "$dep"
                set linked (math $linked + 1)
            end
        end

        # scoped deps (@scope/name, e.g. @pi-unipi/core)
        for scope in (command find "$store_nodes" -maxdepth 1 -mindepth 1 -name '@*' -printf '%f\n' 2>/dev/null)
            for name in (command find "$store_nodes/$scope" -maxdepth 1 -mindepth 1 \
                            ! -name '.*' -printf '%f\n' 2>/dev/null)
                if test "$name" = "$self_name"
                    continue # the package itself, skip
                end
                if pi_fix_link "$npm_root" "$store_nodes" "$scope/$name"
                    set linked (math $linked + 1)
                end
            end
        end
    end

    if test "$linked" -gt 0
        echo "pi-fix-symlink: created $linked symlink(s); restart pi to pick them up."
    else
        echo "pi-fix-symlink: nothing to fix."
    end
end

function pi_fix_link
    # Link one dep at top level if missing. Status 0 = linked, 1 = skipped/failed.
    set -l npm_root $argv[1]
    set -l store_nodes $argv[2]
    set -l dep $argv[3]
    set -l top "$npm_root/$dep"

    test -e "$top"; and return 1 # already resolves fine

    if not test -e "$store_nodes/$dep"
        echo "pi-fix-symlink: store sibling missing for '$dep'" >&2
        return 1
    end

    set -l scope_dir (dirname "$top")
    if not test -d "$scope_dir"
        mkdir -p "$scope_dir"; or return 1
    end

    # -f re-links (self-heals dangling links after pi update), -n never derefs dirs
    ln -sfn "$store_nodes/$dep" "$top"; or begin
        echo "pi-fix-symlink: failed to link '$dep' (existing dir?)" >&2
        return 1
    end
    echo "pi-fix-symlink: linked $dep -> $store_nodes/$dep"
    return 0
end
