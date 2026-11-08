{ ... }:

{
  # Dual-boot entry for the Windows install on this machine's EFI partition
  boot.loader.limine.extraEntries = ''
    /Windows
        protocol: efi
        path: guid(2c13faf5-950c-460a-9622-fc81c6836416):/EFI/Microsoft/Boot/bootmgfw.efi
  '';
}
