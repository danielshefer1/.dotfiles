{ inputs, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;

    settings = {
      bar = {
        position = "top";
        density = "compact";
        widgets = {
          left = [
            { id = "ControlCenter"; useDistroLogo = true; }
            { id = "Workspace"; hideUnoccupied = false; }
          ];
          center = [
            { id = "Clock"; formatHorizontal = "HH:mm"; usePrimaryColor = true; }
          ];
          right = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "Battery"; warningThreshold = 20; }
          ];
        };
      };

      # Push wallpaper/palette/font changes to noctalia-greeter automatically
      shell.greeter_sync.auto_sync = true;

      colorSchemes = {
        predefinedScheme = "Monochrome";
      };
    };
  };
}
