#!/bin/bash

# Installation Script with Homebrew Support
set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command succeeded
check_command() {
    if [ $? -eq 0 ]; then
        print_status "$1 succeeded"
    else
        print_error "$1 failed"
        exit 1
    fi
}

# Function to install prerequisites for Ubuntu/Debian
install_prerequisites() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_status "Installing prerequisites for Linux..."
        
        # Check if apt-get is available (Debian/Ubuntu)
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update
            sudo apt-get install -y build-essential curl git zsh
            check_command "Prerequisites installation"
        else
            print_warning "apt-get not found. Please install build-essential, curl, git, and zsh manually."
        fi
    fi
}

# Function to install Homebrew
install_homebrew() {
    print_status "Checking if Homebrew is installed..."
    
    if command -v brew >/dev/null 2>&1; then
        print_status "Homebrew is already installed"
        return 0
    fi
    
    print_status "Installing Homebrew..."
    
    # Check if we have curl
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is required to install Homebrew. Please install curl first."
        exit 1
    fi
    
    # Install Homebrew (this script handles its own sudo requirements)
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_status "Adding Homebrew to PATH..."
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc 2>/dev/null || true
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    
    # Verify installation
    if command -v brew >/dev/null 2>&1; then
        print_status "Homebrew installed successfully!"
        brew --version
    else
        print_error "Homebrew installation failed"
        exit 1
    fi
}

# Function to install from Brewfile
install_from_brewfile() {
    local brewfile_path="$1"
    
    if [ -z "$brewfile_path" ]; then
        # Look for Brewfile in common locations
        if [ -f "Brewfile" ]; then
            brewfile_path="Brewfile"
        elif [ -f "../Brewfile" ]; then
            brewfile_path="../Brewfile"
        elif [ -f "$HOME/Brewfile" ]; then
            brewfile_path="$HOME/Brewfile"
        else
            print_warning "No Brewfile found. Skipping Brewfile installation."
            return 0
        fi
    fi
    
    if [ ! -f "$brewfile_path" ]; then
        print_warning "Brewfile not found at: $brewfile_path"
        return 0
    fi
    
    print_status "Installing packages from Brewfile: $brewfile_path"
    
    # Change to the directory containing the Brewfile
    local brewfile_dir=$(dirname "$brewfile_path")
    pushd "$brewfile_dir" > /dev/null
    
    if brew bundle install --file="$(basename "$brewfile_path")"; then
        print_status "Successfully installed packages from Brewfile"
    else
        print_error "Failed to install some packages from Brewfile"
        print_warning "Continuing with installation..."
    fi
    
    popd > /dev/null
}

# Main installation function
main() {
    print_status "Starting installation script..."
    echo ""
    
    # Install prerequisites (build-essential, curl, git, zsh)
    install_prerequisites
    
    # Install Homebrew
    install_homebrew
    
    # Install from Brewfile
    install_from_brewfile "$1"  # Pass first argument as Brewfile path
    
    print_status "Installation completed!"
    print_status "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
    
    # Suggest changing default shell to zsh if installed
    if command -v zsh >/dev/null 2>&1; then
        echo ""
        print_status "Zsh has been installed. To set it as your default shell, run:"
        echo -e "    chsh -s \$(which zsh)"
    fi
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being executed, not sourced
    main "$@"
fi


