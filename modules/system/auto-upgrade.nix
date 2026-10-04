{ pkgs, ... }:

{
  # Root's upgrade only builds and switches using the lock on disk
  system.autoUpgrade = {
    enable = true;
    dates = "daily"; # Options: "daily", "weekly", "04:00", etc.
    flake = "/home/daniels/.dotfiles";
    allowReboot = false;
  };

  # Lets root read the user-owned repo (fixes the libgit2 ownership error)
  programs.git = {
    enable = true;
    config.safe.directory = [ "/home/daniels/.dotfiles" ];
  };

  # Bumps nixpkgs as daniels, so the commit and .git objects stay owned by the user
  systemd.services.dotfiles-flake-update = {
    description = "Update nixpkgs in dotfiles flake.lock";
    wantedBy = [ "nixos-upgrade.service" ]; # starting the upgrade pulls this in
    before = [ "nixos-upgrade.service" ]; # and it finishes first
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = [
      pkgs.nix
      pkgs.git
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "daniels";
      WorkingDirectory = "/home/daniels/.dotfiles";
    };
    script = "nix flake update nixpkgs --commit-lock-file";
  };
}
