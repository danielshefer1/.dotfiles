{
  config,
  lib,
  pkgs,
  ...
}:

let
  keepGuiState =
    pkgs.writers.writePython3 "noctalia-keep-gui-state"
      {
        libraries = [ pkgs.python3Packages.tomli-w ];
      }
      ''
        import sys
        import tomllib

        import tomli_w

        KEEP = ["theme", "wallpaper", "lockscreen_widgets"]

        src, dest = sys.argv[1:]
        with open(src, "rb") as f:
            old = tomllib.load(f)

        old.get("theme", {}).pop("templates", None)
        kept = {k: old[k] for k in KEEP if old.get(k)}
        if kept:
            if "config_version" in old:
                kept = {"config_version": old["config_version"], **kept}
            with open(dest, "wb") as f:
                tomli_w.dump(kept, f)
      '';
in
{
  # Settings GUI changes land in settings.toml, which overrides config.toml. Move it aside on every
  # switch so this folder stays the source of truth; GUI tweaks last until the next rebuild.
  # Diff the .bak against `noctalia config export` to find tweaks worth porting here.
  # The exceptions are carried over: the theme picked in the GUI ([theme], minus the declarative
  # theme.templates), the wallpaper and the lockscreen widget layout.
  home.activation.resetNoctaliaGuiSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="${config.xdg.stateHome}/noctalia/settings.toml"
    if [ -e "$settings" ]; then
      run mv $VERBOSE_ARG "$settings" "$settings.bak"
      run ${keepGuiState} "$settings.bak" "$settings"
    fi
  '';
}
