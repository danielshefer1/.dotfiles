# Picks a package from nixpkgs + NUR (as `nur.repos.<owner>.<pkg>`) and
# prints its dotted attr path. Each source is cached separately as
# `attr \t version \t description \t source`.
# Shared by fzf-packages.nix (installs it) and nix-add.nix (calls it).
pkgs:

pkgs.writeShellApplication {
  name = "fzf-packages";
  runtimeInputs = with pkgs; [
    fzf
    jq
    curl
    coreutils
    findutils
  ];
  text = builtins.readFile ../fzf-packages.sh;
}
