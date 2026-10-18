{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    btop
    unzip
    gzip
    zip
    jq
    fd
    fzf
    fastfetch
    nixos-facter
    graphify
  ];
}
