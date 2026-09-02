# 🏠 Erik's Dotfiles

Automated, secure, and cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/).

Supported Environments:
- 🐧 **CachyOS / Arch Linux** (Wayland / Hyprland / Full Desktop & CLI)
- 📱 **Termux (Android)** (Fish / Neovim / CLI Development)

---

## 🚀 One-Line Automated Setup

### On CachyOS / Arch Linux
```bash
sudo pacman -S --needed git chezmoi && chezmoi init --apply https://github.com/erikenz/dotfiles.git
```

### On Termux (Android)
```bash
pkg update && pkg install -y git chezmoi && chezmoi init --apply https://github.com/erikenz/dotfiles.git
```

---

## 🏗️ Architecture & Best Practices

This repository follows official `chezmoi` best practices:

```
~/.local/share/chezmoi/
├── .chezmoiroot            # Sets target root to home/
├── .chezmoidata/           # Static data manifests
│   └── packages.yaml       # Declarative package lists for CachyOS and Termux
├── .chezmoiscripts/        # Lifecycle scripts
│   ├── run_onchange_before_10-install-packages-cachyos.sh.tmpl
│   ├── run_onchange_before_10-install-packages-termux.sh.tmpl
│   ├── run_onchange_after_20-mise-install.sh.tmpl
│   ├── run_onchange_after_30-fisher-install.sh.tmpl
│   ├── run_once_before_configure-git-hooks.sh.tmpl
│   └── run_once_before_configure-mchose-udev.sh.tmpl
├── home/                   # Source state for target files (~/)
│   ├── .chezmoi.toml.tmpl  # Dynamic platform detection & config
│   ├── .chezmoiignore      # Ignores logs, caches, and filters desktop configs on Termux
│   ├── dot_config/         # Managed configurations (~/.config)
│   └── dot_local/bin/      # Local executable helper scripts (~/.local/bin)
└── bootstrap.sh            # Universal bootstrap script
```

### 1. Tiered Declarative Package Management
The repository manages software across three clean tiers:

1. **System Packages** ([`.chezmoidata/packages.yaml`](.chezmoidata/packages.yaml)):
   - **`common`**: Shared CLI tools (`fish`, `starship`, `neovim`, `ripgrep`, `fd`, `bat`, `eza`, `zoxide`, `fzf`, `jq`, `bottom`, `lazygit`, `tmux`, `curl`, `wget`).
   - **`cachyos`**: Full desktop & CLI stack (`ghostty`, `zed`, `hyprland`, `hyprpicker`, `hyprpolkitagent`, `xdg-desktop-portal-hyprland`, `uwsm`, `wofi`, `zathura`, `zathura-pdf-mupdf`, `cliphist`, `grim`, `slurp`, `pavucontrol`, `playerctl`, `brightnessctl`, `translate-shell`, `cachyos-fish-config`, `fisher`, `fastfetch`, `mise`, `lazydocker`, `shelly`, `swash`, `rbw`, AUR: `input-remapper-git`).
   - **`termux`**: Android CLI stack (`termux-api`, `termux-exec`, `termux-tools`, `openssh`, `proot`, `python`, `nodejs`, `gh`).

2. **Toolchain & Agent Runtimes** ([`~/.config/mise/config.toml`](home/dot_config/mise/config.toml)):
   - Automated post-apply script (`run_onchange_after_20-mise-install.sh.tmpl`) runs `mise install -y` to provision:
     - **`herdr`** (terminal multiplexer for coding agents)
     - **`agy`** (Google Antigravity CLI)
     - **`bun`**, **`node`**, **`pnpm`** (runtimes & package managers)
     - **`mcp-hub`** (MCP server aggregator)
     - **`@dokploy/cli`**, **`cc-safety-net`**

3. **Fish Shell Plugins** ([`~/.config/fish/fish_plugins`](home/dot_config/fish/fish_plugins)):
   - Automated post-apply script (`run_onchange_after_30-fisher-install.sh.tmpl`) updates Fisher plugins:
     - `fzf.fish`, `gitnow`, `fish-abbreviation-tips`, `puffer-fish`, `zoxide.fish`.

### 2. Platform Filtering via `.chezmoiignore`
On **Termux**, GUI and desktop components (Hyprland, Wayland, Ghostty, Zed, GTK/QT, Udev rules) are automatically ignored and never copied to Android storage.

### 3. Portable Scripts & Shebangs
All scripts use `#!/usr/bin/env bash` and respect Termux's `$PREFIX` pathing and non-root execution model.

---

## 🔒 Security & Secret Management

No sensitive tokens, credentials, or private keys are ever published in this public repository.

### Strategy:
1. **API Keys & Passwords**:
   - Retrieved at runtime using [`rbw`](https://github.com/doy/rbw) (Bitwarden CLI) via `get-secret` or chezmoi template functions:
     ```gotemplate
     {{ (rbw "openai").password }}
     ```
   - Falls back to local environment variables (e.g. `OPENCODE_API_KEY`).
2. **Encrypted Files (SSH Keys, Certificates)**:
   - Encrypted with [age](https://github.com/FiloSottile/age) before committing:
     ```bash
     chezmoi add --encrypt ~/.ssh/id_ed25519
     ```
3. **Pre-Commit Secret Scanner**:
   - A Git pre-commit hook automatically scans staged changes for API keys, personal access tokens, and private key headers.

---

## 🛠️ Daily Chezmoi Workflow

| Task | Command |
| :--- | :--- |
| **Edit configuration** | `chezmoi edit ~/.config/fish/config.fish` |
| **Inspect pending changes** | `chezmoi diff` |
| **Apply changes to home** | `chezmoi apply -v` |
| **Add new file to management** | `chezmoi add ~/.config/app/config.json` |
| **Update from GitHub on another machine** | `chezmoi update -v` |
| **Open shell in chezmoi source** | `chezmoi cd` |
| **Verify setup health** | `chezmoi doctor` |

---

## 📚 References
- [chezmoi Documentation](https://www.chezmoi.io/)
- [chezmoi Command Overview](https://www.chezmoi.io/user-guide/command-overview/)
- [chezmoi Reference Guide](https://www.chezmoi.io/reference/)
