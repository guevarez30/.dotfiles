# install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# install packages
nix-env -iA \
  nixpkgs.git \
  nixpkgs.neovim \
  nixpkgs.yarn \
  nixpkgs.stow \
  nixpkgs.bat \
  nixpkgs.cmake \
  nixpkgs.llvm

# Stow
stow git
stow zsh
stow nvim


