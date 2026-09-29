{ inputs, pkgs, ... }:
let
  # Get access to available spicetify packages/extensions/themes
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;

    # Pick a theme (e.g., Catppuccin, Nord, TokyoNight, etc.)
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    # Enable custom extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle # shuffle+
      sortPlay
    ];

    # Enable custom internal apps (optional)
    enabledCustomApps = with spicePkgs.apps; [
      newReleases
      ncsVisualizer
    ];

    # Enable CSS snippets (optional)
    enabledSnippets = with spicePkgs.snippets; [
      pointer
    ];
  };
}
