function pnpm --wraps pnpm --description "pnpm wrapper with transparent portless support for dev commands"
    # 1. Fall back to native pnpm if portless is not installed
    if not type -q portless
        command pnpm $argv
        return $status
    end

    # 2. Check for explicit bypass via environment variable (PORTLESS=0)
    if test "$PORTLESS" = "0"
        command pnpm $argv
        return $status
    end

    # 3. Check for explicit bypass via --no-portless flag
    if contains -- --no-portless $argv
        set -l clean_args
        for arg in $argv
            if test "$arg" != "--no-portless"
                set -a clean_args "$arg"
            end
        end
        command pnpm $clean_args
        return $status
    end

    # 4. Check if the command targets 'dev' or 'run dev'
    set -l is_dev 0
    set -l idx 1
    set -l total (count $argv)

    while test $idx -le $total
        set -l arg $argv[$idx]
        if string match -q -- "-C" "$arg"; or string match -q -- "--dir" "$arg"; or string match -q -- "--filter" "$arg"; or string match -q -- "-F" "$arg"
            # Flag with a separate argument value
            set idx (math $idx + 2)
        else if string match -q -- "-*" "$arg"
            # Flag option (standalone or --flag=value)
            set idx (math $idx + 1)
        else
            if test "$arg" = "dev"
                set is_dev 1
            else if test "$arg" = "run" -a (math $idx + 1) -le $total
                set -l next_arg $argv[(math $idx + 1)]
                if test "$next_arg" = "dev"
                    set is_dev 1
                end
            end
            break
        end
    end

    # 5. Route through portless if dev command was detected
    if test $is_dev -eq 1
        portless run pnpm $argv
        return $status
    end

    # 6. Default: run native pnpm directly
    command pnpm $argv
end
