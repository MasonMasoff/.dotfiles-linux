#!/bin/bash

# SSH Server Setup Script with Error Handling
set -e  # Exit immediately if a command exits with a non-zero status

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if running as root or with sudo privileges
if [ "$EUID" -ne 0 ]; then
    print_error "This script requires sudo privileges. Please run with sudo or as root."
    exit 1
fi

print_status "Starting SSH server setup..."

# Update package list
print_status "Updating package list..."
if apt update; then
    check_command "Package update"
else
    print_error "Failed to update package list. Check your internet connection and package sources."
    exit 1
fi

# Install openssh-server
print_status "Installing openssh-server..."
if apt install openssh-server -y; then
    check_command "OpenSSH server installation"
else
    print_error "Failed to install openssh-server. Check package availability and disk space."
    exit 1
fi

# Start SSH service
print_status "Starting SSH service..."
if systemctl start ssh; then
    check_command "SSH service start"
else
    print_error "Failed to start SSH service. Check system logs with: journalctl -u ssh"
    exit 1
fi

# Enable SSH service to start on boot
print_status "Enabling SSH service for auto-start..."
if systemctl enable ssh; then
    check_command "SSH service enable"
else
    print_warning "Failed to enable SSH service for auto-start. You may need to start it manually after reboot."
fi

# Check SSH service status
print_status "Checking SSH service status..."
if systemctl is-active --quiet ssh; then
    print_status "SSH service is running successfully!"
    print_status "SSH server is now active and will start automatically on boot."
    
    # Get the server's IP address for convenience
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
    if [ -n "$IP_ADDRESS" ]; then
        print_status "You can connect to this server via SSH using: ssh username@$IP_ADDRESS"
    fi
else
    print_error "SSH service is not running. Check status with: systemctl status ssh"
    exit 1
fi

print_status "SSH setup completed successfully!"