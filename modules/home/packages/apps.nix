{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    whatsie
    onlyoffice-desktopeditors
    qalculate-gtk
    google-chrome
    remmina
    bitwarden-desktop
    vesktop
  ];
}
