# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

Each directory represents a "package" that can be independently installed:

- `alacritty-config/` - Alacritty terminal emulator configuration
- `claude/` - Claude Code global configuration (settings, skills, plugins)
- `git-config/` - Git prompt and global gitignore
- `nvim-config/` - Neovim configuration
- `tmux/` - Tmux configuration
- `zsh/` - Zsh shell configuration and local rc file

### Naming Convention

This repository follows a consistent naming pattern for stow packages:

- **Packages with `-config` suffix** → Symlink to `~/.config/` or other config directories
  - Examples: `alacritty-config/` → `~/.config/alacritty/`, `nvim-config/` → `~/.config/nvim/`

- **Packages without suffix** → Symlink directly to `~/`
  - Examples: `zsh/` → `~/`, `tmux/` → `~/`, `claude/` → `~/.claude/`

- **Exception: `git-config/`** has the `-config` suffix but symlinks to `~/` (kept for clarity since it contains git configuration utilities)

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
stow claude
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
- Alacritty, Neovim, and Claude configs are placed in `~/.config/` and `~/.claude/`
- Git files are symlinked directly to home directory
- Claude config includes:
  - Global settings (permissions, preferences)
  - Skills (terminal presentation tool documentation via slides-cli)
  - Plugin repository configuration

# Slack Themes

# Rose Pine
`#191724,#191724,#2a2837,#9ccfd8,#211f2d,#e0def4,#f6c177,#31748f,#191724,#c4a7e7"`

# Minimal
`#1A1B1F,#44475A,#272932,#7EB7E6,#272932,#FFFFFF,#94DD8E,#E85A84,#44475A,#FFFFFF`

# Cat Mocha
`#1E1E2E,#F8F8FA,#A6E3A1,#1E1E2E,#11111B,#CDD6F4,#A6E3A1,#EBA0AC,#1E1E2E,#CDD6F4`

# Carbon Fox
`#161616,#F8F8FA,#08BDBA,#161616,#282828,#DFE0EA,#08BDBA,#EE5396,#161616,#DFE0EA`
