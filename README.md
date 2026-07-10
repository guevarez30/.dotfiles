# Minimal Neovim Dotfiles

This branch is intentionally small. Neovim is the main setup, with optional tmux and zsh files kept for the development VM.

## What Is Included

```text
nvim-config/
└── .config/
    └── nvim/
        ├── init.lua
        ├── lazy-lock.json
        └── lua/
tmux/
└── .tmux.conf
zsh/
├── .zshrc
└── .localrc
```

The config uses `lazy.nvim` to install and manage plugins automatically when Neovim starts. It also includes one command to install the starter Tree-sitter parsers, language servers, and formatters.

## Install Neovim

Install these first:

- `git`, required by the plugin manager
- `stow`, used to symlink this config into your home directory
- `neovim`, the editor
- `ripgrep`, used by Telescope for fast text search
- `make` and a C compiler, used by Telescope's native fuzzy finder
- `go`, `docker`, and `helm` for Go and platform development

macOS:

```bash
brew install git stow neovim ripgrep make go helm docker
```

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install -y git stow neovim ripgrep build-essential golang-go docker.io
```

Arch:

```bash
sudo pacman -S git stow neovim ripgrep base-devel go docker helm
```

Mason installs editor tools. It does not replace system tools like the Docker daemon, Go runtime, or Helm CLI.

## Install This Config

Clone the repo:

```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
```

Preview what Stow will link:

```bash
stow -n -v nvim-config
```

Install the Neovim config:

```bash
stow nvim-config
```

That creates symlinks so Neovim reads this repo as:

```text
~/.config/nvim
```

To remove the symlinked config later:

```bash
stow -D nvim-config
```

To relink it after changes:

```bash
stow -R nvim-config
```

Optional VM shell setup:

```bash
stow tmux
stow zsh
```

Junior developers only need `stow nvim-config`. The `tmux` and `zsh` packages are included so this VM can keep its shell workflow.

The tmux config expects TPM for plugins:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

After opening tmux, press `Ctrl+a`, then `I` to install tmux plugins.

## First Start

Open Neovim:

```bash
nvim
```

On the first launch, `lazy.nvim` will download the plugins in this config. Let that finish, then install the starter tools:

```vim
:StarterInstall
```

Restart Neovim once the install finishes.

Useful commands:

```vim
:Lazy
:Mason
:StarterInstall
:checkhealth
```

- `:Lazy` opens the plugin manager.
- `:Mason` opens the tool installer for language servers and formatters.
- `:StarterInstall` installs the curated starter tools and Tree-sitter parsers.
- `:checkhealth` reports missing system tools or plugin issues.

## Core Concepts

### Tree-sitter

Tree-sitter is a parser that understands the structure of code. Neovim uses it for better syntax highlighting, indentation, and code context than plain text highlighting can provide.

In this config, Tree-sitter is handled by:

```text
nvim-config/.config/nvim/lua/plugins/treesitter.lua
```

These parsers are installed by `:StarterInstall`:

```text
Bash, CSS, Dockerfile, Go, Helm, HTML, JavaScript, JSON,
Lua, Markdown, Python, Rust, TSX, TypeScript, Vim, YAML
```

If highlighting looks wrong for a language, run:

```vim
:TSUpdate
```

### Mason

Mason installs external editor tools like language servers, linters, and formatters. These are separate programs that Neovim talks to.

`:StarterInstall` installs these language servers:

```text
css-lsp, docker-compose-language-service, dockerfile-language-server,
eslint-lsp, gopls, helm-ls, html-lsp, lua-language-server,
pyright, rust-analyzer, typescript-language-server, yaml-language-server
```

It also installs these formatters:

```text
autopep8, gofumpt, goimports, prettier, stylua
```

Open Mason with:

```vim
:Mason
```

If you need another language later, install more tools from inside Mason by searching for the tool name and pressing `i`.

### Telescope

Telescope is a fuzzy finder. It helps you quickly open files, search project text, and jump around code.

Important keymaps:

```text
<leader>p    find files
<leader>f    search text with ripgrep
```

The leader key is Space, so `<leader>p` means:

```text
Space, then p
```

## Language Setup

This config already wires Neovim to common language servers. The easiest way for a junior developer to start is:

1. Open Neovim with `nvim`.
2. Wait for `lazy.nvim` to finish installing plugins.
3. Run `:StarterInstall`.
4. Restart Neovim.
5. Run `:checkhealth` if something does not work.

Starter tools:

```text
Go:          gopls, goimports, gofumpt
Docker:      docker-langserver, docker-compose-langserver
Helm/YAML:   helm-ls, yaml-language-server
Lua:         lua-language-server, stylua
Python:      pyright, autopep8
JavaScript:  typescript-language-server, vscode-eslint-language-server, prettier
HTML/CSS:    vscode-html-language-server, vscode-css-language-server
Rust:        rust-analyzer
```

Some tools still require the language runtime or CLI to be installed. For example, Go tools require Go, Docker tooling needs Docker, Helm support expects the Helm CLI, Rust tools require Rust, and many JavaScript tools require Node.js/npm.

## Basic Workflow

Open a project:

```bash
cd path/to/project
nvim
```

Common keys:

```text
Space p     find a file
Space f     search text in the project
gd          go to definition
gr          find references
K           show documentation
E           show diagnostics for the current line
[d          previous diagnostic
]d          next diagnostic
Space rn    rename symbol
```

## Updating

Update plugins:

```vim
:Lazy update
```

Update Tree-sitter parsers:

```vim
:TSUpdate
```

Check health after updating:

```vim
:checkhealth
```

## Troubleshooting

If Neovim shows a short startup error and it disappears before you can read it, open the full message history:

```vim
:messages
```

For Mason install problems, open:

```vim
:MasonLog
```
