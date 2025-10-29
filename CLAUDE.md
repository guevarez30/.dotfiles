# Dotfiles Configuration Repository

## Overview

This repository contains personal dotfiles and configuration files for a consistent development environment across multiple macOS machines. It manages configurations for terminal emulators (Alacritty, Ghostty), shell (Zsh), text editor (Neovim), terminal multiplexer (Tmux), Git, and various development tools.

> **Note**: This repository uses **GNU Stow** for clean, package-based dotfile management.

---

## Current Repository Structure

```
~/.dotfiles/
├── Brewfile                # Homebrew package definitions (macOS)
├── install.sh              # Main installation orchestrator
├── scripts/                # Installation scripts
│   ├── install-macos.sh    # macOS-specific installation
│   └── install-linux.sh    # Linux-specific installation
├── alacritty-config/       # Alacritty terminal emulator
│   └── .config/
│       └── alacritty/
│           ├── alacritty.yml
│           └── [themes].yml
├── ghostty-config/         # Ghostty terminal emulator
│   └── .config/
│       └── (config files)
├── git-config/             # Git utilities
│   ├── .git-prompt.sh
│   └── .gitignore_global
├── nvim-config/            # Neovim configuration
│   └── .config/
│       └── nvim/
│           ├── init.lua
│           ├── lazy-lock.json
│           ├── after/
│           ├── colors/
│           └── lua/
├── zsh/                    # Zsh shell configuration
│   ├── .zshrc
│   └── .localrc
├── tmux/                   # Tmux multiplexer
│   └── .tmux.conf
├── slides/                 # Slides CLI documentation
│   ├── CLAUDE.md
│   └── skills/
├── .tmux/                  # Tmux plugins
│   └── plugins/
│       ├── catppuccin-tmux
│       ├── tpm
│       └── vim-tmux-navigator
└── README.md               # Quick reference guide
```

### Package Details

#### `alacritty-config/`
Alacritty terminal emulator configuration (stowed to `~/.config/alacritty/`):
- **Main config**: `alacritty.yml` - GPU-accelerated terminal with Hack Nerd Font
- **Themes**: nocturnal.yml, dracula.yml, onedark.yml, cyberdream.yml, nightfox.yml, mocha.yml
- **Settings**: 98% opacity, 100x50 default dimensions, custom color palette

#### `ghostty-config/`
Ghostty terminal emulator configuration (stowed to `~/.config/ghostty/`):
- **Status**: Placeholder directory for Ghostty configuration
- **Future**: Will contain theme and configuration files

#### `git-config/`
Git utilities and global settings (stowed to `~/`):
- `.git-prompt.sh` - Enhanced Git prompt for shell
- `.gitignore_global` - Global gitignore patterns

#### `nvim-config/`
Neovim configuration with Lua-based setup (stowed to `~/.config/nvim/`):
- **Package manager**: lazy.nvim
- **Structure**: Modular configuration split into:
  - `init.lua` - Entry point
  - `lazy-lock.json` - Plugin version lock file
  - `after/` - After-load configurations
  - `colors/` - Color scheme definitions
  - `lua/` - Main Lua configuration modules
- **Features**: LSP support, syntax highlighting, custom keybindings

#### `zsh/`
Zsh configuration with oh-my-zsh framework (stowed to `~/`):
- **`.zshrc`**: Base configuration with oh-my-zsh, robbyrussell theme
- **Plugins**: git, web-search, sudo, zsh-syntax-highlighting, zsh-autosuggestions
- **`.localrc`**: Machine-specific customizations and all custom functions/aliases

#### `tmux/`
Tmux terminal multiplexer configuration (stowed to `~/`):
- **Config**: `.tmux.conf` with Catppuccin Macchiato theme
- **Prefix**: `Ctrl+a` (instead of default `Ctrl+b`)
- **Plugins** (in `.tmux/plugins/`):
  - tmux-plugin-manager (tpm)
  - vim-tmux-navigator - Seamless navigation between vim and tmux panes
  - catppuccin-tmux - Catppuccin Macchiato theme
- **Layout**: Status bar on top, centered window list

#### `slides/`
Documentation and resources for the Slides CLI presentation tool:
- **`CLAUDE.md`**: Complete reference guide for creating terminal-based presentations
- **`skills/`**: Directory for storing presentation skill templates (currently empty)

---

## Quick Setup (New Machines)

### Automated Installation

The fastest way to set up a new machine:

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Run the installation script
./install.sh
```

**That's it!** The script will:
- ✅ Detect your OS (macOS or Linux)
- ✅ Install all required packages
- ✅ Set up programming languages (Go, Node.js, Python)
- ✅ Install CLI tools (ripgrep, fd, bat, tree, jq)
- ✅ Install development tools (Neovim, tmux, slides)
- ✅ Install terminal emulator (Ghostty/Alacritty)
- ✅ Set up Zsh with oh-my-zsh and plugins
- ✅ Install tmux plugin manager
- ✅ Stow all dotfile packages

### What Gets Installed

**Programming Languages:**
- Go
- Node.js (via nvm - Node Version Manager)
- Python 3

**CLI Tools:**
- ripgrep (modern grep)
- fd (modern find)
- bat (cat with syntax highlighting)
- tree (directory visualization)
- jq (JSON processor)
- GNU Stow (dotfile manager)

**Development Tools:**
- Neovim (text editor)
- tmux (terminal multiplexer)
- Git
- slides (terminal presentation tool)

**Terminal Emulators:**
- Ghostty (macOS)
- Alacritty (macOS/Linux)

**Shell:**
- Zsh with oh-my-zsh
- zsh-syntax-highlighting plugin
- zsh-autosuggestions plugin

---

## Manual Installation

If you prefer to install manually or customize the process:

### Prerequisites
- macOS or Linux (Ubuntu/Debian/Arch)
- Git

### Step 1: Clone Repository
```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
```

### Step 2: Run OS-Specific Script

**macOS:**
```bash
./scripts/install-macos.sh
```

**Linux:**
```bash
./scripts/install-linux.sh
```

### Step 3: Post-Install Actions

After running the installation script:

**1. Restart your terminal** or source the new configuration:
```bash
source ~/.zshrc
```

**2. Install tmux plugins:**
Open tmux and press `Ctrl+a` + `I` to install plugins

**3. Open Neovim:**
```bash
nvim
```
lazy.nvim will automatically install configured plugins on first launch

**4. (Linux only) Log out and back in** if zsh was just installed to apply shell change

### Uninstalling Packages
To remove symlinks for a package:
```bash
cd ~/.dotfiles
stow -D zsh              # Remove zsh package symlinks
stow -D alacritty-config # Remove alacritty symlinks
```

### Restowing After Updates
After pulling updates from the repository:
```bash
cd ~/.dotfiles
stow -R zsh              # Restow zsh package
# or restow everything
stow -R */
```

---

## Package Management with Brewfile (macOS)

The repository includes a `Brewfile` for declarative package management on macOS using Homebrew Bundle.

### Using the Brewfile

**Install all packages from Brewfile:**
```bash
cd ~/.dotfiles
brew bundle install
```

**Update Brewfile with currently installed packages:**
```bash
cd ~/.dotfiles
brew bundle dump --force
```

**Remove packages not in Brewfile:**
```bash
cd ~/.dotfiles
brew bundle cleanup
```

**Check what would be installed:**
```bash
cd ~/.dotfiles
brew bundle check
```

### Adding Packages

Edit the `Brewfile` directly:

```ruby
# For command-line tools
brew "package-name"

# For GUI applications
cask "application-name"

# For additional taps
tap "user/repository"
```

Then run `brew bundle install` to install the new packages.

### Brewfile Structure

The Brewfile is organized into sections:
- **Programming Languages**: Go, Python
- **CLI Tools**: ripgrep, fd, bat, tree, jq, stow
- **Development Tools**: neovim, tmux, git
- **Terminal Emulators**: ghostty, alacritty
- **Additional Tools**: Notes for items installed via scripts

### Best Practices

1. **Keep Brewfile in sync**: Run `brew bundle dump --force` periodically to keep it updated
2. **Commit changes**: Add and commit Brewfile changes to track package additions/removals
3. **Document special cases**: Use comments for packages with special installation requirements
4. **Test on clean system**: Verify your Brewfile works on a fresh installation

---

## Key Features & Custom Functions

### Tmux Session Management

**`ts [session-name]`** - Smart tmux session handler
- Creates new session with VIM, server, and claude windows if doesn't exist
- Attaches to existing session
- Switches between sessions when inside tmux
- Defaults to current directory name as session name

**`ta <session-name>`** - Attach to tmux session

**`tk <session-name>`** - Kill tmux session

**`tl`** - List tmux sessions

### Git Workflow Helpers

**`push <branch>`** - Push and set upstream in one command
```bash
push feature-branch  # Equivalent to: git push --set-upstream origin feature-branch
```

**`remote_checkout <branch>`** - Checkout remote branch locally
```bash
remote_checkout feature-branch  # Fetches and creates local tracking branch
```

**`softReset <branch>`** - Squash all commits since branching
```bash
softReset main  # Soft reset to common ancestor with main, keeping changes staged
```

**`work-tree <feature-name>`** - Create git worktree for parallel development
```bash
work-tree new-api  # Creates ../repo-new-api with feature/new-api branch from develop
```
- Creates new worktree from develop branch
- Symlinks node_modules to save space
- Perfect for working on multiple features simultaneously

### Docker Shortcuts

- **`d`** - Alias for `docker`
- **`dc`** - Alias for `docker compose`
- **`drm`** - Remove all stopped containers
- **`drmi`** - Remove dangling images

### Utility Functions

**`killport <port>`** - Kill process running on specified port
```bash
killport 3000
```

**`count [directory]`** - Count files in directory
```bash
count src/  # Returns number of files
```

**`gitExclude <pattern>`** - Add pattern to local git exclude
```bash
gitExclude "*.local"
```

**`note`** / **`notes`** - Open daily note in Neovim
```bash
note  # Opens ~/notes/YYYY-MM-DD.md
```

### Shell Aliases

**Navigation & Commands:**
```bash
vim='nvim'       # Use Neovim instead of Vim
v='nvim'         # Quick Neovim shortcut
clc/cls='clear'  # Multiple clear aliases (including typos: clera, celar, ckear)
dot='cd ~/.dotfiles'
loads='cd ~/loads'
src='source ~/.zshrc'  # Reload shell configuration
```

**Enhanced Tools:**
```bash
grep='rg'        # Use ripgrep
find='fd'        # Use fd
diff='nvim -d'   # Use Neovim for diffs
dif='diff'       # Common typo fix
pretty="jq '.'"  # Pretty-print JSON
lt='du -sh * | sort -h'  # List by size, sorted
```

**Git Shortcuts:**
```bash
got='git'        # Common typo fix
pull='git pull'
fetch='git fetch'
checkout='git checkout'
branch='git branch'
```

**Python:**
```bash
python='python3'
pip='pip3'
py='python'
py-env='source .venv/bin/activate'
```

---

## Environment Configuration

### PATH Additions
The configuration adds the following to your PATH:
- `/usr/local/go/src` - Go source
- `/Applications/Postgres.app/Contents/Versions/13/bin` - PostgreSQL
- `$HOME/.bun/bin` - Bun runtime
- `$HOME/.cargo/bin` - Rust tools (via cargo env)
- `$HOME/go/bin` - Go binaries
- `$HOME/scripts` - Personal scripts directory

### Runtime Managers
- **nvm** - Node Version Manager (loaded in .localrc)
- **rustup** - Rust toolchain manager
- **Bun** - JavaScript runtime and package manager

### Default Editor
```bash
export EDITOR='nvim'  # Both local and SSH sessions
```

---

## Syncing Across Computers

### Initial Setup on New Machine
1. Clone this repository to `~/.dotfiles`
2. Run `./install.sh`
3. That's it! The script handles everything automatically

The installation script will:
- Install all packages (languages, tools, terminals)
- Set up Zsh with oh-my-zsh and plugins
- Install tmux plugin manager
- Stow all dotfile packages
- Create `.localrc` for machine-specific config

### Updating Configurations
**On any machine:**
```bash
cd ~/.dotfiles
git pull

# If packages were added to Brewfile (macOS only)
brew bundle install

# Restow any changed packages
stow -R */

# Reload shell config
source ~/.zshrc
```

**After making changes:**
```bash
cd ~/.dotfiles

# Update Brewfile with new packages (macOS only)
brew bundle dump --force  # Optional: if you installed new packages

git add -A
git commit -m "Description of changes"
git push
```

### Machine-Specific Settings
All machine-specific configurations should go in `~/.localrc`, which is:
- Created during installation
- Sourced by `.zshrc`
- **NOT** tracked in the repository

Use `.localrc` for:
- Company-specific aliases (e.g., currently sources `~/.shift4rc`)
- Local PATH additions
- API keys and secrets
- Machine-specific environment variables

---

## Troubleshooting

### Installation script fails on macOS
**Issue**: Homebrew installation fails or commands not found

**Solution**:
```bash
# For Apple Silicon Macs, manually add Homebrew to PATH
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile

# Then re-run the installation
cd ~/.dotfiles && ./install.sh
```

### Installation script fails on Linux
**Issue**: Package manager errors or permission denied

**Solution**:
```bash
# Update package lists first
sudo apt update  # Ubuntu/Debian
# or
sudo pacman -Sy  # Arch

# Ensure you have sudo privileges
# Then re-run the installation
cd ~/.dotfiles && ./scripts/install-linux.sh
```

### Brewfile installation fails
**Issue**: `brew bundle` command not found or fails

**Solution**:
```bash
# Install Homebrew Bundle tap
brew tap homebrew/bundle

# Then try again
cd ~/.dotfiles && brew bundle install
```

### nvm or Node.js not working after installation
**Issue**: `nvm: command not found` or `node: command not found`

**Solution**:
```bash
# Restart your terminal or source the configuration
source ~/.zshrc

# If still not working, manually load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Then install Node.js
nvm install --lts
nvm use --lts
```

### Zsh plugins not working
Ensure oh-my-zsh is installed and plugins are available:
```bash
ls ~/.oh-my-zsh/custom/plugins/
# If missing, re-run the installation script
cd ~/.dotfiles && ./install.sh
```

### Tmux plugins not loading
Install TPM and plugins:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
# Then inside tmux: Ctrl+a + I
```

### Neovim LSP not working
Ensure language servers are installed:
```bash
# Check if Mason is managing LSPs in Neovim
nvim
:Mason
```

### Symlinks broken after stow
Re-run stow for the affected package:
```bash
cd ~/.dotfiles
stow -D zsh        # Remove old symlinks
stow zsh           # Create new symlinks
# or use restow
stow -R zsh
```

### Colors not displaying correctly
Ensure TERM is set correctly:
```bash
echo $TERM  # Should show xterm-256color
```
Check that your terminal emulator supports 256 colors or true color.

### Linux: fd or bat command not found
On Ubuntu/Debian, the commands are named differently:
```bash
# Use the aliases from .localrc, or create symlinks manually
sudo ln -s $(which fdfind) /usr/local/bin/fd
sudo ln -s $(which batcat) /usr/local/bin/bat
```
The installation script should handle this automatically.

---

## Maintenance

### Regular Updates
```bash
# Update dotfiles
cd ~/.dotfiles && git pull

# Update oh-my-zsh
omz update

# Update tmux plugins
# Inside tmux: Ctrl+a + U

# Update Neovim plugins
nvim +Lazy sync
```

### Backup Strategy
This repository IS your backup. Commit and push changes regularly:
```bash
cd ~/.dotfiles
git add -A
git commit -m "Update configs"
git push
```

---

# Appendix: GNU Stow Reference Guide

This repository uses GNU Stow for managing dotfiles. Here's a complete reference.

## What is GNU Stow?

GNU Stow is a symlink farm manager that makes it easy to manage dotfiles. Each directory is a "package" that mirrors the structure from `$HOME`.

## Benefits of Stow
- Clean package-based organization
- Easy to install/uninstall individual configs
- No custom install scripts needed
- Portable across different systems
- Per-package version control

## Stow Package Structure

Each package directory must mirror the target directory structure from `$HOME`:

**For files in home directory:**
```
package-name/
   .filename
```

**For files in ~/.config/:**
```
package-name/
   .config/
       app-name/
           config-files
```

## Current Stow Structure

This repository follows the proper Stow conventions:

```
~/.dotfiles/
├── alacritty-config/       # → ~/.config/alacritty/
│   └── .config/
│       └── alacritty/
│           ├── alacritty.yml
│           └── *.yml (themes)
├── ghostty-config/         # → ~/.config/ghostty/
│   └── .config/
├── git-config/             # → ~/
│   ├── .git-prompt.sh
│   └── .gitignore_global
├── nvim-config/            # → ~/.config/nvim/
│   └── .config/
│       └── nvim/
│           ├── init.lua
│           └── lua/
├── zsh/                    # → ~/
│   ├── .zshrc
│   └── .localrc
└── tmux/                   # → ~/
    └── .tmux.conf
```

## Stow Commands

```bash
# Install all packages
cd ~/.dotfiles
stow */

# Install specific package
stow zsh

# Uninstall package
stow -D zsh

# Restow (useful after updates)
stow -R zsh

# Dry run (preview changes)
stow -n -v zsh

# Verbose output
stow -v zsh
```

## Adding New Configurations with Stow

### Package Naming Convention
This repository uses a specific naming pattern:
- For `.config` packages: `app-config` (e.g., `alacritty-config`, `nvim-config`)
- For home directory packages: use simple names (e.g., `zsh`, `tmux`, `git-config`)
- Keep names consistent with the application

### Examples

**Adding a new app config (goes in ~/.config/):**
```bash
cd ~/.dotfiles
mkdir -p kitty-config/.config/kitty
echo "content" > kitty-config/.config/kitty/kitty.conf
stow kitty-config
```

**Adding a new home directory config:**
```bash
cd ~/.dotfiles
mkdir -p bash
echo "content" > bash/.bashrc
stow bash
```

**Adding to an existing package:**
```bash
cd ~/.dotfiles
echo "new-content" > zsh/.zsh_aliases
stow -R zsh  # Restow to update symlinks
```

### Testing Before Committing

Always test stow before committing:

```bash
# Dry run to see what would happen
stow -n -v package-name

# If dry run looks good, actually stow it
stow package-name

# Verify the symlinks
ls -la ~/target/file
```

## Important Stow Rules

1. **Never create nested .dotfiles references** - Files should be organized as if they're being placed from `$HOME`
2. **Match the exact target structure** - If a file goes in `~/.config/app/`, create `package/.config/app/`
3. **One package per application** - Don't mix multiple applications in one package
4. **Test with stow before committing** - Always verify symlinks are created correctly
5. **Use --adopt carefully** - Only use `stow --adopt` if you want stow to move existing files into the repository

## Common Stow Mistakes to Avoid

❌ **Wrong:**
```
package/
   .dotfiles/
       .config/
           app/
```

✅ **Correct:**
```
package/
   .config/
       app/
```

---

❌ **Wrong:**
```
shell/
   zsh/
      .zshrc
   bash/
       .bashrc
```

✅ **Correct:**
```
zsh/
   .zshrc

bash/
   .bashrc
```

## Workflow for Creating New Stow Packages

1. **Create package directory** with proper structure
   ```bash
   mkdir -p package-name/.config/app
   ```

2. **Add configuration files**
   ```bash
   cp ~/existing-config package-name/.config/app/
   ```

3. **Test with dry run**
   ```bash
   stow -n -v package-name
   ```

4. **Actually stow the package**
   ```bash
   stow package-name
   ```

5. **Verify symlinks**
   ```bash
   ls -la ~/path/to/file
   ```

6. **Commit to git**
   ```bash
   git add package-name
   git commit -m "Add package-name configuration"
   ```

## Additional Stow Notes

- Stow creates symlinks from `~` to `~/.dotfiles/package/`
- Stow will NOT overwrite existing files (use `--adopt` to move them in)
- Each package can be independently installed/uninstalled
- Keep machine-specific config in separate files (e.g., `.localrc` in the `zsh` package)
- The `.tmux/plugins/` directory is tracked but plugins are managed by TPM, not Stow
- Slides documentation is kept in the repository but not stowed (reference only)

---

## Additional Resources

### Official Documentation
- **Neovim**: https://neovim.io/
- **Oh-My-Zsh**: https://ohmyz.sh/
- **Tmux**: https://github.com/tmux/tmux
- **Alacritty**: https://alacritty.org/
- **Ghostty**: https://ghostty.org/
- **GNU Stow**: https://www.gnu.org/software/stow/

### Themes & Plugins
- **Catppuccin Theme**: https://github.com/catppuccin/tmux
- **vim-tmux-navigator**: https://github.com/christoomey/vim-tmux-navigator
- **zsh-syntax-highlighting**: https://github.com/zsh-users/zsh-syntax-highlighting
- **zsh-autosuggestions**: https://github.com/zsh-users/zsh-autosuggestions

### Tools & Utilities
- **ripgrep (rg)**: https://github.com/BurntSushi/ripgrep
- **fd**: https://github.com/sharkdp/fd
- **jq**: https://stedolan.github.io/jq/
- **Slides CLI**: https://github.com/maaslalani/slides - See `slides/CLAUDE.md` for complete documentation

### Related Reading
- **GNU Stow Tutorial**: https://www.gnu.org/software/stow/manual/stow.html
- **Dotfiles Guide**: https://dotfiles.github.io/
- **Tmux Cheat Sheet**: https://tmuxcheatsheet.com/
