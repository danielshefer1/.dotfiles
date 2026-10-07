{ ... }:

{
  programs.noctalia.settings.shell = {
    polkit_agent = true;
    screen_corners.enabled = true;
    screenshot.confirm_region = true;
    # Push wallpaper/palette/font changes to noctalia-greeter automatically
    greeter_sync.auto_sync = true;
  };
}
