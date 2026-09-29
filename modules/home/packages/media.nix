{ pkgs, ... }:

{
  home.packages = with pkgs; [
    vlc
    stremio-linux-shell
    syncplay
    qbittorrent
    pinta
  ];
}
