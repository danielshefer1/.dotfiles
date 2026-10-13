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
    cargo # Rust Package Manager
    rustc # Rust Compiler
    rustfmt # Code Formatter for Rust
    gcc # C Linker required by rustc
    uv
  ];
}
