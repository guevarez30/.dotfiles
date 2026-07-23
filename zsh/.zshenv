# zsh reads this for every shell. Keep non-interactive shells light.
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Some SSH/tmux entrypoints on this host skip the normal .zshrc path.
# For interactive shells only, force .zshrc once.
if [[ -o interactive && -z "${_DOTFILES_ZSHRC_SOURCED:-}" && -r "$HOME/.zshrc" ]]; then
  source "$HOME/.zshrc"
fi
