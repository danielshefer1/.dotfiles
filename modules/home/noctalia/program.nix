{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Settings from the other files in this folder are written to ~/.config/noctalia/config.toml
  programs.noctalia.enable = true;
}
