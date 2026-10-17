function ps3game --description 'Install a PS3 game as a JB folder (real icon): extract ISO -> name by TITLE_ID -> zip -> upload -> console-side unzip -> refresh'
    argparse n/no-check x/dry-run r/remove-staging h/help -- $argv
    or return 2
    if set -q _flag_help; or test (count $argv) -ne 1
        echo "usage: ps3game [-n|--no-check] [-x|--dry-run] [-r|--remove-staging] /path/to/game.iso|folder" >&2
        echo "  builds /dev_hdd0/GAMES/<TITLE_ID>/ on the PS3 so the game gets its real icon" >&2
        echo "  -n  skip ps3check pre-flight   -x  stop after building the zip (no upload)" >&2
        echo "  -r  delete the local staging tree after a successful install" >&2
        echo "  staging dir: ~/Games/PS3/.ps3game" >&2
        return 2
    end

    set -l HOST 192.168.0.103
    set -l src (readlink -f -- "$argv[1]")
    if not test -e "$src"
        echo "ps3game: no such file or directory: $argv[1]" >&2
        return 1
    end

    if not set -q _flag_no_check; and string match -q -- '*.iso' "$src"
        if not ps3check -- "$src"
            echo "ps3game: pre-flight failed — not converting (override with -n)" >&2
            return 1
        end
    end

    set -l work "$HOME/Games/PS3/.ps3game"
    mkdir -p "$work"

    # --- 1) get the folder tree -------------------------------------------------
    set -l tree ""
    if test -d "$src"
        set tree "$src"
        echo "→ using existing folder: $tree"
    else
        set -l tmph "$work/.extract-tmp"
        if test -e "$tmph"
            echo "ps3game: stale staging dir exists: $tmph — remove it and re-run" >&2
            return 1
        end
        mkdir -p "$tmph"
        echo "→ extracting "(basename -- "$src")" (this can take a few minutes)…"
        if not 7z x -y -o"$tmph" "$src" >/tmp/ps3game_extract.log 2>&1
            echo "ps3game: extraction failed — tail of /tmp/ps3game_extract.log:" >&2
            tail -3 /tmp/ps3game_extract.log >&2
            return 1
        end
        if not test -d "$tmph/PS3_GAME"
            echo "ps3game: no PS3_GAME/ in the extracted tree — is this a PS3 disc image?" >&2
            return 1
        end
        set tree "$tmph"
    end

    # --- 2) title id / title from PARAM.SFO ------------------------------------
    set -l sfo "$tree/PS3_GAME/PARAM.SFO"
    if not test -f "$sfo"
        echo "ps3game: missing $sfo" >&2
        return 1
    end
    set -l meta (python3 -c 'import struct,sys
d=open(sys.argv[1],"rb").read()
if d[:4]!=b"\x00PSF":
    print(""); print(""); raise SystemExit
k,t,n=struct.unpack_from("<III",d,8)
g=lambda x:(d[k+x[0]:d.index(b"\x00",k+x[0])].decode("ascii","replace"), d[t+x[4]:t+x[4]+x[2]].rstrip(b"\x00").decode("utf-8","replace"))
r=dict(g(struct.unpack_from("<HHIII",d,20+i*16)) for i in range(n))
print(r.get("TITLE_ID",""))
print(r.get("TITLE",""))' "$sfo")
    set -l tid "$meta[1]"
    set -l title "$meta[2]"
    if test -z "$tid"
        echo "ps3game: could not read TITLE_ID from PARAM.SFO" >&2
        return 1
    end
    echo "→ title id : $tid"
    echo "→ title    : $title"

    # --- 3) name the folder after the title id ---------------------------------
    set -l game "$work/$tid"
    if test "$tree" != "$game"
        if test -e "$game"
            echo "ps3game: $game already exists — remove it first" >&2
            return 1
        end
        mv "$tree" "$game"; or return 1
    end
    if test -f "$game/PS3_GAME/ICON0.PNG"
        echo "→ icon     : PS3_GAME/ICON0.PNG found (this is what webMAN displays)"
    else
        echo "→ icon     : no ICON0.PNG in this game — webMAN will use a default icon"
    end

    # --- 4) space sanity on the console ----------------------------------------
    set -l bytes (du -sb -- "$game" | cut -f1)
    set -l gb (math "round($bytes / 1073741824 * 10) / 10")
    set -l freegb (curl -s -m 15 "http://$HOST/dev_hdd0/" | grep -oE '[0-9.]+ GB free' | head -n1 | awk '{print $1}')
    if test -n "$freegb"
        echo "→ size     : $gb GiB   (console reports $freegb GiB free)"
    else
        echo "→ size     : $gb GiB   (console free space unknown)"
    end
    if test -n "$freegb"; and math "$freegb < $gb * 2"
        echo "WARNING: console needs roughly "(math "round($gb * 2 * 10) / 10")" GiB free (zip + extracted folder)." >&2
    end

    # --- 5) zip it (top-level entry = <TITLE_ID>/, so it extracts into GAMES/) --
    set -l zip "$work/$tid.zip"
    rm -f "$zip"
    echo "→ zipping (store mode)…"
    pushd "$work" >/dev/null
    if not 7z a -tzip -mx1 "$tid.zip" "$tid" >/tmp/ps3game_zip.log 2>&1
        popd >/dev/null
        echo "ps3game: zip failed — see /tmp/ps3game_zip.log" >&2
        return 1
    end
    popd >/dev/null
    echo "→ built    : $zip ("(du -h -- "$zip" | cut -f1)")"

    if set -q _flag_dry_run
        echo
        echo "DRY RUN: stopping before upload. Local folder: $game"
        return 0
    end

    # --- 6) upload the single zip ----------------------------------------------
    if not timeout 8 bash -c "exec 3<>/dev/tcp/$HOST/21; head -1 <&3"
        echo "ps3game: FTP on $HOST:21 is not answering (wedged? reboot the PS3)" >&2
        return 1
    end
    echo "→ uploading $tid.zip …"
    if not curl --user anonymous:anonymous --retry 3 --retry-delay 2 --connect-timeout 15 \
            --progress-bar -T "$zip" "ftp://$HOST/dev_hdd0/GAMES/$tid.zip"
        echo "ps3game: upload failed" >&2
        return 1
    end

    # --- 7) let the console extract it -----------------------------------------
    echo "→ asking the console to extract /dev_hdd0/GAMES/$tid.zip …"
    curl -s -m 1800 "http://$HOST/unzip.ps3/dev_hdd0/GAMES/$tid.zip" -o /dev/null
    sleep 2
    set -l stat (curl -s -m 30 "http://$HOST/stat.ps3/dev_hdd0/GAMES/$tid")
    set -l rbytes (echo $stat | grep -oE '\([0-9,]+ bytes\)' | head -n1 | tr -dc '0-9')
    test -n "$rbytes"; or set rbytes 0
    set -l rfiles (echo $stat | grep -oE 'File\(s\): *[0-9,]+' | head -n1 | tr -dc '0-9')
    test -n "$rfiles"; or set rfiles 0
    set -l lfiles (find "$game" -type f | wc -l)

    echo "→ verify   : local $bytes bytes / $lfiles files   vs   console $rbytes bytes / $rfiles files"
    if test "$rbytes" = "$bytes"; and test "$rfiles" = "$lfiles"
        echo "✓ console folder matches local exactly"
        curl -s -m 30 "http://$HOST/delete.ps3/dev_hdd0/GAMES/$tid.zip" -o /dev/null
        echo "✓ removed the zip from the console"
        curl -s -m 30 "http://$HOST/refresh.ps3" -o /dev/null
        echo "✓ game list refreshed"
        if set -q _flag_remove_staging
            rm -r -- "$game"; and echo "✓ local staging removed"
        end
        echo
        echo "FINISHED: SUCCESS — $title ($tid) is installed with its icon"
    else
        echo "✗ verification failed — the zip is left on the console for inspection." >&2
        echo "  (large zip64 archives may not extract on the console; try multiMAN/IRISMAN instead)" >&2
        echo
        echo "FINISHED: INCOMPLETE"
        return 1
    end
end
