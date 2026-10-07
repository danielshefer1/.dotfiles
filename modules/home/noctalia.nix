{ config, inputs, lib, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # Settings GUI changes land in settings.toml, which overrides config.toml. Move it aside on every
  # switch so this file stays the source of truth; GUI tweaks last until the next rebuild.
  # Diff the .bak against `noctalia config export` to find tweaks worth porting here.
  home.activation.resetNoctaliaGuiSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="${config.xdg.stateHome}/noctalia/settings.toml"
    if [ -e "$settings" ]; then
      run mv $VERBOSE_ARG "$settings" "$settings.bak"
    fi
  '';

  # Written to ~/.config/noctalia/config.toml
  programs.noctalia = {
    enable = true;

    settings = {
      audio.enable_overdrive = true;

      bar.main = {
        position = "top";
        start = [ "launcher" "wallpaper" "mpvpaper" "workspaces" "ribbon" ];
        center = [ "nix-monitor" "media" "audio_visualizer" "notifications" "clipboard" "color-picker" "calculator" ];
        end = [ "network" "sysmon" "bluetooth" "volume" "control-center" "session" ];
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
        behavior_order = [ "lock" "screen-off" "lock-and-suspend" ];
        behavior = {
          lock = { action = "lock"; enabled = true; timeout = 600.0; };
          screen-off = { action = "screen_off"; enabled = true; timeout = 660.0; };
          lock-and-suspend = { action = "lock_and_suspend"; enabled = true; timeout = 900.0; };
        };
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

      theme = {
        mode = "dark";
        source = "community";
        community_palette = "Tomorrow";
        builtin = "Catppuccin";
        wallpaper_scheme = "m3-content";
        templates = {
          builtin_ids = [ "btop" "gtk3" "gtk4" "kitty" "niri" "qt" "starship" ];
          community_ids = [ "claude-code" "discord" "prismlauncher" "steam" "fastfetch" "mailspring" ];
        };
      };

      wallpaper.default.path = "/home/daniels/Pictures/Wallpapers/1004017-colorized.png";
    };
  };
}
