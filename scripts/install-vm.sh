#!/usr/bin/env bash
# One-command bootstrap for a fresh Ubuntu/Debian development VM.
set -euo pipefail

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
step() { printf '\n==> %s\n' "$*"; }

case ${1:-} in
  --help|-h)
    printf 'Usage: bash scripts/install-vm.sh\nInstalls Nix, Docker and the full dotfiles environment for the current Linux user.\n'
    exit 0
    ;;
  '') ;;
  *) die "No arguments needed. Run as the VM's normal user." ;;
esac

# Reject the Mac and unsupported hosts before sudo, downloads, or filesystem writes.
[[ $(uname -s) == Linux ]] || die "Run this on the Linux VM, not macOS."
[[ $(id -u) -ne 0 ]] || die "Run as the VM's normal user without sudo; the script requests sudo itself."
[[ -r /etc/os-release ]] || die "Cannot identify the Linux distribution."
# shellcheck disable=SC1091
source /etc/os-release
case "$ID:${VERSION_ID:-}" in
  ubuntu:22.04|ubuntu:24.04|ubuntu:26.04|debian:12|debian:13) ;;
  *) die "Supported hosts: Ubuntu 22.04/24.04/26.04 or Debian 12/13." ;;
esac
case $(uname -m) in
  x86_64|aarch64|arm64) ;;
  *) die "Supported architectures: x86_64 and ARM64." ;;
esac
[[ -d /run/systemd/system ]] || die "A running systemd VM is required."
command -v sudo >/dev/null 2>&1 || die "The VM user needs sudo access."

vm_user=$(id -un)
repo="$HOME/.dotfiles"
step "Authenticating sudo for the install"
sudo -v
# Keep the existing sudo authorization alive while Nix downloads/builds packages.
(
  while sleep 45; do sudo -n -v || exit; done
) &
sudo_keepalive=$!
scratch=$(mktemp -d)
cleanup() {
  kill "$sudo_keepalive" 2>/dev/null || true
  rm -rf -- "$scratch"
}
trap cleanup EXIT
trap 'printf "Install stopped at line %s. Fix the reported error and rerun the same command.\n" "$LINENO" >&2' ERR

step "Installing host prerequisites"
sudo env DEBIAN_FRONTEND=noninteractive apt-get update
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ca-certificates curl git xz-utils openssh-client

step "Preparing the dotfiles checkout"
if [[ -d $repo/.git ]]; then
  [[ $(git -C "$repo" branch --show-current) == raft-vm ]] || \
    die "$repo is on another branch; refusing to replace an existing checkout."
  if [[ -z $(git -C "$repo" status --porcelain) ]]; then
    git -C "$repo" pull --ff-only origin raft-vm
  else
    printf 'Keeping local changes in %s.\n' "$repo"
  fi
elif [[ -e $repo ]]; then
  die "$repo already exists and is not a Git checkout."
else
  git clone --branch raft-vm https://github.com/guevarez30/.dotfiles.git "$repo"
fi
[[ -f $repo/flake.lock && -f $repo/scripts/nix-vm.sh ]] || die "The checkout is missing the Nix configuration."

step "Installing Docker Engine"
# Reuse an existing Engine/service rather than replacing its packages or data.
if ! systemctl cat docker.service >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -fsSL --retry 3 \
    "https://download.docker.com/linux/$ID/gpg" -o "$scratch/docker.asc"
  sudo install -d -m 0755 /etc/apt/keyrings
  sudo install -m 0644 "$scratch/docker.asc" /etc/apt/keyrings/docker.asc
  cat > "$scratch/docker.sources" <<EOF
Types: deb
URIs: https://download.docker.com/linux/$ID
Suites: $VERSION_CODENAME
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
  sudo install -m 0644 "$scratch/docker.sources" /etc/apt/sources.list.d/docker.sources
  sudo env DEBIAN_FRONTEND=noninteractive apt-get update
  sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io
fi
sudo systemctl enable --now docker
getent group docker >/dev/null || sudo groupadd docker
sudo usermod -aG docker "$vm_user"

step "Installing Nix"
if ! command -v nix >/dev/null 2>&1 && [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  # shellcheck disable=SC1091
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
if ! command -v nix >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -fsSL --retry 3 \
    https://nixos.org/nix/install -o "$scratch/install-nix.sh"
  NIX_INSTALLER_YES=1 NIX_INSTALLER_NO_CHANNEL_ADD=1 \
    sh "$scratch/install-nix.sh" --daemon </dev/null
  # shellcheck disable=SC1091
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

step "Installing the full environment for $vm_user"
bash "$repo/scripts/nix-vm.sh" switch

step "Setting Zsh as the login shell"
shell_path="$HOME/.nix-profile/bin/zsh"
[[ -x $shell_path ]] || die "The Nix Zsh executable was not installed."
if ! grep -Fxq "$shell_path" /etc/shells; then
  printf '%s\n' "$shell_path" | sudo tee -a /etc/shells >/dev/null
fi
sudo usermod --shell "$shell_path" "$vm_user"

step "Verifying installed tools and Docker access"
# A fresh process gets the new Docker group immediately; the SSH session does not.
sudo -u "$vm_user" -H /usr/bin/env \
  PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin" \
  /bin/bash "$repo/scripts/nix-vm.sh" verify

printf '\nVM setup complete. Reconnect SSH to use Zsh and the new Docker group.\n'
printf 'GitHub authentication is separate: run gh auth login when needed.\n'
