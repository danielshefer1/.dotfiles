{ pkgs, inputs, ... }: {

  imports = [
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
    ./modules/home/fzf-nixpkgs.nix
    inputs.catppuccin.homeModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.username = "daniels";
  home.homeDirectory = "/home/daniels";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    ripgrep
    docker-compose
    postgresql_16
    railway
    github-cli
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
    steam-run
    wineWow64Packages.stable
    lutris
    protontricks
    qbittorrent
    syncplay
    vlc
    prismlauncher
    rclone
    pinta
    yazi
    unzip
    gzip
    zip
  ];

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
  };
}
