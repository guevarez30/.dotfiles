#install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# install packages
nix-env -iA \
  nixpkgs.git \
  nixpkgs.neovim \
  nixpkgs.yarn \
  nixpkgs.bat  \
  nixpkgs.i3 \
  nixpkgs.rofi \
  nixpkgs.picom \

touch ~/.localrc


# Create Links
rm ~/.bashrc
ln -s ~/.dotfiles/bash/.bashrc ~/.bashrc
ln -s ~/.dotfiles/git/* ~/

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.bashrc

## Install Alacrity
cargo install alacritty

## Install rust-analyzer
git clone https://github.com/rust-lang/rust-analyzer.git && cd rust-analyzer
cargo xtask install --server

# Install Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
source ~/.bashrc

nvm install node
