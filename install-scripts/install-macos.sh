#!/bin/bash
set -e  # Exit on error

###################################################################################
# macOS Installation Script
# Installs packages via Homebrew and sets up development environment
###################################################################################

DOTFILES_DIR="$HOME/.dotfiles"
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BOLD}${BLUE}=== macOS Development Environment Setup ===${NC}\n"

###################################################################################
# Helper Functions
###################################################################################

print_step() {
    echo -e "${BOLD}${BLUE}==>${NC} ${BOLD}$1${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

###################################################################################
# Check if running on macOS
###################################################################################

if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is for macOS only. Use install-linux.sh instead."
    exit 1
fi

###################################################################################
# 1. Install Homebrew
###################################################################################

print_step "Checking for Homebrew..."

if ! command_exists brew; then
    print_warning "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

###################################################################################
# 2. Install packages from Brewfile
###################################################################################

print_step "Installing packages from Brewfile..."

cd "$DOTFILES_DIR"

if [ -f "Brewfile" ]; then
    brew bundle install
    print_success "Packages installed from Brewfile"
else
    print_error "Brewfile not found in $DOTFILES_DIR"
    exit 1
fi

###################################################################################
# 3. Install Node.js via nvm
###################################################################################

print_step "Setting up Node.js via nvm..."

if [ ! -d "$HOME/.nvm" ]; then
    print_warning "nvm not found. Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

    # Load nvm for this script
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    print_success "nvm installed"
else
    print_success "nvm already installed"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

if ! command_exists node; then
    print_warning "Node.js not found. Installing latest LTS..."
    nvm install --lts
    nvm use --lts
    print_success "Node.js installed"
else
    print_success "Node.js already installed ($(node --version))"
fi

###################################################################################
# 4. Install oh-my-zsh
###################################################################################

print_step "Setting up oh-my-zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_warning "oh-my-zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "oh-my-zsh installed"
else
    print_success "oh-my-zsh already installed"
fi

###################################################################################
# 5. Install zsh plugins
###################################################################################

print_step "Installing zsh plugins..."

# zsh-syntax-highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    print_success "zsh-syntax-highlighting installed"
else
    print_success "zsh-syntax-highlighting already installed"
fi

# zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
        "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    print_success "zsh-autosuggestions installed"
else
    print_success "zsh-autosuggestions already installed"
fi

###################################################################################
# 6. Install tmux plugin manager
###################################################################################

print_step "Setting up tmux plugin manager..."

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    print_success "tmux plugin manager installed"
else
    print_success "tmux plugin manager already installed"
fi

###################################################################################
# 7. Install slides CLI
###################################################################################

print_step "Installing slides CLI..."

if ! command_exists slides; then
    brew install slides
    print_success "slides installed"
else
    print_success "slides already installed"
fi

###################################################################################
# 8. Stow dotfiles
###################################################################################

print_step "Stowing dotfiles..."

cd "$DOTFILES_DIR"

# Stow each package
for package in alacritty-config ghostty-config git-config nvim-config zsh tmux; do
    if [ -d "$package" ]; then
        stow -R "$package" 2>/dev/null || stow "$package"
        print_success "Stowed $package"
    else
        print_warning "Package $package not found, skipping..."
    fi
done

###################################################################################
# 9. Create .localrc if it doesn't exist
###################################################################################

print_step "Checking for .localrc..."

if [ ! -f "$HOME/.localrc" ]; then
    print_warning ".localrc not found. Creating minimal .localrc..."
    cat > "$HOME/.localrc" << 'EOF'
# Machine-specific configuration
# Add your custom aliases, functions, and environment variables here

# This file is sourced by .zshrc
EOF
    print_success ".localrc created"
else
    print_success ".localrc already exists"
fi

###################################################################################
# Done!
###################################################################################

echo ""
echo -e "${BOLD}${GREEN}=== Installation Complete! ===${NC}\n"
echo -e "${BOLD}Next steps:${NC}"
echo -e "  1. Restart your terminal or run: ${BLUE}source ~/.zshrc${NC}"
echo -e "  2. Install tmux plugins: Open tmux and press ${BLUE}Ctrl+a + I${NC}"
echo -e "  3. Open Neovim to install plugins: ${BLUE}nvim${NC}"
echo ""
echo -e "${BOLD}Optional:${NC}"
echo -e "  - Review Brewfile and add/remove packages as needed"
echo -e "  - Edit ~/.localrc for machine-specific configuration"
echo -e "  - Run ${BLUE}brew bundle dump --force${NC} to update Brewfile with current packages"
echo ""
