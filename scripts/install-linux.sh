#!/bin/bash
set -e  # Exit on error

###################################################################################
# Linux Installation Script
# Installs packages and sets up development environment
# Supports: Ubuntu/Debian (apt) and Arch Linux (pacman)
###################################################################################

DOTFILES_DIR="$HOME/.dotfiles"
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BOLD}${BLUE}=== Linux Development Environment Setup ===${NC}\n"

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
# Detect Linux Distribution
###################################################################################

print_step "Detecting Linux distribution..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    print_success "Detected: $NAME"
else
    print_error "Cannot detect Linux distribution"
    exit 1
fi

###################################################################################
# Set Package Manager
###################################################################################

case "$DISTRO" in
    ubuntu|debian)
        PKG_MANAGER="apt"
        PKG_UPDATE="sudo apt update"
        PKG_INSTALL="sudo apt install -y"
        ;;
    arch|manjaro)
        PKG_MANAGER="pacman"
        PKG_UPDATE="sudo pacman -Sy"
        PKG_INSTALL="sudo pacman -S --noconfirm"
        ;;
    *)
        print_error "Unsupported distribution: $DISTRO"
        print_warning "This script supports Ubuntu/Debian and Arch Linux"
        exit 1
        ;;
esac

print_success "Using package manager: $PKG_MANAGER"

###################################################################################
# 1. Update package lists
###################################################################################

print_step "Updating package lists..."
$PKG_UPDATE
print_success "Package lists updated"

###################################################################################
# 2. Install packages
###################################################################################

print_step "Installing packages..."

if [ "$PKG_MANAGER" = "apt" ]; then
    # Ubuntu/Debian packages
    $PKG_INSTALL \
        golang \
        python3 \
        python3-pip \
        ripgrep \
        fd-find \
        bat \
        tree \
        jq \
        stow \
        neovim \
        tmux \
        git \
        curl \
        wget \
        build-essential

    # Create symlinks for fd and bat (Debian/Ubuntu naming)
    if [ ! -f /usr/local/bin/fd ] && command_exists fdfind; then
        sudo ln -s $(which fdfind) /usr/local/bin/fd
        print_success "Created symlink: fd -> fdfind"
    fi

    if [ ! -f /usr/local/bin/bat ] && command_exists batcat; then
        sudo ln -s $(which batcat) /usr/local/bin/bat
        print_success "Created symlink: bat -> batcat"
    fi

elif [ "$PKG_MANAGER" = "pacman" ]; then
    # Arch Linux packages
    $PKG_INSTALL \
        go \
        python \
        python-pip \
        ripgrep \
        fd \
        bat \
        tree \
        jq \
        stow \
        neovim \
        tmux \
        git \
        curl \
        wget \
        base-devel
fi

print_success "Packages installed"

###################################################################################
# 3. Install Alacritty (Linux terminal emulator)
###################################################################################

print_step "Installing Alacritty terminal..."

if ! command_exists alacritty; then
    if [ "$PKG_MANAGER" = "apt" ]; then
        # Add Alacritty PPA for Ubuntu/Debian
        sudo add-apt-repository ppa:aslatter/ppa -y 2>/dev/null || true
        sudo apt update
        $PKG_INSTALL alacritty
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        $PKG_INSTALL alacritty
    fi
    print_success "Alacritty installed"
else
    print_success "Alacritty already installed"
fi

###################################################################################
# 4. Install Node.js via nvm
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
# 5. Install oh-my-zsh
###################################################################################

print_step "Setting up oh-my-zsh..."

# Install zsh if not present
if ! command_exists zsh; then
    print_warning "zsh not found. Installing..."
    if [ "$PKG_MANAGER" = "apt" ]; then
        $PKG_INSTALL zsh
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        $PKG_INSTALL zsh
    fi
    print_success "zsh installed"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_warning "oh-my-zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "oh-my-zsh installed"
else
    print_success "oh-my-zsh already installed"
fi

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    print_warning "Setting zsh as default shell..."
    chsh -s $(which zsh)
    print_success "Default shell changed to zsh (restart terminal to take effect)"
fi

###################################################################################
# 6. Install zsh plugins
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
    print_success "zsh-autosuggestions already installed"
else
    print_success "zsh-autosuggestions already installed"
fi

###################################################################################
# 7. Install tmux plugin manager
###################################################################################

print_step "Setting up tmux plugin manager..."

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    print_success "tmux plugin manager installed"
else
    print_success "tmux plugin manager already installed"
fi

###################################################################################
# 8. Install slides CLI
###################################################################################

print_step "Installing slides CLI..."

if ! command_exists slides; then
    print_warning "Installing slides from GitHub..."
    SLIDES_VERSION=$(curl -s https://api.github.com/repos/maaslalani/slides/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

    if [ "$PKG_MANAGER" = "apt" ]; then
        wget "https://github.com/maaslalani/slides/releases/download/v${SLIDES_VERSION}/slides_${SLIDES_VERSION}_linux_amd64.tar.gz" -O /tmp/slides.tar.gz
    elif [ "$PKG_MANAGER" = "pacman" ]; then
        wget "https://github.com/maaslalani/slides/releases/download/v${SLIDES_VERSION}/slides_${SLIDES_VERSION}_linux_amd64.tar.gz" -O /tmp/slides.tar.gz
    fi

    tar -xzf /tmp/slides.tar.gz -C /tmp
    sudo mv /tmp/slides /usr/local/bin/
    rm /tmp/slides.tar.gz
    print_success "slides installed"
else
    print_success "slides already installed"
fi

###################################################################################
# 9. Stow dotfiles
###################################################################################

print_step "Stowing dotfiles..."

cd "$DOTFILES_DIR"

# Stow each package
for package in alacritty-config git-config nvim-config zsh tmux; do
    if [ -d "$package" ]; then
        stow -R "$package" 2>/dev/null || stow "$package"
        print_success "Stowed $package"
    else
        print_warning "Package $package not found, skipping..."
    fi
done

# Note: ghostty-config skipped on Linux (macOS only)

###################################################################################
# 10. Create .localrc if it doesn't exist
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
echo -e "  2. If zsh was just installed, log out and back in for shell change"
echo -e "  3. Install tmux plugins: Open tmux and press ${BLUE}Ctrl+a + I${NC}"
echo -e "  4. Open Neovim to install plugins: ${BLUE}nvim${NC}"
echo ""
echo -e "${BOLD}Optional:${NC}"
echo -e "  - Edit ~/.localrc for machine-specific configuration"
echo -e "  - Configure Alacritty theme in ~/.config/alacritty/alacritty.yml"
echo ""
