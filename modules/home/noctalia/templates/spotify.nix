{ config, ... }:

{
  # Used instead of the community spicetify template, which runs `spicetify apply` against a
  # writable Spotify install; modules/home/spicetify.nix links Spotify's colors.css to this output.
  programs.noctalia.settings.theme.templates.user.spotify = {
    input_path = "${./spicetify-colors.css}";
    output_path = "${config.xdg.configHome}/spicetify/noctalia-colors.css";
  };
}
