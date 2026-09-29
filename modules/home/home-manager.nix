{ ... }:

{
  home.username = "daniels";
  home.homeDirectory = "/home/daniels";
  home.stateVersion = "24.11";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
