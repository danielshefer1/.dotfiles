{ inputs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  # Installs the wrapped zen-beta package (Mod+B in niri/binds.nix)
  programs.zen-browser = {
    enable = true;
    # Adopt the existing profile instead of creating a fresh one
    profiles.default = {
      id = 0;
      name = "Default Profile";
      path = "un3b99vv.Default Profile";
      isDefault = true;
    };
  };
}
