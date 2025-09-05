#!/usr/bin/env fish

set browser (xdg-settings get default-web-browser)

switch $browser
    case "google-chrome*" "brave-browser*" "microsoft-edge*" "opera*" "vivaldi*"
        # browser is already set
    case '*'
        set browser "chromium.desktop"
end

set exec_line (sed -n 's/^Exec=\([^ ]*\).*/\1/p' {~/.local,~/.nix-profile,/usr}/share/applications/$browser 2>/dev/null | head -1)

exec setsid uwsm app -- $exec_line --app="$argv[1]" $argv[2..-1]
