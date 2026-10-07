{ importDir, ... }:

{
  # Imports every other .nix file here, so nix-add can create new topics
  imports = importDir ./.;
}
