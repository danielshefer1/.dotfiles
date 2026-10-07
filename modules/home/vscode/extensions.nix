{ pkgs, ... }:

{
  # Profiles syntax (Home Manager 24.05+)
  programs.vscode.profiles.default.extensions =
    (with pkgs.vscode-extensions; [
      # Nix support
      jnoortheen.nix-ide

      # C/C++ & Low-Level Development
      ms-vscode.cpptools

      # Python / Tooling
      ms-python.python

      # Rust / Tooling
      rust-lang.rust-analyzer

      # Docker / Container Development
      ms-azuretools.vscode-containers

      # EditorConfig support
      editorconfig.editorconfig

      # Git support
      donjayamanne.githistory
      github.vscode-github-actions

      # Markdown support
      davidanson.vscode-markdownlint

      # Formatting & Linting
      esbenp.prettier-vscode
    ])
    ++ (with pkgs.vscode-marketplace; [
      # SQL Server / Database Development (not packaged in nixpkgs)
      ms-mssql.mssql
      mtxr.sqltools
    ]);
}
