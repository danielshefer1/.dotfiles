{ ... }:

{
  programs.zsh.shellAliases = {
    nix-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles#nixos";
    nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

    nix-git = "git -C $HOME/.dotfiles add . && git -C $HOME/.dotfiles commit -m 'Update'";
    nix-git-rebuild = "nix-git ; sudo nixos-rebuild switch --flake ~/.dotfiles#nixos";
  };
}
