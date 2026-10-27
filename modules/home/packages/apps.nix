{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    onlyoffice-desktopeditors
    qalculate-gtk
    google-chrome
    bitwarden-desktop
    vesktop
    karere
    obsidian
    nur.repos.trev.helium
  ];
}
