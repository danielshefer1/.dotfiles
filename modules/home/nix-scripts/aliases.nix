{ ... }:

{
  programs.zsh.shellAliases = {
    nix-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles";
    nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

    nix-git = "git -C $HOME/.dotfiles add . && git -C $HOME/.dotfiles commit -m 'Update'";
  };
}
