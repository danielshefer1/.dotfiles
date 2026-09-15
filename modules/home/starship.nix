# starship.nix
{ ... }:

{
  programs.starship = {
    enable = true;

    # Enables integration with Zsh automatically
    enableZshIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = builtins.concatStringsSep "" [
        "[](fg:#89b4fa)"
        "$os"
        "$username"
        "[](fg:#89b4fa bg:#313244)"
        "$directory"
        "[](fg:#313244 bg:#a6e3a1)"
        "$git_branch"
        "$git_status"
        "[](fg:#a6e3a1 bg:#f9e2af)"
        "$c"
        "$rust"
        "$golang"
        "$nodejs"
        "$python"
        "$nix_shell"
        "[](fg:#f9e2af)"
        "$fill"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      add_newline = true;

      fill = {
        symbol = " ";
      };

      character = {
        success_symbol = "[❯](bold #a6e3a1)";
        error_symbol = "[❯](bold #f38ba8)";
      };

      os = {
        format = "[$symbol]($style)";
        style = "bg:#89b4fa fg:#1e1e2e";
        disabled = false;
        symbols = {
          Arch = "󰣇 ";
          NixOS = " ";
          Ubuntu = "󰕈 ";
          Linux = "🐧 ";
          Macos = "🍎 ";
        };
      };

      username = {
        show_always = true;
        style_user = "bg:#89b4fa fg:#1e1e2e bold";
        style_root = "bg:#89b4fa fg:#f38ba8 bold";
        format = "[$user]($style)";
      };

      directory = {
        style = "bg:#313244 fg:#cdd6f4";
        format = "[ $path ]($style)";
        truncation_length = 3;
      };

      git_branch = {
        symbol = " ";
        style = "bg:#a6e3a1 fg:#1e1e2e";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "bg:#a6e3a1 fg:#1e1e2e";
        format = "[($all_status$ahead_behind )]($style)";
      };

      python = {
        symbol = " ";
        style = "bg:#f9e2af fg:#1e1e2e";
        format = "[ $symbol($version) ]($style)";
      };

      rust = {
        symbol = " ";
        style = "bg:#f9e2af fg:#1e1e2e";
        format = "[ $symbol($version) ]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:#f9e2af fg:#1e1e2e";
        format = "[ $symbol($version) ]($style)";
      };

      nix_shell = {
        symbol = " ";
        style = "bg:#f9e2af fg:#1e1e2e";
        format = "[ $symbol$state ]($style)";
      };

      cmd_duration = {
        style = "fg:#f9e2af bold";
        format = "[$duration]($style) ";
        min_time = 1000;
      };
    };
  };
}
