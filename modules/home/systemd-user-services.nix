{ pkgs, ... }:

{
  # rclone CLI, for `rclone config` etc. alongside the mount service
  home.packages = [ pkgs.rclone ];

  systemd.user.services = {
    rclone-gdrive = {
      Unit = {
        Description = "Rclone Google Drive Mount";
        After = [ "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        Type = "notify";
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive";
        ExecStart = ''
          ${pkgs.rclone}/bin/rclone mount gdrive: %h/GoogleDrive \
            --vfs-cache-mode full \
            --vfs-cache-max-age 24h \
            --vfs-read-chunk-size 64M \
            --vfs-read-chunk-size-limit 1G
        '';
        ExecStop = "/run/wrappers/bin/fusermount -u %h/GoogleDrive";
        Restart = "on-failure";
        RestartSec = "10s";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    link-eden-world = {
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
  };
}
