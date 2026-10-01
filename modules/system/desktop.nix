{ pkgs, ... }:

{
  # System-wide Niri integration
  programs.niri.enable = true;

  # Setuid pkexec wrapper (opt-in on recent nixpkgs), needed by GUI apps like gparted
  security.polkit.enablePkexecWrapper = true;

  # Display Manager / Greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --user-menu --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };
}
