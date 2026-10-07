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

      torlnk = "npx torlnk";
    };

    initContent = ''
      export EDITOR="vim"

      # fzf colors rendered by noctalia's fzf template
      [ -r "''${XDG_CONFIG_HOME:-$HOME/.config}/fzf/themes/noctalia.sh" ] \
        && source "''${XDG_CONFIG_HOME:-$HOME/.config}/fzf/themes/noctalia.sh"
    '';
  };

  home.packages = with pkgs; [
    eza
    bat
    fd
    fzf
    fastfetch
  ];
}
