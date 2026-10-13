{ ... }:

{
  # Dual-boot entry for the Windows install on this machine's EFI partition
  boot.loader.limine.extraEntries = ''
    /Windows
        protocol: efi
        path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
  '';
}
