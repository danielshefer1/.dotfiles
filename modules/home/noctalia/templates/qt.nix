{ config, ... }:

{
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
}
