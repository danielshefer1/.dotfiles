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

      nix-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles#nixos";
      nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

      nix-git = "git -C $HOME/.dotfiles add . && git -C $HOME/.dotfiles commit -m 'Update'";
      nix-git-rebuild = "nix-git ; sudo nixos-rebuild switch --flake ~/.dotfiles#nixos";
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
    uv
  ];
}
