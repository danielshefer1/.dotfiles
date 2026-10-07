{ config, ... }:

{
  # Replaces the builtin kitty template, whose hook edits kitty.conf (a read-only store
  # symlink) and so never reaches its reload. modules/home/kitty.nix includes the rendered file.
  programs.noctalia.settings.theme.templates.user.kitty = {
    input_path = "${config.programs.noctalia.package}/share/noctalia/assets/templates/kitty/kitty.conf";
    output_path = "${config.xdg.configHome}/kitty/themes/noctalia.conf";
    post_hook = "pkill -USR1 kitty || true";
  };
}
