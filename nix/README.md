# Linux VMs with Nix and Home Manager

One command on each VM, with a shared package definition and dependency lock.
This is a **user environment for existing Linux VMs**, not an OS installer.
Run the installation commands below **on the destination VM**, never on the Mac.
The helper refuses macOS and root before it invokes Nix or changes files.

## What is managed

| Area | Installed by this profile |
| --- | --- |
| Languages | Go, Node.js 24/npm, Python/uv, Java 21, Rust/Cargo/rustfmt/Clippy |
| Containers | Docker CLI, Compose, Buildx, Helm, kind, kubectl, k9s |
| Shell | Zsh, Oh My Zsh, robbyrussell theme, autosuggestions, syntax highlighting, fzf, zoxide, Carapace |
| Utilities | Git, gh, Stow, ripgrep, fd, bat, jq, tree, eza, curl, wget, SSH, GnuPG, slides |
| Build tools | GCC, Make, CMake, pkg-config, archive tools, ShellCheck, shfmt, nixfmt |
| tmux | Existing layout, session/worktree helpers, Ctrl+a prefix, Dracula and navigation plugins |
| Neovim | Core existing settings/keybindings, Dracula, Grapple, Telescope, completion, formatting, Git/branch review, database UI, parsers and language servers |

The editor includes servers for Go/templ, Python, JS/TS, Tailwind, HTML/CSS/HTMX,
YAML/Helm, Rust, Java, Lua and Nix. Formatters come from Nix too. Plugins and
parsers are installed with the generation, so the VM does not run Lazy, Mason,
TPM, nvm, or plugin downloads at first startup. The Nix profile has its own editor
entry point and does not consume the legacy `lazy-lock.json`.

The optional AI integrations, private no-go fork, and SonarQube configuration
from the legacy editor are not enabled in this profile. They need explicit Nix
packages/configuration and, where applicable, user authentication. Terminal
emulators and Nerd Fonts belong on the SSH client workstation.

Nix/Home Manager owns these files on the VM: shell startup files, `.localrc`,
`.tmux.conf`, Git configuration/helpers, Neovim configuration, k9s configuration,
and Docker CLI plugin links. **Do not also Stow those files on the same VM.**
Stow remains installed for other packages; the existing macOS setup is separate.

## Install on each VM

Run this one command as your normal user on an Ubuntu 22.04/24.04/26.04 or
Debian 12/13 VM with systemd and sudo access:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/guevarez30/.dotfiles/raft-vm/scripts/install-vm.sh)
```

It installs host prerequisites, clones/updates the `raft-vm` branch, installs and
starts Docker Engine, installs Nix without interactive installer questions,
builds and activates the full package/dotfile environment, sets Zsh as your login
shell, and verifies the tools. It detects your username, home directory and
architecture. **No profile edits or separate install commands are needed.**

You may be prompted for your sudo password. Reconnect SSH when it finishes to
pick up the login shell and Docker group. GitHub authentication remains personal:
run `gh auth login` when you need it.

The same command works on both x86_64 and ARM64. It reuses existing Nix and
Docker installations, updates a clean checkout with a fast-forward pull, and
preserves local checkout changes. If `~/.dotfiles` is on another branch, it stops
instead of switching your checkout. Rerun the command after correcting any
reported error. Existing dotfile conflicts get unique `.pre-nix-TIMESTAMP-PID`
backups during activation.

Docker group membership grants root-equivalent access. Published container ports
can bypass UFW rules. The bootstrap leaves SSH, firewall policy and OS upgrades
to your VM provisioning process. It creates no Kubernetes clusters and does not
copy authentication credentials. The VM needs Internet access and several GB of
free disk space, plus room for your container images.

Upstream references: [Nix installation](https://nixos.org/download/),
[Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/),
[Docker on Debian](https://docs.docker.com/engine/install/debian/).

## Optional per-VM customization

The default `current` profile detects machine identity. The helper uses
`--impure` only for the three identity variables; packages and plugin versions
still come from the committed `flake.lock`. Nothing is written to `hosts.nix`
by installation.

For a VM that needs extra packages or Git identity settings, add a named entry
to [`hosts.nix`](hosts.nix):

```nix
work-vm = {
  system = "x86_64-linux";
  username = "ubuntu";
  homeDirectory = "/home/ubuntu";
  gitName = "Your Name";
  gitEmail = "you@example.com";
  modules = [ ({ pkgs, ... }: { home.packages = [ pkgs.yq-go ]; }) ];
};
```

Then apply that named profile with `bash scripts/nix-vm.sh switch work-vm`.
Use the named helper command for later updates to retain its overrides; the
one-command bootstrap always applies the shared `current` profile.

Keep credentials out of Nix files: Nix store contents are readable by other
local users. Optional private shell settings can go in `~/.raftrc`.

## Optional maintenance commands

After installation, the helper is available in `~/.dotfiles`:

```bash
bash scripts/nix-vm.sh build     # Prepare the current profile without activation
bash scripts/nix-vm.sh switch    # Apply the current profile
bash scripts/nix-vm.sh verify    # Check tools, shell startup and Docker access
```

The helper refuses macOS and root. These commands require the installed Nix;
use the one-command bootstrap above on a new VM. In Neovim, `:checkhealth`
provides more detail. Use `uv venv` for Python projects and local dependencies
for Node projects; Nix-managed installations are read-only.

For project clusters, keep a project-specific kind config and pin a node image
digest supported by the locked kind version. Select kubectl within one minor
version of your cluster's API server, and check the Helm major version required
by your projects. Override packages in a host module when needed.

## Updates and rollback

Add shared packages in [`packages.nix`](packages.nix); use host modules for
exceptions. Rebuild and switch each VM after pulling the change. Rerunning
`switch` with the same configuration converges on the same generation contents.

To deliberately update package/plugin versions on a Linux development VM:

```bash
nix --extra-experimental-features 'nix-command flakes' flake update
bash scripts/nix-vm.sh build
bash scripts/nix-vm.sh switch
bash scripts/nix-vm.sh verify
```

Review and commit `flake.lock` once, then pull that same lockfile on the other
VMs. Do not run `flake update` independently on each machine. Normal build/switch
commands refuse to rewrite the lock. `home.stateVersion` is a compatibility
baseline, not a version to bump when updating packages.

Run `home-manager generations` to list previous generations. To roll back,
run the `activate` script in the previous generation's printed store path.
Keep old generations until you are happy with an upgrade; garbage collection
can remove rollback targets. Home Manager rollback covers packages/configuration,
not databases, container data, OS packages, or files in your projects.
