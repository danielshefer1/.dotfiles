{ ... }:

{
  programs.noctalia.settings = {
    wallpaper.default.path = "/home/daniels/Pictures/Wallpapers/1004017-colorized.png";

    # While a video plays, the plugin keeps a frame of it as Noctalia's wallpaper, which the lock
    # screen draws and greeter_sync pushes to the login screen. Only pause the video while locked:
    # clearing it would swap the wallpaper and play a wallpaper transition behind the unlock.
    hooks = {
      session_locked = "noctalia msg plugin noctalia/mpvpaper:service all pause";
      session_unlocked = "noctalia msg plugin noctalia/mpvpaper:service all resume";
    };
  };
}
