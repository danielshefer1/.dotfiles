{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    onlyoffice-desktopeditors
    qalculate-gtk
    google-chrome
    bitwarden-desktop
    karere
    obsidian
    kdePackages.okular
    concord
    # shortcut: nixpkgs recipe lacks zstd and fails to build, remove once nixpkgs lists it
    (concord-tui.overrideAttrs (old: { buildInputs = old.buildInputs ++ [ zstd ]; }))
  ];
}
