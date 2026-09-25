{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/locale.nix
    ./modules/system/desktop.nix
    ./modules/system/steam.nix
    ./modules/system/boot.nix
  ];

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Automatically turn on Bluetooth at boot
  };

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

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Nix & Package Management Settings
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.xwayland.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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

  programs.nix-ld.enable = true;

  # Core System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tuigreet
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    direnv
  ];

  system.stateVersion = "26.05";
}
