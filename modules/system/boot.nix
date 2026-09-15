{ ... }:

{
  boot.loader = {
    systemd-boot.enable = false;

    limine = {
      enable = true;
      enableEditor = true;

      maxGenerations = 5;
      extraEntries = ''
        /Windows
            protocol: efi
            path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
    efi.canTouchEfiVariables = true;
  };
}
