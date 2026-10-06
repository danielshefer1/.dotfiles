{ ... }:
let
  # Opens `cmd` in kitty. On a non-zero exit the window waits for Enter, so
  # errors (e.g. a failed rebuild) stay readable instead of vanishing.
  inKitty = title: cmd: ''kitty --title ${title} bash -c "${cmd} || read -rp '${title} failed, press Enter to close'"'';
in
{
  # Picked up by the Noctalia launcher (and anything else reading .desktop files)
  xdg.desktopEntries = {
    torlnk = {
      name = "torlnk";
      comment = "Run torlnk";
      exec = inKitty "torlnk" "npx torlnk";
      icon = "folder-download";
      categories = [ "Utility" ];
    };

    fzf-claude = {
      name = "fzf-claude";
      comment = "Pick a directory and start Claude Code there";
      exec = inKitty "fzf-claude" "fzf-claude";
      icon = "utilities-terminal";
      categories = [ "Development" ];
    };

    nix-add = {
      name = "nix-add";
      comment = "Add a package to the dotfiles and rebuild";
      exec = inKitty "nix-add" "nix-add";
      icon = "list-add";
      categories = [ "System" ];
    };

    nix-remove = {
      name = "nix-remove";
      comment = "Remove packages from the dotfiles and rebuild";
      exec = inKitty "nix-remove" "nix-remove";
      icon = "list-remove";
      categories = [ "System" ];
    };
  };
}
