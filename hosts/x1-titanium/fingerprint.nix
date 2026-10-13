{ ... }:

{
  # Synaptics 06cb:00c2 reader; enables fingerprint auth for every PAM service (greetd, sudo, polkit, lock screen)
  services.fprintd.enable = true;
}
