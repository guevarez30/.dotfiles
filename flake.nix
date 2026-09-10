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
      homeConfigurations = homes;
      formatter = nixpkgs.lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
