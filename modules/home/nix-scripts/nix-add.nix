{ pkgs, ... }:
let
  # Picks a package with fzf-packages, adds it to a topic file under
  # modules/home/packages, commits and rebuilds
  nix-add = pkgs.writeShellApplication {
    name = "nix-add";
    runtimeInputs = [
      (import ./pkgs/fzf-packages.nix pkgs)
      pkgs.fzf
      pkgs.gawk
      pkgs.coreutils
      pkgs.gnused
      pkgs.git
    ];
    runtimeEnv.PACKAGES_AWK = ./packages.awk;
    text = builtins.readFile ./packages-lib.sh + "\n" + builtins.readFile ./nix-add.sh;
  };
in
{
  home.packages = [ nix-add ];
}
