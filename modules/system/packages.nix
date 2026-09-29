{ pkgs, inputs, ... }:

{
  # Core System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    direnv
  ];
}
