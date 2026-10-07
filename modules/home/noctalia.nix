{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  keepGuiState =
    pkgs.writers.writePython3 "noctalia-keep-gui-state"
      {
        libraries = [ pkgs.python3Packages.tomli-w ];
      }
      ''
        import sys
        import tomllib

        import tomli_w

        KEEP = ["theme", "wallpaper", "lockscreen_widgets"]

        src, dest = sys.argv[1:]
        with open(src, "rb") as f:
            old = tomllib.load(f)

        old.get("theme", {}).pop("templates", None)
        kept = {k: old[k] for k in KEEP if old.get(k)}
        if kept:
            if "config_version" in old:
                kept = {"config_version": old["config_version"], **kept}
            with open(dest, "wb") as f:
                tomli_w.dump(kept, f)
      '';
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Settings GUI changes land in settings.toml, which overrides config.toml. Move it aside on every
  # switch so this file stays the source of truth; GUI tweaks last until the next rebuild.
  # Diff the .bak against `noctalia config export` to find tweaks worth porting here.
  # The exceptions are carried over: the theme picked in the GUI ([theme], minus the declarative
  # theme.templates), the wallpaper and the lockscreen widget layout.
  home.activation.resetNoctaliaGuiSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="${config.xdg.stateHome}/noctalia/settings.toml"
    if [ -e "$settings" ]; then
      run mv $VERBOSE_ARG "$settings" "$settings.bak"
      run ${keepGuiState} "$settings.bak" "$settings"
    fi
  '';

  # The fastfetch template's hook merges colors into config.jsonc and bails if it doesn't exist.
  # An empty object keeps fastfetch's default modules.
  home.activation.fastfetchNoctaliaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    fastfetch_config="${config.xdg.configHome}/fastfetch/config.jsonc"
    if [ ! -e "$fastfetch_config" ]; then
      run install -D -m644 ${pkgs.writeText "fastfetch-config.jsonc" "{}\n"} "$fastfetch_config"
    fi
  '';

  # The gtk3 template defines libadwaita-style colors (window_bg_color, ...), which only the
  # adw-gtk3 theme reads; its hook selects adw-gtk3/adw-gtk3-dark to match the mode.
  home.packages = [ pkgs.adw-gtk3 ];

  # Point qt5ct/qt6ct at the color schemes rendered by the qt template
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    qt5ctSettings.Appearance = {
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt5ct/colors/noctalia.conf";
    };
    qt6ctSettings.Appearance = {
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/qt6ct/colors/noctalia.conf";
    };
  };

  # Written to ~/.config/noctalia/config.toml
  programs.noctalia = {
    enable = true;

    settings = {
      audio.enable_overdrive = true;

      bar.main = {
        position = "top";
        start = [
          "launcher"
          "wallpaper"
          "mpvpaper"
          "workspaces"
          "ribbon"
        ];
        center = [
          "nix-monitor"
          "media"
          "audio_visualizer"
          "notifications"
          "clipboard"
          "color-picker"
          "calculator"
        ];
        end = [
          "network"
          "sysmon"
          "bluetooth"
          "volume"
          "control-center"
          "session"
        ];
      };

      # Plugin widget instances referenced from the bar above
      widget = {
        mpvpaper.type = "noctalia/mpvpaper:mpvpaper";
        nix-monitor.type = "avivbintangaringga/nix-monitor:nix-monitor";
        ribbon.type = "luochen1990/niri-ribbon:ribbon";
        color-picker.type = "oldirtty/color_picker:widget";
        calculator.type = "samuelskovbakke/calculator-plus:widget";
      };

      plugins.enabled = [
        "avivbintangaringga/nix-monitor"
        "oldirtty/color_picker"
        "noctalia/mpvpaper"
        "luochen1990/niri-ribbon"
        "samuelskovbakke/calculator-plus"
      ];

      plugin_settings."avivbintangaringga/nix-monitor".update_command =
        "nix flake update --flake /home/daniels/.dotfiles/ && nix-git-rebuild";

      control_center.shortcuts = [
        { type = "bluetooth"; }
        { type = "notification"; }
      ];

      idle = {
        behavior_order = [
          "lock"
          "screen-off"
          "lock-and-suspend"
        ];
        behavior = {
          lock = {
            action = "lock";
            enabled = true;
            timeout = 600.0;
          };
          screen-off = {
            action = "screen_off";
            enabled = false;
            timeout = 660.0;
          };
          lock-and-suspend = {
            action = "lock_and_suspend";
            enabled = false;
            timeout = 900.0;
          };
        };
      };

      # The lock screen and greeter can only show a still image, so on lock stop the video wallpaper:
      # the plugin swaps in a frame of it as Noctalia's wallpaper, which the lock screen draws and
      # greeter_sync pushes to the login screen. Unlock brings the video back.
      hooks = {
        session_locked = "noctalia msg plugin noctalia/mpvpaper:service all clear-all";
        session_unlocked = "noctalia msg plugin noctalia/mpvpaper:service all reapply";
      };

      location.auto_locate = true;

      notification.background_opacity = 0.8;

      shell = {
        polkit_agent = true;
        screen_corners.enabled = true;
        screenshot.confirm_region = true;
        # Push wallpaper/palette/font changes to noctalia-greeter automatically
        greeter_sync.auto_sync = true;
      };

      # Only the default theme: anything picked in the settings GUI overrides it and survives
      # rebuilds (see resetNoctaliaGuiSettings). Templates follow whatever is active.
      theme = {
        mode = "dark";
        source = "community";
        community_palette = "Paradise";
        templates = {
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
          # Replaces the builtin kitty template, whose hook edits kitty.conf (a read-only store
          # symlink) and so never reaches its reload. kitty.nix includes the rendered file.
          user.kitty = {
            input_path = "${config.programs.noctalia.package}/share/noctalia/assets/templates/kitty/kitty.conf";
            output_path = "${config.xdg.configHome}/kitty/themes/noctalia.conf";
            post_hook = "pkill -USR1 kitty || true";
          };
          # Used instead of the community spicetify template, which runs `spicetify apply` against a
          # writable Spotify install; spicetify.nix links Spotify's colors.css to this output.
          user.spotify = {
            input_path = "${./noctalia-templates/spicetify-colors.css}";
            output_path = "${config.xdg.configHome}/spicetify/noctalia-colors.css";
          };
          # Sourced by zsh.nix
          user.zsh-autosuggest = {
            input_path = "${./noctalia-templates/zsh-autosuggest.zsh}";
            output_path = "${config.xdg.configHome}/zsh/noctalia-autosuggest.zsh";
          };
        };
      };

      wallpaper.default.path = "/home/daniels/Pictures/Wallpapers/1004017-colorized.png";
    };
  };
}
