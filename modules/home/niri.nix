{ pkgs, ... }:

{
  programs.niri = {
    settings = {
      spawn-at-startup = [
        { command = [ "noctalia" ]; }
      ];
      hotkey-overlay = {
        skip-at-startup = true;
      };

      xwayland-satellite = {
        enable = true;
        path = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      };

      prefer-no-csd = true;

      layout = {
        # iNiR aesthetic uses compact, modern gaps
        gaps = 8;

        # Primary active/inactive border styling
        border = {
          enable = true;
          width = 2;

          # Material-inspired active focus color and subtle dim inactive color
          # (These update dynamically if you run iNiR's matugen color pipeline)
          active.color = "#a8c7fa"; # Material Primary Accent
          inactive.color = "#282a36"; # Subtle dark surface outline
        };

        # Disable focus-ring to match iNiR's crisp single-border look
        focus-ring = {
          enable = false;
        };
      };

      # Window corner rounding & clipping for the iNiR material aesthetic
      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 8.0;
            top-right = 8.0;
            bottom-left = 8.0;
            bottom-right = 8.0;
          };
          clip-to-geometry = true;
        }
      ];

      cursor = {
        theme = "capitaine-cursors";
        size = 24;
        hide-when-typing = true;
        hide-after-inactive-ms = 3000;
      };

      outputs = {
        "HDMI-A-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 144.013; # Sets your MSI G24C4 to 144Hz
          };
          scale = 1.0;
        };
      };

      input = {
        keyboard = {
          xkb = {
            layout = "us,il";
            options = "grp:alt_shift_toggle";
          };
          repeat-delay = 300;
          repeat-rate = 40;
        };
      };

      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

        "Mod+C".action.close-window = [ ];
        # Focus Movement
        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+Down".action.focus-window-or-workspace-down = [ ];
        "Mod+Up".action.focus-window-or-workspace-up = [ ];

        # Move Columns
        "Mod+Ctrl+Left".action.move-column-left = [ ];
        "Mod+Ctrl+Right".action.move-column-right = [ ];

        # Layout & Workspaces
        "Mod+F".action.maximize-column = [ ];
        "Mod+G".action.toggle-window-floating = [ ];
        "Mod+Shift+E".action.quit = [ ];

        "Mod+Space".action.spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "launcher"
        ];
        "Mod+S".action.spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "control-center"
        ];
        "Mod+Comma".action.spawn = [
          "noctalia"
          "msg"
          "settings-toggle"
        ];
        "Alt+Tab".action.spawn = [
          "noctalia"
          "msg"
          "window-switcher"
        ];
        "Mod+Escape".action.spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "session"
        ];

        "Mod+Q".action.spawn = [ "kitty" ];
        "Mod+B".action.spawn = [ "zen" ];
        "Ctrl+Shift+Escape".action.spawn = [
          "kitty"
          "-e"
          "btop"
        ];
        "Mod+D".action.spawn = [ "code" ];
        "Mod+A".action.spawn = [ "spotify" ];
      };
    };
  };
}
