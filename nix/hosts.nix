# Optional named profiles. The installer automatically uses the current user.
# Customize these only when a VM needs overrides beyond the shared environment.
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
