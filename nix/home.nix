{ config, lib, pkgs, host, ... }:
let
  # Reuse the terminal layout; Nix provides plugins instead of TPM.
  tmuxConfig = lib.concatStringsSep "\n" (builtins.filter
    (line: !(lib.hasInfix "@plugin " line || lib.hasInfix "/tpm/tpm" line))
    (lib.splitString "\n" (builtins.readFile ../tmux/.tmux.conf)));
in {
  imports = [ ./neovim.nix ];

  assertions = [
    { assertion = pkgs.stdenv.isLinux; message = "This profile is for Linux VMs."; }
    { assertion = lib.hasPrefix "/" host.homeDirectory; message = "Use an absolute homeDirectory."; }
  ];
  home = {
    inherit (host) username homeDirectory;
    # Compatibility baseline, not a package version. Do not bump during upgrades.
    stateVersion = "26.05";
    packages = import ./packages.nix { inherit pkgs; };
    sessionVariables = {
      DOTFILES_NIX = "1";
      EDITOR = "nvim";
      VISUAL = "nvim";
      GOPATH = "${host.homeDirectory}/go";
      K9S_CONFIG_DIR = "${config.xdg.configHome}/k9s";
    };
    sessionPath = [ "${host.homeDirectory}/.local/bin" "${host.homeDirectory}/go/bin" ];
    file = {
      ".localrc".source = ../zsh/.localrc;
      ".git-prompt.sh".source = ../git-config/.git-prompt.sh;
      ".gitignore_global".source = ../git-config/.gitignore_global;
      ".tmux.conf".text = tmuxConfig + ''

        set -g default-shell "${pkgs.zsh}/bin/zsh"
        set -g default-command "exec ${pkgs.zsh}/bin/zsh -il"
        set -s set-clipboard on
        run-shell ${pkgs.tmuxPlugins.vim-tmux-navigator.rtp}
        run-shell ${pkgs.tmuxPlugins.dracula.rtp}
      '';
    };
  };

  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
  xdg.enable = true;
  xdg.configFile."k9s".source = ../k9s-config/.config/k9s;
  xdg.configFile."tmux".source = ../tmux/.config/tmux;
  # Docker CLI discovers these without modifying /usr or the daemon's config.
  home.file.".docker/cli-plugins/docker-compose".source = "${pkgs.docker-compose}/bin/docker-compose";
  home.file.".docker/cli-plugins/docker-buildx".source = "${pkgs.docker-buildx}/bin/docker-buildx";

  programs.git = {
    enable = true;
    settings = {
      core.excludesFile = "${host.homeDirectory}/.gitignore_global";
    } // lib.optionalAttrs (host ? gitName) { user.name = host.gitName; }
      // lib.optionalAttrs (host ? gitEmail) { user.email = host.gitEmail; };
  };
  # Makes Nix's session environment available from the distro's default Bash too.
  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    dotDir = host.homeDirectory;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "web-search" "sudo" ];
    };
    initContent = ''
      if ! infocmp "$TERM" >/dev/null 2>&1; then
        export TERM=xterm-256color
      fi
      source "$HOME/.localrc"
    '';
  };
  programs.fzf = { enable = true; enableZshIntegration = true; };
  programs.zoxide = { enable = true; enableZshIntegration = true; };
  programs.carapace = { enable = true; enableZshIntegration = true; };
}
