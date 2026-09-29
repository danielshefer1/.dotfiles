{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam-run
    lutris
    protontricks
    prismlauncher
  ];
}
