#!/bin/bash
set -e  # Exit on error

###################################################################################
# Main Installation Script
# Detects OS and runs appropriate installation script
###################################################################################

DOTFILES_DIR="$HOME/.dotfiles"
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${BLUE}║                                                ║${NC}"
echo -e "${BOLD}${BLUE}║     Development Environment Setup Script      ║${NC}"
echo -e "${BOLD}${BLUE}║                                                ║${NC}"
echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

###################################################################################
# Helper Functions
###################################################################################

print_step() {
    echo -e "${BOLD}${BLUE}==>${NC} ${BOLD}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

###################################################################################
# Change to dotfiles directory
###################################################################################

if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Dotfiles directory not found at $DOTFILES_DIR"
    print_error "Please clone the repository first:"
    echo -e "  ${BLUE}git clone <your-repo-url> ~/.dotfiles${NC}"
    exit 1
fi

cd "$DOTFILES_DIR"

###################################################################################
# Detect Operating System
###################################################################################

print_step "Detecting operating system..."

OS_TYPE=""

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
    print_success "Detected: macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="linux"
    print_success "Detected: Linux"
else
    print_error "Unsupported operating system: $OSTYPE"
    echo "This script supports macOS and Linux only."
    exit 1
fi

###################################################################################
# Run appropriate installation script
###################################################################################

echo ""
print_step "Starting installation for $OS_TYPE..."
echo ""

if [ "$OS_TYPE" = "macos" ]; then
    if [ -f "$DOTFILES_DIR/scripts/install-macos.sh" ]; then
        bash "$DOTFILES_DIR/scripts/install-macos.sh"
    else
        print_error "macOS installation script not found!"
        exit 1
    fi
elif [ "$OS_TYPE" = "linux" ]; then
    if [ -f "$DOTFILES_DIR/scripts/install-linux.sh" ]; then
        bash "$DOTFILES_DIR/scripts/install-linux.sh"
    else
        print_error "Linux installation script not found!"
        exit 1
    fi
fi

###################################################################################
# Final message
###################################################################################

echo ""
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║                                                ║${NC}"
echo -e "${BOLD}${GREEN}║     Setup Complete! Enjoy your new setup!      ║${NC}"
echo -e "${BOLD}${GREEN}║                                                ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════╝${NC}"
echo ""
