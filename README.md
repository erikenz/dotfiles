# dotfiles

This repo contains the configuration to setup my machines. This is using Chezmoi, the dotfile manager to setup the install.

This automated setup is currently only configured for Fedora machines.

## Overview

- WM: Hyprland
- Panels and widgets: Quickshell
- Editor: Neovim & Zed
- Shell: zsh & p10k
- Terminal: ghostty

## setup
```bash
export GITHUB_USERNAME=erikenz
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```
or to use a transitory environment:
```bash
export GITHUB_USERNAME=erikenz
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --one-shot $GITHUB_USERNAME
```

## usage

### re-add
update dotfiles
```bash
chezmoi re-add
```

## dependencies

### hyprland

### nvim

### zsh plugins

zsh plugins that need to be cloned

- [history-string-search](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/history-substring-search)
- [fzf-tab](https://github.com/Aloxaf/fzf-tab)
- [zsh-completions](https://github.com/zsh-users/zsh-completions)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

## TODO

- [ ] add package install and setup scripts
