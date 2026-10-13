{ ... }:

{
  boot.loader = {
    systemd-boot.enable = false;

    limine = {
      enable = true;
      enableEditor = true;

      maxGenerations = 5;
    };
    efi.canTouchEfiVariables = true;
  };
}
