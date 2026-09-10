{ pkgs }:
with pkgs; [
  # Languages and native build dependencies.
  go nodejs_24 python3 uv jdk21 rustc cargo rustfmt clippy
  gcc gnumake cmake pkg-config openssl

  # Containers and Kubernetes. Docker Engine is installed by the host OS.
  docker-client docker-compose docker-buildx kubernetes-helm kind kubectl k9s

  # Everyday terminal tools.
  git gh stow tmux curl wget cacert gnupg openssh
  ripgrep fd bat fzf jq tree eza zoxide carapace
  coreutils findutils gnugrep gnused gawk less which file
  unzip zip gnutar gzip xz ncurses procps iproute2 lsof
  shellcheck shfmt nixfmt slides

  # Language servers and formatters: supplied by Nix, never downloaded by Mason.
  gopls gotools templ pyright ruff isort autopep8
  typescript-language-server tailwindcss-language-server vscode-langservers-extracted
  yaml-language-server helm-ls htmx-lsp jdt-language-server rust-analyzer
  lua-language-server nil stylua prettier
];
