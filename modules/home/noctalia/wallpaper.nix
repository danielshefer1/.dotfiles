{ ... }:

{
  programs.noctalia.settings = {
    wallpaper.default.path = "/home/daniels/Pictures/Wallpapers/1004017-colorized.png";

    # The lock screen and greeter can only show a still image, so on lock stop the video wallpaper:
    # the plugin swaps in a frame of it as Noctalia's wallpaper, which the lock screen draws and
    # greeter_sync pushes to the login screen. Unlock brings the video back.
    hooks = {
      session_locked = "noctalia msg plugin noctalia/mpvpaper:service all clear-all";
      session_unlocked = "noctalia msg plugin noctalia/mpvpaper:service all reapply";
    };
  };
}
