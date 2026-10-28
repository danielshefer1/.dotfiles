{ ... }:

{
  programs.noctalia.settings = {
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

    # Plugin widget instances referenced from the bar above (plugins are enabled in plugins.nix)
    widget = {
      mpvpaper.type = "noctalia/mpvpaper:mpvpaper";
      nix-monitor.type = "avivbintangaringga/nix-monitor:nix-monitor";
      ribbon.type = "luochen1990/niri-ribbon:ribbon";
      color-picker.type = "oldirtty/color_picker:widget";
      calculator.type = "samuelskovbakke/calculator-plus:widget";

      # Built-in widgets (type defaults to the instance name)
      sysmon.show_cpu_cores = true;
    };
  };
}
