# Dotfiles

This repo contains the configuration to setup my machines. This is using Chezmoi, the dotfile manager to setup the install.

This automated setup is currently only configured for Fedora machines.

## Setup
```bash
export GITHUB_USERNAME=erikenz
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```
or to use a transitory environment:
```bash
export GITHUB_USERNAME=erikenz
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot $GITHUB_USERNAME
```

## Usage

### re-add
update dotfiles
```bash
chezmoi re-add
```

## Dependencies

### Utilities
- [yay](https://github.com/Jguer/yay)
- [chezmoi]()
- [fnm]()

### Hyprland
- [hyprsunset](https://wiki.hypr.land/Hypr-Ecosystem/hyprsunset/)
- [hyprcursor](https://wiki.hypr.land/Hypr-Ecosystem/hyprcursor/)
- [hypridle](https://wiki.hypr.land/Hypr-Ecosystem/hypridle/)
- [hyprpicker](https://wiki.hypr.land/Hypr-Ecosystem/hyprpicker/)
- [hyprpaper](https://wiki.hypr.land/Hypr-Ecosystem/hyprpaper/)

```fish
sudo pacman -S hyprland hyprsunset hyprcursor hypridle hyprpicker hyprpaper
```

### Cursor
- [catppuccin-cursors-macchiato](https://github.com/catppuccin/cursors)
```fish
paru -S catppuccin-cursors-macchiato
```

### Nvim

### Shell
- [fish]()
- [fisher](https://github.com/jorgebucaran/fisher)
- [starship]()
