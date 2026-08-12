{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11.0;
    };

    settings = {
      window_padding_width = 8;
      confirm_os_window_close = 0;
      hide_window_decorations = "yes";

      enable_audio_bell = false;
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";

      background_opacity = "0.8";
      dynamic_background_opacity = "yes";

      cursor_shape = "block";
      cursor_blink_interval = 0.5;
      cursor_trail = 3;
    };

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+equal" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
      "ctrl+0" = "change_font_size all 0";
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
