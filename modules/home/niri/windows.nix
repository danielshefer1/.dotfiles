{ ... }:

{
  programs.niri.settings = {
    prefer-no-csd = true;

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
  };
}
