# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

Each directory represents a "package" that can be independently installed:

- `alacritty-config/` - Alacritty terminal emulator configuration
- `git-config/` - Git prompt and global gitignore
- `nvim-config/` - Neovim configuration
- `tmux/` - Tmux configuration
- `zsh/` - Zsh shell configuration and local rc file

## Installation

### Prerequisites

Install GNU Stow:

```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow

# Arch Linux
sudo pacman -S stow
```

### Using Stow

From the dotfiles directory, stow individual packages:

```bash
cd ~/.dotfiles

# Install individual packages
stow zsh
stow nvim-config
stow alacritty-config
stow git-config
stow tmux

# Or install everything at once
stow */
```

This creates symlinks from your home directory to the files in this repository.

### Uninstalling

To remove symlinks for a package:

```bash
cd ~/.dotfiles
stow -D zsh
```

### Restow (useful after updating)

To update symlinks after pulling changes:

```bash
cd ~/.dotfiles
stow -R zsh  # or whichever package you updated
```

## Notes

- The `.localrc` file in the zsh package is for machine-specific configuration
- Alacritty and Neovim configs are placed in `~/.config/`
- Git files are symlinked directly to home directory
