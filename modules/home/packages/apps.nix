{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    onlyoffice-desktopeditors
    qalculate-gtk
    google-chrome
    bitwarden-desktop
    karere
    obsidian
    kdePackages.okular
    concord
    concord-tui
  ];
}
