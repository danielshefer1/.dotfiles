{ pkgs, ... }:

{
  # User Account & Shell
  users.users.daniels = {
    isNormalUser = true;
    description = "Daniel Shefer";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # System Shell Enablement
  programs.zsh.enable = true;
}
