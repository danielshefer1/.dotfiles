{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    # Enable unfree VS Code binary (official Microsoft build)
    package = pkgs.vscode;
  };
}
