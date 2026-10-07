{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    onlyoffice-desktopeditors
    qalculate-gtk
    google-chrome
    remmina
    bitwarden-desktop
    vesktop
    karere
  ];
}
