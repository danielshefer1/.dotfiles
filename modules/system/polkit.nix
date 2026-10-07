{ ... }:

{
  # Setuid pkexec wrapper (opt-in on recent nixpkgs), needed by GUI apps like gparted
  security.polkit.enablePkexecWrapper = true;
}
