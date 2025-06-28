{{- if (eq .chezmoi.os "linux") -}}
{{- if eq .chezmoi.osRelease.idLike "arch" -}}
#!/usr/bin/env bash

# Ask for the administrator password upfront
# sudo -v
