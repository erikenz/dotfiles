# Chezmoi Dotfiles Manager

This repository contains dotfiles managed by [chezmoi](https://www.chezmoi.io/).

---

## 🚀 Getting Started

### 1. Install Chezmoi

```bash
# Via one-line script
sh -c "$(curl -fsLS https://chezmoi.io/get)"

# Arch Linux
sudo pacman -S chezmoi

# macOS (Homebrew)
brew install chezmoi
```

### 2. Initialize from this repository

To initialize chezmoi on a new machine and apply these configurations:

```bash
chezmoi init --apply https://github.com/<your-username>/<your-repo-name>.git
```

---

## 🛠️ Daily Workflow

### Adding a file
To start managing a configuration file with chezmoi:
```bash
chezmoi add ~/.bashrc
```

### Editing a file
To edit a managed configuration file (this opens the file in your default editor):
```bash
chezmoi edit ~/.bashrc
```

### Checking changes
To see the difference between your managed source files and your home directory:
```bash
chezmoi diff
```

### Applying changes
To apply changes from your source state to your home directory:
```bash
chezmoi apply -v
```

---

## 🔄 Syncing Configuration

### 1. Push changes
To save your local changes to your remote repository:

```bash
# Open a shell in the chezmoi source directory
chezmoi cd

# Run standard Git commands
git add .
git commit -m "update configuration"
git push

# Exit back to your original directory
exit
```

### 2. Pull changes on another machine
To fetch the latest changes from your repository and apply them:

```bash
chezmoi update -v
```

---

For full documentation and advanced features, visit [chezmoi.io](https://www.chezmoi.io/).
