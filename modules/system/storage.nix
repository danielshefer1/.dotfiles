{ ... }:
{
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/d08ffa72-3913-4b91-9e2f-c911916f0cc1";
    fsType = "btrfs";
    options = [
      "compress=zstd"
      "noatime"
      "nofail"
    ];
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
}
