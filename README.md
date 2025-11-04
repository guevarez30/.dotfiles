<div align="center">

# 🏠 Dotfiles

**Modern development environment • Consistent across machines • Powered by GNU Stow**

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![GNU Stow](https://img.shields.io/badge/GNU%20Stow-A42E2B?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/software/stow/)

</div>

---

## 📦 Package Structure

### Terminal & Shell

- <img src="https://cdn.simpleicons.org/alacritty/F46D01" height="16" alt="alacritty"/> **`alacritty-config/`** - GPU-accelerated terminal
- <img src="https://cdn.simpleicons.org/zsh/F15A24" height="16" alt="zsh"/> **`zsh/`** - Shell with oh-my-zsh
- <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tmux/tmux-original.svg" height="16" alt="tmux"/> **`tmux/`** - Terminal multiplexer

### Editors & Tools

- <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/neovim/neovim-original.svg" height="16" alt="neovim"/> **`nvim-config/`** - Neovim IDE setup
- <img src="https://cdn.simpleicons.org/anthropic/191919" height="16" alt="claude"/> **`claude/`** - Claude Code AI assistant
- <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg" height="16" alt="git"/> **`git-config/`** - Git utilities

### 📝 Naming Convention

> **Pattern:** `-config` suffix indicates XDG config directory, no suffix means home directory

```
alacritty-config/  →  ~/.config/alacritty/
nvim-config/       →  ~/.config/nvim/
ghostty-config/    →  ~/.config/ghostty/

zsh/               →  ~/
tmux/              →  ~/
claude/            →  ~/.claude/
git-config/        →  ~/  (exception: contains git utilities)
```

## 🚀 Quick Start

### macOS Installation

<div align="left">

![Homebrew](https://img.shields.io/badge/Homebrew-FBB040?style=flat-square&logo=homebrew&logoColor=black)

</div>

**1. Install Homebrew** (if not already installed):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**2. Install all packages from Brewfile**:

```bash
cd ~/.dotfiles
brew bundle install
```

This will install:

- 🔧 Development tools (Go, Python, Git, Neovim, Tmux)
- 📦 CLI utilities (ripgrep, fd, bat, tree, jq, stow)
- 🖥️ Terminal emulators (Ghostty, Alacritty)

**3. Stow your dotfiles**:

```bash
stow zsh nvim-config alacritty-config claude git-config tmux
```

> 💡 **Tip:** Run `brew bundle dump --force` to update the Brewfile with newly installed packages

---

### Linux Installation

<div align="left">

![APT](https://img.shields.io/badge/APT-A81D33?style=flat-square&logo=debian&logoColor=white)
![Pacman](https://img.shields.io/badge/Pacman-1793D1?style=flat-square&logo=arch-linux&logoColor=white)

</div>

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install -y stow git neovim tmux ripgrep fd-find bat tree jq \
                    golang-go python3 python3-pip alacritty
```

**Arch Linux:**

```bash
sudo pacman -S stow git neovim tmux ripgrep fd bat tree jq \
               go python python-pip alacritty
```

**Then stow your dotfiles:**

```bash
cd ~/.dotfiles
stow zsh nvim-config alacritty-config claude git-config tmux
```

> 💡 **Note:** On Ubuntu/Debian, `fd` is installed as `fdfind` and `bat` as `batcat`. Aliases in `.localrc` handle this.

### Management

**🗑️ Uninstall**

```bash
stow -D zsh
```

**🔄 Restow**

```bash
stow -R zsh
```

**👀 Preview**

```bash
stow -n -v zsh
```

---

## 🛠️ What's Included

<details>
<summary><b><img src="https://cdn.simpleicons.org/zsh/F15A24" height="16" alt="zsh"/> Zsh Configuration</b></summary>

- oh-my-zsh framework with robbyrussell theme
- Plugins: git, web-search, sudo, syntax-highlighting, autosuggestions
- Custom functions: tmux session management, git helpers, docker shortcuts
- Machine-specific config via `.localrc`

</details>

<details>
<summary><b><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/neovim/neovim-original.svg" height="16" alt="neovim"/> Neovim Setup</b></summary>

- lazy.nvim plugin manager
- LSP support with Mason
- Modular Lua configuration
- Custom keybindings and color schemes

</details>

<details>
<summary><b><img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tmux/tmux-original.svg" height="16" alt="tmux"/> Tmux Configuration</b></summary>

- Catppuccin Macchiato theme
- Custom prefix: `Ctrl+a`
- vim-tmux-navigator integration
- Plugin management via TPM

</details>

<details>
<summary><b><img src="https://cdn.simpleicons.org/anthropic/191919" height="16" alt="claude"/> Claude Code</b></summary>

- Global permissions & preferences
- Custom skills (Slides CLI presentation tool)
- Plugin repository configuration

</details>

<details>
<summary><b><img src="https://cdn.simpleicons.org/alacritty/F46D01" height="16" alt="alacritty"/> Terminal Emulators</b></summary>

- **Alacritty:** GPU-accelerated, multiple themes, Hack Nerd Font
- **Ghostty:** Placeholder for future configuration

</details>
