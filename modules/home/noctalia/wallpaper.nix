{
  config,
  lib,
  pkgs,
  ...
}:

let
  # 1512p re-encode of the moewalls 4K original: just covers the laptop's 2256x1504 panel
  video = ./wallpapers/black-cat-blue-sky.mp4;

  # Shown until the mpvpaper plugin starts the video (it then swaps in its own extracted frame)
  still = pkgs.runCommand "black-cat-blue-sky.jpg" { nativeBuildInputs = [ pkgs.ffmpeg ]; } ''
    ffmpeg -loglevel error -ss 1 -i ${video} -frames:v 1 -q:v 2 -f mjpeg $out
  '';
in
{
  programs.noctalia.settings = {
    wallpaper.default.path = "${still}";

    # While a video plays, the plugin keeps a frame of it as Noctalia's wallpaper, which the lock
    # screen draws and greeter_sync pushes to the login screen. Only pause the video while locked:
    # clearing it would swap the wallpaper and play a wallpaper transition behind the unlock.
    hooks = {
      session_locked = "noctalia msg plugin noctalia/mpvpaper:service all pause";
      session_unlocked = "noctalia msg plugin noctalia/mpvpaper:service all resume";
    };
  };

  # The mpvpaper plugin keeps its video in its own state file, read when noctalia starts. Point it
  # at the video above whenever that changes, so a video picked in the GUI lasts until then.
  home.activation.noctaliaVideoWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    dir="${config.xdg.stateHome}/noctalia/mpvpaper"
    if [ "$(cat "$dir/.nix-video" 2>/dev/null)" != "${video}" ] && [ ! -v DRY_RUN ]; then
      mkdir -p "$dir"
      echo '{"assignments":{"*":"${video}"}}' > "$dir/assignments.json"
      echo "${video}" > "$dir/.nix-video"
    fi
  '';
}
