{ lib, ... }:

{
  # Imports every other .nix file here, so nix-add can create new topics
  imports = map (f: ./. + "/${f}") (
    builtins.filter (f: f != "default.nix" && lib.hasSuffix ".nix" f) (
      builtins.attrNames (builtins.readDir ./.)
    )
  );
}
