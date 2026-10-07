{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    btop
    yazi
    unzip
    gzip
    zip
    usbutils
    jq
    fd
    fzf
    fastfetch
  ];
}
