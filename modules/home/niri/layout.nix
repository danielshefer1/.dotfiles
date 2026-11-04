{ ... }:

{
  programs.niri.settings.layout = {
    # iNiR aesthetic uses compact, modern gaps
    gaps = 8;

    # Empty = the window picks its own width; left unset, niri falls back to half the screen
    default-column-width = { };

    # Primary active/inactive border styling; colors come from noctalia.kdl
    border = {
      enable = true;
      width = 2;
    };

    # Disable focus-ring to match iNiR's crisp single-border look
    focus-ring = {
      enable = false;
    };
  };
}
