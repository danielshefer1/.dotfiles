{ ... }:

{
  programs.noctalia.settings.lockscreen = {
    # Unlocking zooms into the wallpaper as it fades, like stepping into the desktop
    transition = [ "zoom" ];
    # Show the wallpaper as-is, so it lines up with the desktop it fades into
    blur_intensity = 0.0;
    tint_intensity = 0.0;
  };
}
