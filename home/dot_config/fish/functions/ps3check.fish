function ps3check --description 'Pre-flight check for a PS3 ISO: container type, disc structure, PC payloads (autorun/.exe), integrity; optional Redump hash + ClamAV'
    argparse --min-args=0 --max-args=1 d/deep c/clam p/ps2 h/help -- $argv
    or return 2

    if set -q _flag_help; or test (count $argv) -ne 1
        echo "usage: ps3check [-d|--deep] [-c|--clam] [-p|--ps2] /path/to/game.iso" >&2
        echo "  (default) container type, size sanity, disc structure, PC payload scan" >&2
        echo "  -p        expect a PS2 disc (SYSTEM.CNF) instead of a PS3 disc" >&2
        echo "  -d        also read every byte, print hashes, compare with a Redump DAT if present" >&2
        echo "  -c        also run clamscan (requires clamav installed)" >&2
        return 2
    end

    set -l src (readlink -f -- "$argv[1]")
    if not test -f "$src"
        echo "ps3check: not a file: $argv[1]" >&2
        return 1
    end

    set -l problems 0
    echo "== ps3check: "(basename -- "$src")

    # 1) container type ----------------------------------------------------
    set -l ftype (file -b -- "$src")
    echo "• container : $ftype"
    if not string match -q -- '*ISO 9660*' "$ftype"
        echo "  ✗ not an ISO-9660 image — refusing. A PS3 disc dump is an ISO/UDF image;"
        echo "    an archive (.zip/.rar) or an executable (.exe/.sh) is not what you asked for."
        return 1
    end

    # 2) size sanity -------------------------------------------------------
    set -l bytes (stat -c %s -- "$src")
    echo "• size      : "(math "round($bytes / 1073741824 * 10) / 10")" GiB  ($bytes bytes)"
    if set -q _flag_ps2
        if test $bytes -lt 52428800
            echo "  ✗ under 50 MiB — no PS2 disc game is this small"
            set problems (math $problems + 1)
        else if test $bytes -lt 104857600
            echo "  ~ under 100 MiB — small for a PS2 disc (fine for test images)"
        end
    else if test $bytes -lt 104857600
        echo "  ✗ under 100 MiB — no PS3 disc game is this small"
        set problems (math $problems + 1)
    else if test $bytes -lt 1073741824
        echo "  ~ under 1 GiB — unusual for a PS3 disc dump (fine for test images)"
    end

    # 3) disc structure + PC payload scan (single listing pass) ------------
    set -l list (mktemp /tmp/ps3check.XXXXXX)
    set -l lister "(none)"
    if bsdtar -tf "$src" >$list 2>/tmp/ps3check_err
        set lister bsdtar
    end
    if not test -s $list
        # libarchive chokes on some UDF 2.50 PS3 images that 7-Zip reads fine
        7z l -slt -ba "$src" 2>/dev/null | string replace -r '^Path = ' '' >$list
        if test -s $list
            set lister 7z
        end
    end
    if test "$lister" = "(none)"
        echo "  ✗ neither bsdtar nor 7-Zip could read this image — corrupt or truncated?:"
        head -3 /tmp/ps3check_err
        set problems (math $problems + 1)
    else
        echo "• entries   : "(wc -l < $list)" (listed with $lister)"
        if set -q _flag_ps2
            if grep -qE '(^|/)SYSTEM\.CNF(/|$)' $list
                echo "  ✓ SYSTEM.CNF (PS2 disc structure)"
            else
                echo "  ✗ SYSTEM.CNF not found — this is not a PS2 disc image"
                set problems (math $problems + 1)
            end
        else
            for need in PS3_DISC.SFB PS3_GAME PS3_UPDATE
                if grep -qE "(^|/)$need(/|\$)" $list
                    echo "  ✓ $need"
                else
                    echo "  ~ $need not found (unusual; not always fatal)"
                end
            end
        end
        set -l pat 'autorun\.inf$|\.(exe|dll|lnk|bat|cmd|scr|pif|vbs|vbe|jse|msi|ps1|hta|reg|com)$'
        set -l bad (grep -icE $pat $list)
        if test "$bad" -gt 0
            echo "  ✗ $bad PC executable/script payload(s) inside the image:"
            grep -iE $pat $list | head -10
            set problems (math $problems + 1)
        else
            echo "  ✓ no autorun.inf / .exe / .dll / .lnk / .bat / .js payloads"
        end
    end
    rm -f $list

    # 4) deep: full read pass + hashes + optional Redump comparison --------
    if set -q _flag_deep
        echo "• reading every byte (detects truncation / bad sectors)…"
        set -l s1 (sha1sum -- "$src")
        if test (count $s1) -eq 0
            echo "  ✗ read error while hashing — file is corrupt or the disk is failing"
            set problems (math $problems + 1)
        else
            set -l sha (string split -n -- ' ' $s1)[1]
            set -l m1 (md5sum -- "$src")
            set -l md5 (string split -n -- ' ' $m1)[1]
            echo "  sha1: $sha"
            echo "  md5 : $md5"
            set -l dat "$HOME/.cache/redump/ps3.dat"
            if set -q _flag_ps2
                set dat "$HOME/.cache/redump/ps2.dat"
            end
            if test -f "$dat"
                if grep -qi -- "$sha" "$dat"
                    echo "  ✓ matches a Redump entry → bit-identical to a known retail dump"
                else
                    echo "  ~ no Redump match in $dat (repack, other region, or stale DAT) — treat as unverified"
                end
            else
                echo "  ~ no Redump DAT at $dat"
                echo "    for authoritative verification, save the matching Redump DAT from redump.org there"
            end
        end
    end

    # 5) optional ClamAV ---------------------------------------------------
    if set -q _flag_clam
        if command -q clamscan
            echo "• clamscan:"
            command clamscan --infected --no-summary -- "$src"
        else
            echo "• clamscan not installed — install it with: sudo pacman -S clamav   (or: sudo apt install clamav)"
        end
    end

    if test $problems -gt 0
        echo "== RESULT: $problems problem(s) — do not trust this file =="
        return 1
    end
    echo "== RESULT: OK =="
end
