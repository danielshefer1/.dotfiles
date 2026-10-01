{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/networking.nix
    ./modules/system/bluetooth.nix
    ./modules/system/users.nix
    ./modules/system/docker.nix
    ./modules/system/nix.nix
    ./modules/system/graphics.nix
    ./modules/system/auto-upgrade.nix
    ./modules/system/packages.nix
    ./modules/system/state-version.nix
    ./modules/system/locale.nix
    ./modules/system/desktop.nix
    ./modules/system/steam.nix
    ./modules/system/localsend.nix
    ./modules/system/boot.nix
    ./modules/system/xdg.nix
    ./modules/system/nvidia.nix
    ./modules/system/upower.nix
  ];
}
