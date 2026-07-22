# Some SSH/tmux entrypoints on this host start zsh as a login shell without
# immediately loading .zshrc. Force the interactive setup once per shell.
if [[ -o interactive ]]; then
  source "$HOME/.zshrc"
fi
