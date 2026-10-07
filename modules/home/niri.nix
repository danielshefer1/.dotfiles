{ config, pkgs, ... }:

{
  programs.niri = {
    settings = {
      # Rendered by noctalia's niri template (border, focus-ring, tab colors). Absolute path because
      # config.kdl is a store symlink; optional so niri still starts before noctalia's first render.
      includes = [ (config.lib.niri.include.optional "${config.xdg.configHome}/niri/noctalia.kdl") ];

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

        # Primary active/inactive border styling; colors come from noctalia.kdl
        border = {
          enable = true;
          width = 2;
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
        {
          matches = [
            { app-id = "^kitty$"; }
          ];

          # Forces niri to treat the window as transparent and blur what's behind it
          draw-border-with-background = false;
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
            refresh = 144.013;
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
        "Mod+Alt+F".action.fullscreen-window = [ ];

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

        # Screenshots
        "Print".action.spawn = [
          "noctalia"
          "msg"
          "screenshot-region"
        ];
        "Ctrl+Print".action.spawn = [
          "noctalia"
          "msg"
          "screenshot-fullscreen"
        ];
        "Alt+Print".action.screenshot-window = [ ];
        "Mod+Shift+S".action.spawn = [
          "noctalia"
          "msg"
          "screenshot-annotate"
        ];

        "Mod+Q".action.spawn = [ "kitty" ];
        "Mod+Slash".action.spawn = [ "kitty" ];
        "Mod+B".action.spawn = [ "zen" ];
        "Ctrl+Shift+Escape".action.spawn = [
          "kitty"
          "-e"
          "btop"
        ];
        "Mod+D".action.spawn = [ "code" ];
        "Mod+A".action.spawn = [ "spotify" ];
        "Mod+E".action.spawn = [ "nautilus" ];
      };
    };
  };
}
