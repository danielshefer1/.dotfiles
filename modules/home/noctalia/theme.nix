{ ... }:

{
  # Only the default theme: anything picked in the settings GUI overrides it and survives
  # rebuilds (see gui-settings.nix). Templates (templates/) follow whatever is active.
  programs.noctalia.settings.theme = {
    mode = "dark";
    source = "community";
    community_palette = "Paradise";
  };
}
