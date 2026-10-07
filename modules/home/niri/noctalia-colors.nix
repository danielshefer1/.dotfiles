{ config, ... }:

{
  # Rendered by noctalia's niri template (border, focus-ring, tab colors). Absolute path because
  # config.kdl is a store symlink; optional so niri still starts before noctalia's first render.
  programs.niri.settings.includes = [
    (config.lib.niri.include.optional "${config.xdg.configHome}/niri/noctalia.kdl")
  ];
}
