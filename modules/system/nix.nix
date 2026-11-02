{ inputs, ... }:

{
  # Nix & Package Management Settings
  nixpkgs.config.allowUnfree = true;
  # gtk2 is marked broken ahead of removal before NixOS 27.05; lutris and onlyoffice-desktopeditors still need it
  nixpkgs.config.problems.handlers."gtk+".broken = "warn";
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
    # Exposes pkgs.nur.repos.<owner>.<pkg>
    inputs.nur.overlays.default
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
