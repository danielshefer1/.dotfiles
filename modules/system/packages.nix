{ pkgs, inputs, ... }:

{
  # Core System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    direnv
    # System-wide so polkit picks up its policy (allow_gui keeps DISPLAY under pkexec)
    gparted
    impression
  ];
}
