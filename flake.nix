{
  description = "Shared Linux VM development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      hosts = import ./nix/hosts.nix;
      mkHome = host: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit (host) system; };
        extraSpecialArgs = { inherit host; };
        modules = [ ./nix/home.nix ] ++ (host.modules or [ ]);
      };
      homes = builtins.mapAttrs (_: mkHome) hosts;
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in {
      homeConfigurations = homes // {
        # Only machine identity is read from the environment. Packages stay locked.
        # The helper supplies these values and enables --impure for this profile.
        current = mkHome {
          username = builtins.getEnv "DOTFILES_VM_USER";
          homeDirectory = builtins.getEnv "DOTFILES_VM_HOME";
          system = builtins.getEnv "DOTFILES_VM_SYSTEM";
        };
      };
      formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
