{ pkgs, ... }:
let
  # Removes packages picked from the topic files under modules/home/packages,
  # commits, rebuilds and collects garbage
  nix-remove = pkgs.writeShellApplication {
    name = "nix-remove";
    runtimeInputs = with pkgs; [
      fzf
      gawk
      coreutils
      git
    ];
    runtimeEnv.PACKAGES_AWK = ./packages.awk;
    text = builtins.readFile ./packages-lib.sh + "\n" + builtins.readFile ./nix-remove.sh;
  };
in
{
  home.packages = [ nix-remove ];
}
