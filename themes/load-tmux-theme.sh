#!/bin/bash
# Load tmux theme from themes directory

DOTFILES="$HOME/.dotfiles"
THEME=$(cat "$DOTFILES/themes/current-theme" 2>/dev/null | tr -d '[:space:]')

if [ -z "$THEME" ]; then
  echo "No theme specified in current-theme file"
  exit 1
fi

THEME_FILE="$DOTFILES/themes/$THEME.sh"

if [ ! -f "$THEME_FILE" ]; then
  echo "Theme file not found: $THEME_FILE"
  exit 1
fi

# Source the theme file
source "$THEME_FILE"

# Apply theme to tmux
tmux set -g status-style "bg=$TMUX_POWER_BG,fg=$TMUX_POWER_FG"
tmux set -g status-bg "$TMUX_POWER_BG"
tmux set -g status-fg "$TMUX_POWER_FG"

# Status left (session name)
tmux set -g status-left "#[fg=$TMUX_POWER_BG,bg=$TMUX_POWER_G1,bold] #S #[default] "

# Status right (time and date)
tmux set -g status-right " #[fg=$TMUX_POWER_FG,bg=$TMUX_POWER_G2] %H:%M #[fg=$TMUX_POWER_BG,bg=$TMUX_POWER_G1,bold] %Y-%m-%d "

# Window status
tmux set -g window-status-separator " "
tmux set -g window-status-format "#[fg=$TMUX_POWER_FG,bg=$TMUX_POWER_BG] #I:#W "
tmux set -g window-status-current-format "#[fg=$TMUX_POWER_BG,bg=$TMUX_POWER_G1,bold] #I:#W "
