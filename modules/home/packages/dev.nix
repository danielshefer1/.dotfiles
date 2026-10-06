{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker-compose
    postgresql_16
    railway
    github-cli
    claude-code
    cloudflared
    python3
    libqalculate
    nodejs_latest
  ];
}
