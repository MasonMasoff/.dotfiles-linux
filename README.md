# .dotfiles-linux
# My dotfiles

This directory contains the dotfiles for my linux systems

## Requirements

Ensure you have the following installed on your system

### Git

```
apt install -y git
```

### Stow

```
apt install -y stow
```

## Installation

1. Check out the dotfiles repo in your $HOME directory using git
```bash
git clone https://github.com/MasonMasoff/.dotfiles-linux.git
cd .dotfiles-linux
```


2. Go to the scripts folder and run `ssh-start.sh`
```bash
chmod +x ./ssh-start.sh && ./ssh-start.sh

```


3. Connect via SSH to the machine (optionally use VSCode Remote Explorer plugin)

```bash
ssh <user>@<IP Address>
```

4. Move the `.stow-global-ignore` file to the home directory (from testing, this cannot be sym-linked)
```bash
cp resources/.stow-global-ignore ~
```

## Updates
1. Update the configuration with the line below
```bash
git pull && cp ~/.dotfiles-linux/resources/.stow-global-ignore ~ && stow .
```

## p10k stuff