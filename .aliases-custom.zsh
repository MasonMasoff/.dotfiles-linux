# --- Custom Aliases --- #
## Functional aliases
alias reload="source ~/.zshrc"
alias dotfiles="cd ~/.dotfiles-linux"
alias c="clear"
alias cheatsheet="echo \"\$cheatsheet_content\""
alias cdrepos='cd ~/Documents/Repos'
alias python='python3'
alias pip='pip3'

## Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gco="git checkout"

## Directory navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# --- Custom Functions --- #
## Copies command output to clipboard
cclip() {
  "$@" | clipcopy
}

## Automatically activate or create a virtual environment
function makevenv() {
    if [ -d "$1" ]; then
        cd "$1" || return
        if [ ! -d ".venv" ]; then
            python3 -m venv .venv
        fi
        source .venv/bin/activate
    else
        echo "Directory $1 does not exist -- If you are in project directory run: makevenv ."
    fi
}

## Makes shell scripts executable, and runs them
function runscript() {
    if [ -f "$1" ]; then
        chmod +x "$1"
        ./"$1"
    else
        echo "File $1 not found!"
    fi
}

## Makes webserver to host files
function hostserver() {
    echo "IP address: "
    ipconfig getifaddr en0

    echo ""
    python3 -m http.server 8080
}