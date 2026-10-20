{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };

    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "history"
        "direnv"
      ];
    };

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lh --icons --group-directories-first";
      la = "eza -lah --icons --group-directories-first";
      cat = "bat --paging=never";
    };

    initContent = ''
      export EDITOR="neovim"

      # fzf colors rendered by noctalia's fzf template
      [ -r "''${XDG_CONFIG_HOME:-$HOME/.config}/fzf/themes/noctalia.sh" ] \
        && source "''${XDG_CONFIG_HOME:-$HOME/.config}/fzf/themes/noctalia.sh"

      # Autosuggestion color rendered by noctalia (see noctalia/templates/zsh-autosuggest.nix)
      [ -r "''${XDG_CONFIG_HOME:-$HOME/.config}/zsh/noctalia-autosuggest.zsh" ] \
        && source "''${XDG_CONFIG_HOME:-$HOME/.config}/zsh/noctalia-autosuggest.zsh"
    '';
  };

  home.packages = with pkgs; [
    eza
    bat
  ];
}
