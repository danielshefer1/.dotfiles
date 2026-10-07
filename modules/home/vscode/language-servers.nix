{ pkgs, ... }:

{
  # Used by the nix-ide settings in settings.nix
  home.packages = with pkgs; [
    nixd # Nix Language Server
    nixfmt # Official RFC-style Nix Formatter (provides 'nixfmt' binary)
  ];
}
