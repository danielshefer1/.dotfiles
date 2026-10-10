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
    mpvpaper
    mpv
    # mpvpaper plugin extracts the video's frame for the lock screen/greeter with it
    ffmpeg
    socat
    hyprpicker
    nix-search-tv
    inputs.torlink.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
