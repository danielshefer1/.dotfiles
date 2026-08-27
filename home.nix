{ pkgs, inputs, ... }: {

  imports = [
    ./modules/home/niri.nix
    ./modules/home/zsh.nix
    ./modules/home/git.nix
    ./modules/home/kitty.nix
    ./modules/home/noctalia.nix
    ./modules/home/vscode.nix
    ./modules/home/xdg.nix
    ./modules/home/cursor.nix
    ./modules/home/starship.nix
    ./modules/home/spicetify.nix
    inputs.catppuccin.homeModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.username = "daniels";
  home.homeDirectory = "/home/daniels";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    ripgrep
    nautilus
    claude-code
    capitaine-cursors
    btop
    discord
    whatsie
    onlyoffice-desktopeditors
    stremio-linux-shell
    qalculate-gtk
    google-chrome
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
  };
}
