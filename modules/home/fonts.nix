{ pkgs, ... }:

{
  # Used by kitty and VS Code
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
