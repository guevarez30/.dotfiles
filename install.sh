# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# install packages
nix-env -iA \
  nixpkgs.zsh \
  nixpkgs.antibody \
  nixpkgs.git \
  nixpkgs.neovim \
  nixpkgs.yarn \
  nixpkgs.stow \
  nixpkgs.bat

# Stow
stow git
stow zsh
stow nvim

# Set default shell to zsh
command -v zsh | sudo tee -a /etc/shells

# Use zsh as default shell
sudo chsh -s $(which zsh) $USER

# Set zsh plugins
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh
