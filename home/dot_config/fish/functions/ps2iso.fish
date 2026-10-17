function ps2iso --description 'Pre-flight + upload a PS2 game (Redump .iso, or single-track .bin) to /dev_hdd0/PS2ISO/, tagging the game id for webMAN auto-CONFIG'
    argparse n/no-check x/dry-run c/config= h/help -- $argv
    or return 2
    if set -q _flag_help; or test (count $argv) -ne 1
        echo "usage: ps2iso [-n|--no-check] [-x|--dry-run] [-c|--config FILE] /path/to/game.iso|game.bin" >&2
        echo "  uploads to 192.168.0.103:/dev_hdd0/PS2ISO/ and tags the file name with [GAMEID]" >&2
        echo "  so webMAN picks the config from your local PS2CONFIG database automatically" >&2
        echo "  -c  upload a manual config as '<name>.CONFIG'   -x  stop before uploading" >&2
        return 2
    end

    set -l HOST 192.168.0.103
    set -l src (readlink -f -- "$argv[1]")
    if not test -f "$src"
        echo "ps2iso: no such file: $argv[1]" >&2
        return 1
    end
    # accept a .cue by using its sibling .bin
    if string match -q -- '*.cue' "$src"
        set -l b (string replace -r '\.cue$' '.bin' -- "$src")
        if test -f "$b"
            set src "$b"
        else
            echo "ps2iso: .cue given but no matching .bin found next to it" >&2
            return 1
        end
    end
    if string match -q -- "*'*" "$src"
        echo "ps2iso: filename contains a single quote, which this wrapper can't handle" >&2
        return 1
    end

    if not set -q _flag_no_check
        if not ps3check -p -- "$src"
            echo "ps2iso: pre-flight failed — not uploading (override with -n)" >&2
            return 1
        end
    end

    # --- game id from SYSTEM.CNF (BOOT2 = cdrom0:\SLUS_123.45;1) ----------------
    set -l tmpd (mktemp -d)
    7z e -y -o"$tmpd" "$src" "SYSTEM.CNF" >/dev/null 2>&1
    set -l id ""
    if test -f "$tmpd/SYSTEM.CNF"
        set -l boot (grep -oiE 'BOOT2[[:space:]]*=[[:space:]]*cdrom0:.*' "$tmpd/SYSTEM.CNF" | head -n1)
        set id (echo "$boot" | grep -oE '[A-Za-z]{4}_?[0-9]{3}\.?[0-9]{2}' | head -n1 | tr 'a-z' 'A-Z')
    end
    rm -r "$tmpd"
    if test -n "$id"
        echo "→ game id  : $id"
    else
        echo "→ game id  : not detected (no SYSTEM.CNF/BOOT2) — webMAN auto-CONFIG won't trigger"
    end

    # --- remote name: <name> [<GAMEID>].iso -----------------------------------
    set -l base (basename -- "$src")
    set -l stem (string replace -r '\.[A-Za-z0-9]+$' '' -- "$base")
    set -l remname "$stem.iso"
    if test -n "$id"; and not string match -q -- "*$id*" "$remname"
        set remname "$stem [$id].iso"
    end
    echo "→ remote   : /dev_hdd0/PS2ISO/$remname"

    set -l local_bytes (stat -c %s -- "$src")
    echo "→ size     : $local_bytes bytes"

    if set -q _flag_dry_run
        echo
        echo "DRY RUN: stopping before upload. (source: $src)"
        return 0
    end

    if not timeout 8 bash -c "exec 3<>/dev/tcp/$HOST/21; head -1 <&3"
        echo "ps2iso: FTP on $HOST:21 is not answering (wedged? reboot the PS3)" >&2
        return 1
    end

    echo "→ uploading …"
    lftp -u anonymous,anonymous "$HOST" -e "set ftp:ssl-allow no; put '$src' -o '/dev_hdd0/PS2ISO/$remname'; bye"
    if test $status -ne 0
        echo "ps2iso: upload failed" >&2
        return 1
    end

    # --- verify size ----------------------------------------------------------
    set -l line (lftp -u anonymous,anonymous "$HOST" -e "set ftp:ssl-allow no; ls /dev_hdd0/PS2ISO/; bye" 2>/dev/null | grep -F -- "$remname" | head -n1)
    set -l remote_bytes (string split -n -f 5 ' ' -- "$line")
    if test -z "$remote_bytes"
        echo "ps2iso: couldn't re-list the remote file for verification" >&2
        return 1
    end
    if test "$remote_bytes" != "$local_bytes"
        echo "ps2iso: SIZE MISMATCH — expected $local_bytes, remote $remote_bytes" >&2
        return 1
    end
    echo "✓ verified: $remote_bytes bytes on console (match)"

    # --- optional manual config ------------------------------------------------
    if set -q _flag_config
        set -l cfg (readlink -f -- "$_flag_config")
        if not test -f "$cfg"
            echo "ps2iso: config file not found: $_flag_config" >&2
            return 1
        end
        if lftp -u anonymous,anonymous "$HOST" -e "set ftp:ssl-allow no; put '$cfg' -o '/dev_hdd0/PS2ISO/$remname.CONFIG'; bye"
            echo "✓ config uploaded as $remname.CONFIG"
        else
            echo "ps2iso: config upload failed" >&2
        end
    else if test -n "$id"
        echo "→ config   : webMAN will auto-copy the '$id' config from your PS2CONFIG database on next scan"
    end

    curl -s -m 15 "http://$HOST/refresh.ps3" -o /dev/null
    echo "✓ game list refreshed — launch it from webMAN's PS2 column"
end
