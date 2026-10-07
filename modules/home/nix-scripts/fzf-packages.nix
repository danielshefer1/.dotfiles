{ pkgs, ... }:

{
  home.packages = [ (import ./pkgs/fzf-packages.nix pkgs) ];
}
