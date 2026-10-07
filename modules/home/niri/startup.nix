{ ... }:

{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia" ]; }
    ];
    hotkey-overlay = {
      skip-at-startup = true;
    };
  };
}
