# dotfiles

This repo contains the configuration to setup my machines. This is using Chezmoi, the dotfile manager to setup the install.

This automated setup is currently only configured for Fedora machines.

## setup
```bash
export GITHUB_USERNAME=erikenz
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```
