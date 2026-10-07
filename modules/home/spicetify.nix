{
  config,
  inputs,
  pkgs,
  ...
}:
let
  # Get access to available spicetify packages/extensions/themes
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  cfg = config.programs.spicetify;

  # Rendered by noctalia (see noctalia.nix). Spotify reads it at startup, so palette changes show
  # up after restarting Spotify.
  noctaliaColors = "${config.xdg.configHome}/spicetify/noctalia-colors.css";
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    # The module would install the spiced package as-is; it's installed below with colors.css
    # swapped for noctalia's instead.
    enable = false;

    theme = spicePkgs.themes.comfy;
    colorScheme = "Comfy";

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

  home.packages = [
    (cfg.spicedSpotify.overrideAttrs (old: {
      # Runs after `spicetify apply` in the builder's postInstall
      postInstall = old.postInstall + ''
        ln -sf '${noctaliaColors}' "$out/share/spotify/Apps/xpui/colors.css"
      '';
      # The link target only exists in $HOME
      dontCheckForBrokenSymlinks = true;
    }))
  ]
  ++ cfg.theme.extraPkgs;
}
