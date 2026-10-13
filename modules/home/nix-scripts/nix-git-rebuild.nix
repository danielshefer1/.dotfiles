{ pkgs, ... }:

{
  home.packages = [ (import ./pkgs/nix-git-rebuild.nix pkgs) ];
}
