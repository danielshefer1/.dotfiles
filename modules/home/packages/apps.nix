{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    discord
    whatsie
    onlyoffice-desktopeditors
    qalculate-gtk
    google-chrome
    remmina
  ];
}
