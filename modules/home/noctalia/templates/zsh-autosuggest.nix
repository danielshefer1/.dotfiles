{ config, ... }:

{
  # Sourced by modules/home/zsh.nix
  programs.noctalia.settings.theme.templates.user.zsh-autosuggest = {
    input_path = "${./zsh-autosuggest.zsh}";
    output_path = "${config.xdg.configHome}/zsh/noctalia-autosuggest.zsh";
  };
}
