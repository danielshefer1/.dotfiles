{ ... }:

{
  programs.niri.settings.input = {
    keyboard = {
      xkb = {
        layout = "us,il";
        options = "grp:alt_shift_toggle";
      };
      repeat-delay = 300;
      repeat-rate = 40;
    };
  };
}
