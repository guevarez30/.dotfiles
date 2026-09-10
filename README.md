<div align="center">

# 🏠 Dotfiles

**Modern development environment • Consistent across machines • Powered by GNU Stow**

[![macOS](https://img.shields.io/badge/macOS-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![GNU Stow](https://img.shields.io/badge/GNU%20Stow-A42E2B?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/software/stow/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)

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

**3. Install Node.js via nvm**:
```bash
# Install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Restart terminal or source profile
source ~/.zshrc

# Install latest LTS version
nvm install --lts
nvm use --lts
```

**4. Stow your dotfiles**:
```bash
stow zsh nvim-config alacritty-config claude git-config tmux
```

> 💡 **Tip:** Run `brew bundle dump --force` to update the Brewfile with newly installed packages

---

### Linux VM Installation

Give an agent running **on the destination Linux VM** this instruction:

> Set up this VM using the Linux VM Installation section of `~/.dotfiles/README.md`.
> Inspect the machine and existing dotfiles, install the required tools, apply the
> configuration, and verify that it works. Perform the installation directly;
> do not create installer scripts, test suites, or CI workflows. Preserve existing
> files and report installed versions, remaining authentication, and any blockers.

This section is the installation specification. Run installation work on the VM,
never on the Mac used to edit this repository.

#### Required tools

| Area | Install |
| --- | --- |
| Languages | Go, Node.js LTS/npm through nvm, Python 3/pip/venv and uv, Java 21 JDK, Rust/Cargo/rustfmt/Clippy through rustup |
| Containers | Docker Engine and CLI, Docker Compose plugin, Buildx plugin, Helm, kind, kubectl, k9s |
| Shell | Zsh, Oh My Zsh, zsh-autosuggestions, zsh-syntax-highlighting, tmux, fzf, zoxide, Carapace |
| Editor | Neovim, plugins from the existing configuration, Tree-sitter parsers, language servers and formatters |
| Utilities | Git, GitHub CLI (`gh`), GNU Stow, ripgrep, fd, bat, jq, tree, eza, curl, wget, OpenSSH client, GnuPG, slides |
| Build and system tools | GCC/C++, Make, CMake, pkg-config, OpenSSL development headers, CA certificates, zip/unzip, tar/gzip/xz, ncurses/terminfo tools, procps, iproute2, lsof, ShellCheck, shfmt |

#### Installation requirements for the agent

1. Detect the distribution, architecture, target user, home directory, and existing
   installations. Use distro packages where suitable and current official vendor
   instructions where newer versions are needed. Check project compatibility for
   Go, Java, Node.js, Helm, kubectl, and kind. Record the chosen versions so other
   VMs can use the same baseline.
2. Use this checkout at `~/.dotfiles`, or clone
   `https://github.com/guevarez30/.dotfiles.git` on branch `raft-vm` if absent.
   Preserve local changes and the existing branch when reusing a checkout.
3. Install Docker Engine with Compose and Buildx, enable its service, and configure
   Docker access for the target user. Verify access from a fresh user session.
4. Install Oh My Zsh at `~/.oh-my-zsh` and the two external Zsh plugins under its
   custom plugins directory. Preserve the repository's `.zshrc`. Install nvm at
   `~/.nvm`, use an fzf version supporting `fzf --zsh`, and make Go, Cargo, and
   user-installed executables available in a fresh login shell. Set Zsh as the
   user's login shell; check the shell paths in `tmux/.tmux.conf` against the VM.
5. Back up conflicting dotfiles, then use GNU Stow as the target user. All packages
   below target the home directory; their contents include the necessary `.config`
   paths:

   ```bash
   cd ~/.dotfiles
   stow --target="$HOME" zsh tmux nvim-config git-config k9s-config
   ```

6. Install TPM at `~/.tmux/plugins/tpm` and install the plugins declared in
   `tmux/.tmux.conf`. Initialize Neovim's existing Lazy configuration using the
   committed `lazy-lock.json`. Inspect `nvim-config/.config/nvim/lua/plugins/`
   for required language servers, parsers, formatters, and external dependencies;
   use Mason or official tool installers as appropriate. Formatting currently
   requires StyLua, Prettier, goimports/gofmt, rustfmt, autopep8, and templ.
7. Configure Git's global excludes file to use `~/.gitignore_global`. Keep personal
   Git identity, GitHub authentication, private repository access, and AI provider
   credentials specific to each user. Machine-specific shell settings can live in
   `~/.raftrc`. Desktop terminals and fonts belong on the SSH client; install optional
   AI tools and their configuration only when requested.

#### Completion checks on the VM

Verify the required commands and versions in a fresh login shell, Docker daemon
access plus Compose/Buildx, tmux startup and plugins, and Neovim startup and
`:checkhealth`. Confirm Stow links resolve to this checkout and configured
formatters and language servers are available. Report failures and outstanding
authentication explicitly. Creating a kind cluster is project-specific and is
not part of the base installation.

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

## ✅ Code Review Workflow

All file changes made by Claude Code require manual approval before being applied. This ensures you have full control over modifications to your dotfiles. Changes appear in a diff view within Neovim for easy review and acceptance.

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

- Dracula theme
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
