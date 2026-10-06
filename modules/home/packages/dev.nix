{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker-compose
    postgresql_16
    railway
    github-cli
    claude-code
    nodejs_24
    cloudflared
    python3
  ];
}
