{ pkgs, ... }:

{
  # rclone CLI, for `rclone config` etc. alongside the mount service
  home.packages = [ pkgs.rclone ];

  # Uncomment to mount Google Drive at ~/GoogleDrive
  /*
    systemd.user.services.rclone-gdrive = {
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
  */
}
