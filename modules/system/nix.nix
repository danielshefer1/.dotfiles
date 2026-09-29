{ inputs, ... }:

{
  # Nix & Package Management Settings
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;
}
