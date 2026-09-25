{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    # Enable unfree VS Code binary (official Microsoft build)
    package = pkgs.vscode;

    # Profiles syntax (Home Manager 24.05+)
    profiles.default = {
      # Declarative Extensions
      extensions = with pkgs.vscode-extensions; [
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

        # SQL Server / Database Development
        # Not packaged in nixpkgs -- install from the Marketplace UI, or add the
        # nix-vscode-extensions flake input to get them declaratively.
        # ms-mssql.mssql
        # mtxr.sqltools

        # Theme
        catppuccin.catppuccin-vsc

        # Formatting & Linting
        esbenp.prettier-vscode
      ];

      userSettings = {
        "editor.fontSize" = 14;
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
        "workbench.colorTheme" = "Catppuccin Mocha";
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
}
