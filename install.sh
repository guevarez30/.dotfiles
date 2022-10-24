# install nix
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
  nixpkgs.rustup \
  nixpkgs.rust-analyzer 

# Install Rust
rustup update --quiet

# Install Alacrity 
cargo install alacritty

# Install Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
nvm install node

touch ~/.localrc
source ~/.bashrc
