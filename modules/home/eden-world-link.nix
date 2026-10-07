{ ... }:

{
  # Uncomment to keep the Minecraft world 'Playing with Eden' on Google Drive
  # (needs the rclone-gdrive service in google-drive.nix)
  /*
    systemd.user.services.link-eden-world = {
      Unit = {
        Description = "Symlink Minecraft World 'Playing with Eden' to Google Drive";
        After = [ "rclone-gdrive.service" ];
        Requires = [ "rclone-gdrive.service" ];
      };

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.writeShellScript "link-eden-world" ''
          GDRIVE_WORLD="$HOME/GoogleDrive/Minecraft Worlds/Playing with Eden"
          SAVEDIR="$HOME/.local/share/PrismLauncher/instances/Playing with Eden/minecraft/saves"
          TARGET="$SAVEDIR/Playing with Eden"

          # Create target directories if missing
          ${pkgs.coreutils}/bin/mkdir -p "$GDRIVE_WORLD"
          ${pkgs.coreutils}/bin/mkdir -p "$SAVEDIR"

          # Backup existing local save folder if it isn't already a symlink
          if [ -d "$TARGET" ] && [ ! -L "$TARGET" ]; then
            ${pkgs.coreutils}/bin/mv "$TARGET" "''${TARGET}.bak"
          fi

          # Create the symlink
          ${pkgs.coreutils}/bin/ln -sfn "$GDRIVE_WORLD" "$TARGET"
        ''}";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  */
}
