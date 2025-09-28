# .dotfiles-linux

Linux system configurations and dotfiles managed with GNU Stow.

## Prerequisites
- Git
- GNU Stow
- ZSH shell
- SSH client

## Quick Start
```bash
# Clone and enter repository
git clone https://github.com/MasonMasoff/.dotfiles-linux.git ~/.dotfiles-linux
cd ~/.dotfiles-linux

# Setup SSH
chmod +x ./ssh-start.sh && ./ssh-start.sh

# Prepare and install dotfiles
cp resources/.stow-global-ignore ~
rm -f ~/.zshrc
stow .

# Reload shell
source ~/.zshrc
```

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