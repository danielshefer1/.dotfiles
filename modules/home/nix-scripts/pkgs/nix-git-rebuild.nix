# Commits the dotfiles and rebuilds.
# Shared by nix-git-rebuild.nix (installs it) and nix-add.nix / nix-remove.nix (call it).
pkgs:

pkgs.writeShellApplication {
  name = "nix-git-rebuild";
  runtimeInputs = [ pkgs.git ];
  text = builtins.readFile ../nix-git-rebuild.sh;
}
