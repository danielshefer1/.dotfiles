{ inputs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";

    # Themed by noctalia templates instead (see noctalia.nix)
    kitty.enable = false;
    starship.enable = false;
    kvantum.enable = false;
  };
}
