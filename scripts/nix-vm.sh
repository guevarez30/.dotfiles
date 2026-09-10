#!/usr/bin/env bash
# Run on the destination Linux VM as the user named in nix/hosts.nix.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash scripts/nix-vm.sh <list|build|switch|verify> [profile]

  list             List the profiles in nix/hosts.nix.
  build PROFILE    Build the environment without activating it.
  switch PROFILE   Build, back up conflicting dotfiles, then activate.
  verify           Check tools, shell startup, and Docker access.

Requires Nix on a Linux VM. Never run this script with sudo.
EOF
}
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

action=${1:---help}
case "$action" in
  -h|--help) usage; exit 0 ;;
  list|verify) [[ $# -eq 1 ]] || die "Use --help for arguments." ;;
  build|switch)
    [[ $# -eq 2 && $2 =~ ^[a-zA-Z0-9_-]+$ ]] || die "Specify a profile from nix/hosts.nix."
    ;;
  *) usage >&2; exit 1 ;;
esac

# Before reading profiles, invoking Nix, creating files, or running activation.
[[ $(uname -s) == Linux ]] || die "Linux VM only; this script does not configure macOS."
[[ $(id -u) -ne 0 ]] || die "Run as the VM's normal user, without sudo."
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)

if ! command -v nix >/dev/null 2>&1; then
  # The multi-user installer makes Nix available in new shells. Support this
  # shell as well, without sourcing interactive user configuration.
  if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    # shellcheck disable=SC1091
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
fi
command -v nix >/dev/null 2>&1 || die "Install Nix on this VM first; see nix/README.md."
[[ -f $repo/flake.lock ]] || die "Missing flake.lock; use a complete checkout."
nix_cmd=(nix --extra-experimental-features 'nix-command flakes')

if [[ $action == list ]]; then
  "${nix_cmd[@]}" eval --json --no-write-lock-file "$repo#homeConfigurations" --apply builtins.attrNames
  exit
fi

if [[ $action == verify ]]; then
  # Use the activated profile, including its wrapped Neovim and Nix session PATH.
  export PATH="$HOME/.nix-profile/bin:$PATH"
  failed=0
  for tool in go docker helm kind kubectl gh nvim stow tmux zsh node npm python3 \
    cargo rustc java rg fd bat fzf jq k9s gopls helm_ls stylua prettier; do
    if command -v "$tool" >/dev/null 2>&1; then
      printf 'OK   %s: %s\n' "$tool" "$(command -v "$tool")"
    else
      printf 'FAIL %s is missing\n' "$tool" >&2
      failed=1
    fi
  done
  zsh -lic '[[ "$DOTFILES_NIX" == 1 ]]' || failed=1
  docker compose version || failed=1
  docker buildx version || failed=1
  if ! docker info >/dev/null 2>&1; then
    printf 'FAIL Docker daemon access: install/start Engine and log in again after group changes.\n' >&2
    failed=1
  fi
  exit "$failed"
fi

profile=$2
attr="$repo#homeConfigurations.\"$profile\""
expected_user=$("${nix_cmd[@]}" eval --raw --no-write-lock-file "$attr.config.home.username")
expected_home=$("${nix_cmd[@]}" eval --raw --no-write-lock-file "$attr.config.home.homeDirectory")
expected_system=$("${nix_cmd[@]}" eval --raw --no-write-lock-file "$attr.pkgs.stdenv.hostPlatform.system")
case $(uname -m) in
  x86_64) actual_system=x86_64-linux ;;
  aarch64|arm64) actual_system=aarch64-linux ;;
  *) die "Supported architectures: x86_64 and aarch64." ;;
esac
[[ $expected_system == "$actual_system" ]] || die "Profile expects $expected_system; VM is $actual_system."
if [[ $action == switch ]]; then
  [[ $expected_user == "$(id -un)" && $expected_home == "$HOME" ]] || \
    die "Profile targets $expected_user at $expected_home. Edit nix/hosts.nix for this user first."
fi

generation=$("${nix_cmd[@]}" build --no-write-lock-file --no-link --print-out-paths "$attr.activationPackage")
printf 'Built %s: %s\n' "$profile" "$generation"
if [[ $action == switch ]]; then
  # Preserve existing regular files and Stow symlinks. Never use force or --adopt.
  HOME_MANAGER_BACKUP_EXT="pre-nix-$(date -u +%Y%m%dT%H%M%SZ)-$$"
  export HOME_MANAGER_BACKUP_EXT
  "$generation/activate"
  printf '\nActivated %s. Backups use .%s\n' "$profile" "$HOME_MANAGER_BACKUP_EXT"
  printf 'Start a new shell, then run: bash scripts/nix-vm.sh verify\n'
fi
