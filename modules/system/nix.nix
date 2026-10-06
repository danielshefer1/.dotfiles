{ inputs, ... }:

{
  # Nix & Package Management Settings
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
    # Exposes pkgs.nur.repos.<owner>.<pkg>
    inputs.nur.overlays.default
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;
  # Resolves /bin/bash, /usr/bin/python3, etc. via PATH for scripts with FHS shebangs
  services.envfs.enable = true;
}
