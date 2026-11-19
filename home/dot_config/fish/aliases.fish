# ==============================================================================
# Fish Shell Aliases & Abbreviations (~/.config/fish/aliases.fish)
# ==============================================================================

# --- 1. Navigation & System ---
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'
alias r-fish='source ~/.config/fish/config.fish; fish_user_key_bindings 2>/dev/null; commandline -f repaint'
alias r='r-fish'

# --- 2. Runtimes, Package Managers & Editors ---
abbr -a p 'pnpm'
abbr -a px 'pnpm dlx'
abbr -a b 'bun'
abbr -a bx 'bunx'
abbr -a npm 'pnpm'
abbr -a npx 'pnpm dlx'
abbr -a zed 'zeditor'
alias astronvim='env NVIM_APPNAME=astronvim nvim'
alias lazyvim='env NVIM_APPNAME=lazyvim nvim'
alias nvim='astronvim'
abbr -a portainer 'docker run -p 8000:8000 -p 9443:9443 --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:lts'

# --- 3. Configuration Jumpers (Prefix: cf-*) ---
abbr -a cf-fish 'cd ~/.config/fish && n'
abbr -a cf-hypr 'cd ~/.config/hypr && n'
abbr -a cf-ghostty 'cd ~/.config/ghostty && n'
abbr -a cf-nvim 'cd ~/.config/astronvim && n'
abbr -a cf-lazyvim 'cd ~/.config/lazyvim && n'
abbr -a cf-herdr 'cd ~/.config/herdr && n'
abbr -a cf-cz 'cd ~/.local/share/chezmoi && n'
abbr -a cf-mise 'cd ~/.config/mise && n'

# --- 4. Shelly Package Manager (Prefix: s*) ---
# Note: 'ssearch' is used to avoid collision with iproute2's /usr/bin/ss
abbr -a s 'shelly'
abbr -a si 'shelly install'
abbr -a sr 'shelly remove'
abbr -a ssearch 'shelly search'
abbr -a sup 'shelly upgrade'
abbr -a sls 'shelly list'
abbr -a slu 'shelly list-updates'
abbr -a spurge 'shelly purify'
abbr -a ssync 'shelly sync'
abbr -a snews 'shelly news'
abbr -a sdown 'shelly downgrade'
abbr -a spacfiles 'shelly utility -p'

# Backend-specific targets: Standard (sis), AUR (sia), Flatpak (sif), AppImage (sii)
abbr -a sis 'shelly install standard'
abbr -a sia 'shelly install aur'
abbr -a sif 'shelly install flatpak'
abbr -a sii 'shelly install appimage'
abbr -a srs 'shelly remove standard'
abbr -a sra 'shelly remove aur'
abbr -a srf 'shelly remove flatpak'
abbr -a sri 'shelly remove appimage'
abbr -a sss 'shelly search standard'
abbr -a ssa 'shelly search aur'
abbr -a ssf 'shelly search flatpak'
abbr -a slss 'shelly list standard'
abbr -a slsa 'shelly list aur'
abbr -a slsf 'shelly list flatpak'
abbr -a slsi 'shelly list appimage'

# --- 5. Herdr Local Multiplexer (Prefix: h*) ---
abbr -a h 'herdr'
abbr -a hs 'herdr status'
abbr -a hw 'herdr workspace list'
abbr -a ht 'herdr tab list'
abbr -a hp 'herdr pane list'
abbr -a ha 'herdr agent list'
abbr -a hstop 'herdr server stop'

# --- 6. Remote Sessions (Server & Laptop) ---
# Home Server
abbr -a server-ssh 'ssh server'
abbr -a server-tg-start 'ssh server "systemctl --user start telegram-bot"'
abbr -a server-tg-stop 'ssh server "systemctl --user stop telegram-bot"'
abbr -a server-tg-restart 'ssh server "systemctl --user restart telegram-bot"'
abbr -a server-tg-status 'ssh server "systemctl --user status telegram-bot"'
abbr -a server-tg-logs 'ssh server "journalctl --user -u telegram-bot -f"'

# Remote Laptop (for Termux / Mobile)
abbr -a laptop-ssh 'ssh laptop'
abbr -a laptop-herdr 'ssh -t laptop "herdr"'
abbr -a laptop-agents 'ssh laptop "herdr agent list"'
abbr -a laptop-status 'ssh laptop "herdr status"'
abbr -a laptop-wake 'ssh server "wakeonlan d8:43:ae:d7:2f:86"'
abbr -a laptop-workspaces 'ssh laptop "herdr workspace list"'
abbr -a laptop-lock 'ssh laptop "loginctl lock-session 2>/dev/null; or hyprctl dispatch exit"'

# Mobile <-> Laptop Clipboard Sync
alias clip-push='termux_clipboard_push'
alias clip-pull='termux_clipboard_pull'

# --- 7. Chezmoi Dotfiles Manager (Prefix: cz*) ---
abbr -a cz 'chezmoi'
abbr -a cza 'chezmoi apply'
abbr -a czav 'chezmoi apply -v'
abbr -a czd 'chezmoi diff'
abbr -a czs 'chezmoi status'
abbr -a cze 'chezmoi edit'
abbr -a czcd 'chezmoi cd'
abbr -a czadd 'chezmoi add'
abbr -a czra 'chezmoi re-add'
abbr -a czu 'chezmoi update'
abbr -a czdoc 'chezmoi doctor'
