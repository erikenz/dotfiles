function ps3iso --description 'Pre-flight check + upload a game .iso to the PS3 (webMAN FTP @ 192.168.0.103 -> /dev_hdd0/PS3ISO/)'
    argparse n/no-check h/help -- $argv
    or return 2
    if set -q _flag_help; or test (count $argv) -ne 1
        echo "usage: ps3iso [-n|--no-check] /path/to/game.iso" >&2
        echo "  runs ps3check first (structure + malware payloads); -n skips that" >&2
        return 2
    end

    set -l src (readlink -f -- "$argv[1]")
    if not test -f "$src"
        echo "ps3iso: no such file: $argv[1]" >&2
        return 1
    end
    if not string match -q -- '*.iso' "$src"
        echo "ps3iso: not a .iso file: $src" >&2
        return 1
    end
    if string match -q -- "*'*" "$src"
        echo "ps3iso: filename contains a single quote, which this wrapper can't handle" >&2
        return 1
    end

    # pre-flight: refuse obviously bad / tampered images before spending bandwidth
    if not set -q _flag_no_check
        if not ps3check -- "$src"
            echo "ps3iso: pre-flight check failed — not uploading (override with: ps3iso -n <file>)" >&2
            return 1
        end
    end

    set -l name (basename -- "$src")
    set -l local_bytes (stat -c %s -- "$src")
    set -l size (du -h -- "$src" | cut -f1)
    echo "→ $name ($size) → 192.168.0.103:/dev_hdd0/PS3ISO/"

    lftp -u anonymous,anonymous 192.168.0.103 -e "set ftp:ssl-allow no; put '$src' -o '/dev_hdd0/PS3ISO/$name'; bye"
    set -l st $status
    if test $st -ne 0
        echo "ps3iso: upload failed (lftp exit $st)" >&2
        return 1
    end

    # verify: remote size must match the size recorded before the upload
    set -l line (lftp -u anonymous,anonymous 192.168.0.103 -e "set ftp:ssl-allow no; ls /dev_hdd0/PS3ISO/; bye" 2>/dev/null | grep -F -- "$name" | head -n1)
    set -l remote_bytes (string split -n -f 5 ' ' -- "$line")
    if test -z "$remote_bytes"
        echo "ps3iso: couldn't re-list the remote file for verification" >&2
        return 1
    end
    if test "$remote_bytes" != "$local_bytes"
        echo "ps3iso: SIZE MISMATCH — expected $local_bytes, remote $remote_bytes" >&2
        if not test -f "$src"
            echo "ps3iso: note: the local file was deleted during the transfer; the copy on the PS3 may still be fine" >&2
        end
        return 1
    end

    curl -s -m 15 "http://192.168.0.103/refresh.ps3" -o /dev/null
    echo "✓ verified: $remote_bytes bytes on console (match); game list refreshed"
end
