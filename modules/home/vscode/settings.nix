{ ... }:

{
  programs.vscode.profiles.default.userSettings = {
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
}
