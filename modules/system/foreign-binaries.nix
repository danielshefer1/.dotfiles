{ ... }:

{
  # Runs dynamically linked binaries that weren't built for NixOS
  programs.nix-ld.enable = true;
  # Resolves /bin/bash, /usr/bin/python3, etc. via PATH for scripts with FHS shebangs
  services.envfs.enable = true;
}
