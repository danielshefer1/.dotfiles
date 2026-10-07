{ ... }:

{
  programs.noctalia.settings = {
    plugins.enabled = [
      "avivbintangaringga/nix-monitor"
      "oldirtty/color_picker"
      "noctalia/mpvpaper"
      "luochen1990/niri-ribbon"
      "samuelskovbakke/calculator-plus"
    ];

    plugin_settings."avivbintangaringga/nix-monitor".update_command =
      "nix flake update --flake /home/daniels/.dotfiles/ && nix-git-rebuild";
  };
}
