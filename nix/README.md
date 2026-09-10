# Linux VMs with Nix and Home Manager

One package definition, one dependency lock, and one small entry per VM/user.
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

## 1. Prepare the VM

Use a normal user with sudo access, an existing home directory, and a systemd
Linux VM. The examples below use Ubuntu/Debian. Both x86_64 and ARM64 profiles
are provided. Allow several GB of free space for the development environment
and more for Docker images/clusters.

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl git xz-utils
git clone https://github.com/guevarez30/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Install Nix once per VM using the upstream multi-user installer. Download it
first so you can inspect it before running it:

```bash
curl --proto '=https' --tlsv1.2 -fL https://nixos.org/nix/install -o /tmp/install-nix.sh
less /tmp/install-nix.sh
sh /tmp/install-nix.sh --daemon
```

Follow the installer's prompts, then log out and back in. The helper enables
`nix-command` and `flakes` for its own commands, without changing global Nix
settings. See [upstream installation requirements](https://nixos.org/download/).

### Docker Engine: one-time host setup

Home Manager supplies the Docker **client**, not a root-owned system daemon.
Install Docker Engine using the official repository for your actual distro:
[Ubuntu](https://docs.docker.com/engine/install/ubuntu/) or
[Debian](https://docs.docker.com/engine/install/debian/). Follow the repository
setup there, then install the Engine packages and start the service:

```bash
# Only after configuring the official Docker APT repository:
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
```

The Docker group grants root-equivalent access. Log out and back in for group
membership to take effect. If you prefer rootless Docker, use Docker's rootless
setup instead. Keep SSH, firewall rules, OS updates and users under your VM/OS
provisioning process. Docker-published ports can bypass UFW rules; account for
that before publishing services. [Docker post-installation guidance](https://docs.docker.com/engine/install/linux-postinstall/)

## 2. Define your machines

Edit [`hosts.nix`](hosts.nix). Profile names are labels; they do not change the
machine's hostname. Use the actual username/home directory from `id -un` and
`echo "$HOME"`. `uname -m` maps to `x86_64-linux` or `aarch64-linux`:

```nix
{
  work-vm = {
    system = "x86_64-linux";
    username = "ubuntu";
    homeDirectory = "/home/ubuntu";
    gitName = "Your Name";
    gitEmail = "you@example.com";
  };
  arm-lab = {
    system = "aarch64-linux";
    username = "taylor";
    homeDirectory = "/home/taylor";
    modules = [
      ({ pkgs, ... }: { home.packages = [ pkgs.yq-go ]; })
    ];
  };
}
```

Commit the configuration and lockfile to your dotfiles repo and check out the
same commit on each VM. Nix flakes in a Git checkout only see tracked files;
stage new Nix files before building during development. Keep credentials,
private keys and tokens out of all Nix files: Nix store contents are readable
by other local users. Optional machine-only shell settings can go in
`~/.raftrc`, which is sourced only when present.

## 3. Build and apply on each VM

```bash
cd ~/.dotfiles
bash scripts/nix-vm.sh list
bash scripts/nix-vm.sh build work-vm
bash scripts/nix-vm.sh switch work-vm
```

Use `arm-lab` on the ARM machine. The helper checks architecture; switching also
checks username and home directory. `build` prepares packages without activating
dotfiles. `switch` activates as the current user and backs up conflicting files
or Stow links with a unique `.pre-nix-TIMESTAMP-PID` suffix. It does not overwrite
the files those old symlinks point to. Existing Nix-managed files update normally.
If activation stops on a conflict, inspect the reported paths and rerun; do not
use `stow --adopt` or delete your old configuration blindly.

Start Zsh after activation:

```bash
exec "$HOME/.nix-profile/bin/zsh" -l
```

Changing the login shell is a separate, optional host setting. If desired, add
the stable profile path to `/etc/shells` and use `chsh`:

```bash
shell_path="$HOME/.nix-profile/bin/zsh"
command grep -Fxq "$shell_path" /etc/shells || printf '%s\n' "$shell_path" | sudo tee -a /etc/shells
chsh -s "$shell_path"
```

## 4. Verify and authenticate

```bash
bash scripts/nix-vm.sh verify
go version
nvim --version
helm version --short
kubectl version --client
gh auth login
```

Verification checks command availability, Zsh startup, Compose/Buildx, and
access to the Docker daemon. It does not create a cluster,
run containers, or require GitHub authentication. In Neovim, `:checkhealth` gives
additional detail. Use `uv venv` for Python projects; install project-specific
Node packages locally rather than writing into Nix's read-only installation.

For an end-to-end container/cluster check, run this explicitly on the VM:

```bash
docker run --rm hello-world
kind create cluster --name dotfiles-smoke --wait 120s
kubectl --context kind-dotfiles-smoke get nodes
kind delete cluster --name dotfiles-smoke
```

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
bash scripts/nix-vm.sh build work-vm
bash scripts/nix-vm.sh switch work-vm
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
