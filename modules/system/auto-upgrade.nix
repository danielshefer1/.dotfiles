{ ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "daily"; # Options: "daily", "weekly", "04:00", etc.
    flake = "/home/daniels/.dotfiles";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    allowReboot = false;
  };
}
