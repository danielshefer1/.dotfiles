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
      export EDITOR="vim"
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
