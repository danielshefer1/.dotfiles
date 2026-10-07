{ ... }:

{
  programs.niri.settings.binds = {
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
}
