{ pkgs, ... }:

{
  # The gtk3 template defines libadwaita-style colors (window_bg_color, ...), which only the
  # adw-gtk3 theme reads; its hook selects adw-gtk3/adw-gtk3-dark to match the mode.
  home.packages = [ pkgs.adw-gtk3 ];
}
