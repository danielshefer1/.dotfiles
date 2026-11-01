{ config, ... }:

{
  # Rendered by noctalia's niri template (border, focus-ring, tab colors). Absolute path because
  # config.kdl is a store symlink; non-store includes are optional by default, so niri still
  # starts before noctalia's first render.
  programs.niri.settings.includes = [ "${config.xdg.configHome}/niri/noctalia.kdl" ];
}
