{ inputs, ... }:

{
  # nixos-hardware has no X1 Titanium profile; it's Tiger Lake like the X1 Nano Gen 1, so use the same pieces
  imports = with inputs.nixos-hardware.nixosModules; [
    lenovo-thinkpad
    common-cpu-intel
    common-pc-laptop
    common-pc-ssd
  ];
}
