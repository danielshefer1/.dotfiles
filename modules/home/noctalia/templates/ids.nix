{ ... }:

{
  # Builtin and community templates, rendered with the active palette
  programs.noctalia.settings.theme.templates = {
    builtin_ids = [
      "btop"
      "gtk3"
      "gtk4"
      "niri"
      "qt"
      "starship"
    ];
    community_ids = [
      "claude-code"
      "discord"
      "prismlauncher"
      "fastfetch"
      "fzf"
      "vscode"
      "zen-browser"
      "bat"
    ];
  };
}
