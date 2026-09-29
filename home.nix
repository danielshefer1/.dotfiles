{ ... }:

{
  imports = [
    ./modules/home/home-manager.nix
    ./modules/home/packages
    ./modules/home/catppuccin.nix
    ./modules/home/niri.nix
    ./modules/home/zsh.nix
    ./modules/home/git.nix
    ./modules/home/kitty.nix
    ./modules/home/noctalia.nix
    ./modules/home/vscode.nix
    ./modules/home/cursor.nix
    ./modules/home/starship.nix
    ./modules/home/spicetify.nix
    ./modules/home/wine.nix
    ./modules/home/keyring.nix
    ./modules/home/systemd-user-services.nix
    ./modules/home/nix-scripts.nix
  ];
}
