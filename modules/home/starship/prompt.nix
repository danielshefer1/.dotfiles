{ ... }:

{
  programs.starship = {
    enable = true;

    # Enables integration with Zsh automatically
    enableZshIntegration = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      # Color names below resolve against [palettes.noctalia], which noctalia's starship template
      # writes into starship.toml (Catppuccin-compatible names)
      palette = "noctalia";

      # Pills use accent colors only. The neutral names (surface*, overlay*, base, ...) map to the
      # terminal background/black, which many palettes make identical to the background, and kitty
      # renders cells with that exact background as transparent (background_opacity).
      # Each segment is a self-contained pill, so its colors never depend on its neighbours. The
      # ( ) groups render only when a module inside them has output, so e.g. the git pill vanishes
      # outside a repo instead of leaving an empty block.
      format = builtins.concatStringsSep "" [
        "[](fg:blue)$os$username[](fg:blue) "
        "[](fg:magenta)$directory[](fg:magenta) "
        "([](fg:green)$git_branch$git_status[](fg:green) )"
        "([](fg:yellow)$c$rust$golang$nodejs$python$nix_shell[](fg:yellow))"
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
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      os = {
        format = "[$symbol]($style)";
        style = "bg:blue fg:base";
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
        style_user = "bg:blue fg:base bold";
        style_root = "bg:blue fg:red bold";
        format = "[$user]($style)";
      };

      directory = {
        style = "bg:magenta fg:base";
        format = "[ $path ]($style)";
        truncation_length = 3;
      };

      git_branch = {
        symbol = " ";
        style = "bg:green fg:base";
        format = "[ $symbol$branch ]($style)";
      };

      git_status = {
        style = "bg:green fg:base";
        format = "[($all_status$ahead_behind )]($style)";
      };

      python = {
        symbol = " ";
        style = "bg:yellow fg:base";
        format = "[ $symbol($version) ]($style)";
      };

      rust = {
        symbol = " ";
        style = "bg:yellow fg:base";
        format = "[ $symbol($version) ]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:yellow fg:base";
        format = "[ $symbol($version) ]($style)";
      };

      golang = {
        symbol = " ";
        style = "bg:yellow fg:base";
        format = "[ $symbol($version) ]($style)";
      };

      nodejs = {
        symbol = " ";
        style = "bg:yellow fg:base";
        format = "[ $symbol($version) ]($style)";
      };

      nix_shell = {
        symbol = " ";
        style = "bg:yellow fg:base";
        format = "[ $symbol$state ]($style)";
      };

      cmd_duration = {
        style = "fg:yellow bold";
        format = "[$duration]($style) ";
        min_time = 1000;
      };
    };
  };
}
