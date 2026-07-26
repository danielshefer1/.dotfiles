{ pkgs, inputs, ... }: {
  imports = [
    inputs.dms.homeModules.default
  ];

  home.username = "daniels";
  home.homeDirectory = "/home/daniels";
  home.stateVersion = "24.11";

  # Primary Terminal
  programs.kitty.enable = true;

  # DankMaterialShell
  programs.dank-material-shell = {
    enable = true;
    enableDynamicTheming = true;
  };

  # Configure Niri Keybindings & Auto-start
  programs.niri = {
    settings = {
      spawn-at-startup = [
        { command = [ "dms" "run" ]; }
      ];

      # Define default window manager keybindings
      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = [];
        "Mod+Q".action.spawn = [ "kitty" ];
        "Mod+C".action.close-window = [];

        # Focus Movement
        "Mod+Left".action.focus-column-left = [];
        "Mod+Right".action.focus-column-right = [];
        "Mod+Down".action.focus-window-or-workspace-down = [];
        "Mod+Up".action.focus-window-or-workspace-up = [];

        # Move Columns
        "Mod+Ctrl+Left".action.move-column-left = [];
        "Mod+Ctrl+Right".action.move-column-right = [];

        # Layout & Workspaces
        "Mod+F".action.maximize-column = [];
        "Mod+A".action.toggle-window-floating = [];
        "Mod+Shift+E".action.quit = [];
      };
    };
  };
}
