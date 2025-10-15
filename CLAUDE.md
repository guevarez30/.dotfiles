# Unified Theme System

## Overview

This dotfiles repository uses a unified theme system that allows you to easily switch themes across both Neovim and tmux from a single source of truth.

## Design Decision

We chose **Option 2: Parallel Files** approach for the following reasons:

- **Simplicity**: Each tool uses its native configuration format (Lua for Neovim, Shell for tmux)
- **Maintainability**: No complex parsing logic needed
- **Flexibility**: Easy to add tool-specific customizations
- **Performance**: No runtime parsing overhead

## Directory Structure

```
~/.dotfiles/themes/
├── current-theme           # Contains the name of the active theme
├── load-tmux-theme.sh      # Dynamic loader script for tmux themes
├── shift4.lua              # Neovim theme definition for shift4
├── shift4.sh               # tmux theme definition for shift4
├── solarized-light.lua     # Neovim theme definition for Solarized Light
└── solarized-light.sh      # tmux theme definition for Solarized Light
```

## How It Works

### Theme Files

Each theme consists of two files:

1. **`<theme-name>.lua`** - Neovim theme definition
   - Returns a Lua table with `name`, `background`, `term` palette (16 colors), and `ui` colors
   - Used by colorscheme files in `nvim/colors/`

2. **`<theme-name>.sh`** - tmux theme definition
   - Exports shell environment variables with color values
   - Sourced by tmux configuration

### Current Theme Tracker

The file `~/.dotfiles/themes/current-theme` contains a single line with the name of the active theme (e.g., `solarized-light` or `shift4`).

### Neovim Integration

- **Colorscheme files**: `nvim/colors/<theme-name>.lua`
  - Each colorscheme file loads its theme definition from `themes/<theme-name>.lua`
  - Applies the colors to Neovim highlight groups

- **Auto-loader**: `nvim/after/plugin/colors.lua`
  - Reads `themes/current-theme` file
  - Automatically loads the corresponding colorscheme on Neovim startup

### Tmux Integration

- **Configuration**: `tmux/.tmux.conf`
  - Uses `run-shell` to execute `themes/load-tmux-theme.sh`
  - The loader script reads `themes/current-theme` and sources the corresponding `.sh` file
  - Dynamically applies colors to custom status line (session name, windows, time/date)
  - No external theme plugins required - all styling is done directly from theme variables

## How to Switch Themes

1. Edit `~/.dotfiles/themes/current-theme` and change the theme name:
   ```bash
   echo "solarized-light" > ~/.dotfiles/themes/current-theme
   # or
   echo "shift4" > ~/.dotfiles/themes/current-theme
   ```

2. Reload your configurations:
   - **Neovim**: Restart or run `:source ~/.config/nvim/init.lua`
   - **tmux**: Run `tmux source-file ~/.tmux.conf`

## Adding New Themes

To add a new theme:

1. Create two files in `~/.dotfiles/themes/`:
   - `<theme-name>.lua` for Neovim (see existing themes for structure)
   - `<theme-name>.sh` for tmux (export color variables)

2. Create a colorscheme file in `nvim/colors/<theme-name>.lua` that loads from `themes/<theme-name>.lua`

3. Update `themes/current-theme` with the new theme name

## Available Themes

- **shift4** - Custom dark theme with vibrant accent colors
- **solarized-light** - Solarized Light theme (iTerm2 variant)

## Notes

- The theme system is designed to be easily extensible
- Each theme maintains its own palette and UI colors independently
- The colorscheme files contain the highlight group definitions and can be customized per-theme
- Theme files are version-controlled, so you can easily revert or share themes
