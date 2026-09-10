# One entry per VM/user. Replace the examples before switching on your machines.
# Profiles sharing a system and package list share the same cached packages.
{
  dev-amd64 = {
    system = "x86_64-linux";
    username = "developer";
    homeDirectory = "/home/developer";
    # Optional: gitName = "Your Name"; gitEmail = "you@example.com";
    # Optional overrides:
    # modules = [ ({ pkgs, ... }: { home.packages = [ pkgs.yq-go ]; }) ];
  };
  dev-arm64 = {
    system = "aarch64-linux";
    username = "developer";
    homeDirectory = "/home/developer";
  };
}
