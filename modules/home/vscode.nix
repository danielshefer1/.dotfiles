{
  config,
  lib,
  pkgs,
  ...
}:

let
  noctaliaTheme = pkgs.vscode-marketplace.noctalia.noctaliatheme;
in
{
  programs.vscode = {
    enable = true;

    # Enable unfree VS Code binary (official Microsoft build)
    package = pkgs.vscode;

    # Profiles syntax (Home Manager 24.05+)
    profiles.default = {
      # Declarative Extensions
      extensions =
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

      userSettings = {
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
        "workbench.colorTheme" = "NoctaliaTheme";
        "terminal.integrated.defaultProfile.linux" = "zsh";

        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnPaste" = true;

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "[rust]" = {
          "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        };

        # Nix LSP configuration
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };
        };

        # Rust LSP configuration
        "rust-analyzer.imports.granularity.group" = "module";
        "rust-analyzer.cargo.buildScripts.enable" = true;
        "rust-analyzer.procMacro.enable" = true;

        "workbench.settings.editor" = "json";

        "github.copilot.inlineSuggest.enable" = false;

        # Optional: Disable all editor inline suggestions globally
        #"editor.inlineSuggest.enabled" = false;
      };
    };
  };

  home.packages = with pkgs; [
    nixd # Nix Language Server
    nixfmt # Official RFC-style Nix Formatter (provides 'nixfmt' binary)
    cargo # Rust Package Manager
    rustc # Rust Compiler
    rustfmt # Code Formatter for Rust
    gcc # C Linker required by rustc
    uv
  ];

  # Noctalia's vscode template rewrites this extension's theme file in place, so it gets a writable
  # copy at the exact path the template targets instead of a store symlink (-n keeps a theme file
  # noctalia already rendered). Dropping extensions.json makes VS Code rescan and register it.
  home.activation.noctaliaVscodeTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    extensions="${config.home.homeDirectory}/.vscode/extensions"
    theme_dir="$extensions/noctalia.noctaliatheme-0.0.5"
    if [ ! -e "$theme_dir/package.json" ]; then
      run mkdir -p "$theme_dir"
      run cp -r -n --no-preserve=mode ${noctaliaTheme}/share/vscode/extensions/noctalia.noctaliatheme/. "$theme_dir"
      run rm -f $VERBOSE_ARG "$extensions/extensions.json"
    fi
  '';
}
