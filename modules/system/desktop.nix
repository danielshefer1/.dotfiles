{ ... }:

{
  # System-wide Niri integration
  programs.niri.enable = true;

  # Setuid pkexec wrapper (opt-in on recent nixpkgs), needed by GUI apps like gparted
  security.polkit.enablePkexecWrapper = true;

  # Display Manager / Greeter (noctalia-greeter sets greetd's default_session command)
  services.displayManager.noctalia-greeter = {
    enable = true;
    # Let Noctalia sync its theme to the greeter without an admin prompt
    passwordlessSyncUsers = [ "daniels" ];
  };
  services.greetd = {
    enable = true;
    settings.default_session.user = "greeter";
  };
}
