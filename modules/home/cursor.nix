{ pkgs, ... }:

{
  home.pointerCursor = {
    enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors"; # or "Bibata-Modern-Classic"
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
