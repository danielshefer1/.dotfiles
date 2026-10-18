{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker-compose
    postgresql_16
    railway
    github-cli
    cloudflared
    python3
    libqalculate
    nodejs_latest
    pipx
    mcp-nixos
    cargo
    rustc
    rustfmt
    gcc
    uv
  ];
}
