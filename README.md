# .dotfiles-linux

Linux (Ubuntu/Debian) system configurations and dotfiles managed with GNU Stow.

## Prerequisites

The installation script will automatically install the following prerequisites on Ubuntu/Debian:
- `build-essential` - Compiler and development tools
- `curl` - URL transfer tool
- `git` - Version control
- `zsh` - Z shell

## Quick Start
### Clone and enter repository
```bash
git clone https://github.com/MasonMasoff/.dotfiles-linux.git ~/.dotfiles-linux
cd ~/.dotfiles-linux
```

### Setup and Run SSH
```bash
chmod +x ./scripts/ssh-start.sh && ./scripts/ssh-start.sh
```

### Setup and Run Installer (installs prerequisites, Homebrew, and packages)
```bash
chmod +x ./scripts/installs.sh && ./scripts/installs.sh
```

### Prepare and install dotfiles
```bash
cp resources/.stow-global-ignore ~
rm -f ~/.zshrc
stow .
```

### Switch to zsh shell
```bash
zsh
```

### Reload shell configuration
```bash
source ~/.zshrc
```

### Set zsh as default shell (optional, requires re-login to take effect)
```bash
chsh -s $(which zsh)
```

### Change hostname (optional) - Reboot after for it to take effect
```bash
sudo hostnamectl set-hostname <newhostname>
```

### Update apt and restart
```bash
sudo apt update && sudo apt upgrade -y && reboot now
```

## What Gets Installed

The `installs.sh` script will install:
- **Homebrew** - Package manager for Linux
- **Packages from Brewfile:**
  - `gh` - GitHub CLI
  - `git` - Version control
  - `powerlevel10k` - Zsh theme
  - `stow` - Symlink farm manager
  - `tldr` - Simplified man pages
  - `tree` - Directory tree viewer
  - `wget` - File downloader
  - `zsh-autosuggestions` - Fish-like autosuggestions
  - `zsh-syntax-highlighting` - Syntax highlighting for zsh

## Maintenance

Update configurations:
```bash
cd ~/.dotfiles-linux && git pull && stow .
```

## Shell Customization

- View available aliases: `alias`
- Customize p10k theme: `p10k configure`
- Custom configurations can be added to `~/.alias-custom.zsh`
- After any configuration changes, run `stow .` to update symlinks and `reload` to reload the ZSH shell
