{ pkgs, ... }:

{
  programs.niri.settings.xwayland-satellite = {
    enable = true;
    path = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
  };
}
