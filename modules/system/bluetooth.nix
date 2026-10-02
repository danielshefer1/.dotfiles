{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Automatically turn on Bluetooth at boot
    settings.General.Experimental = true;
  };
}
