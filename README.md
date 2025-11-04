<div align="center">

# 🏠 Dotfiles

**Modern development environment • Consistent across machines • Powered by GNU Stow**

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![GNU Stow](https://img.shields.io/badge/GNU%20Stow-A42E2B?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/software/stow/)

</div>

---

## 📦 Package Structure

<table>
<tr>
<td width="50%">

### Terminal & Shell
- <img src="https://cdn.simpleicons.org/alacritty/F46D01" height="16" alt="alacritty"/> **`alacritty-config/`** - GPU-accelerated terminal
- <img src="https://cdn.simpleicons.org/zsh/F15A24" height="16" alt="zsh"/> **`zsh/`** - Shell with oh-my-zsh
- <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tmux/tmux-original.svg" height="16" alt="tmux"/> **`tmux/`** - Terminal multiplexer

</td>
<td width="50%">

### Editors & Tools
- <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/neovim/neovim-original.svg" height="16" alt="neovim"/> **`nvim-config/`** - Neovim IDE setup
- <img src="https://cdn.simpleicons.org/anthropic/191919" height="16" alt="claude"/> **`claude/`** - Claude Code AI assistant
- <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg" height="16" alt="git"/> **`git-config/`** - Git utilities

</td>
</tr>
</table>

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

### Prerequisites

<div align="left">

![Homebrew](https://img.shields.io/badge/Homebrew-FBB040?style=flat-square&logo=homebrew&logoColor=black)
![APT](https://img.shields.io/badge/APT-A81D33?style=flat-square&logo=debian&logoColor=white)
![Pacman](https://img.shields.io/badge/Pacman-1793D1?style=flat-square&logo=arch-linux&logoColor=white)

</div>

```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow

# Arch Linux
sudo pacman -S stow
```

### Installation

```bash
cd ~/.dotfiles

# Install individual packages
stow zsh nvim-config alacritty-config claude git-config tmux

# Or install everything at once
stow */
```

> 💡 **Tip:** Stow creates symlinks from `~/` to files in this repository

### Management

<table>
<tr>
<td width="33%">

**🗑️ Uninstall**
```bash
stow -D zsh
```

</td>
<td width="33%">

**🔄 Restow**
```bash
stow -R zsh
```

</td>
<td width="33%">

**👀 Preview**
```bash
stow -n -v zsh
```

</td>
</tr>
</table>

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

---

## 🎨 Tech Stack

<div align="left">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/neovim/neovim-original.svg" height="40" alt="neovim logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tmux/tmux-original.svg" height="40" alt="tmux logo"  />
  <img width="12" />
  <img src="https://cdn.simpleicons.org/gnubash/4EAA25" height="40" alt="bash logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/git/git-original.svg" height="40" alt="git logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/go/go-original.svg" height="40" alt="go logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nodejs/nodejs-original.svg" height="40" alt="nodejs logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg" height="40" alt="python logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/rust/rust-original.svg" height="40" alt="rust logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg" height="40" alt="docker logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg" height="40" alt="postgresql logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mongodb/mongodb-original.svg" height="40" alt="mongodb logo"  />
  <img width="12" />
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg" height="40" alt="redis logo"  />
</div>

---

<div align="center">

### 📚 Documentation

For detailed configuration information, custom functions, and troubleshooting, see [CLAUDE.md](CLAUDE.md)

**Made with ❤️ and ☕**

</div>
