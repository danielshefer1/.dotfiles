{
  config,
  lib,
  pkgs,
  ...
}:

let
  settings = "${config.xdg.configHome}/vesktop/settings/settings.json";
in
{
  # Enable Noctalia's Midnight Discord theme (rounded, unlike its System24 one). Vencord writes the
  # rest of settings.json from its GUI, so only enabledThemes is set here. Close Vesktop before
  # rebuilding: a running Vesktop writes its own copy back on the next settings change.
  home.activation.vesktopTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -v DRY_RUN ]; then
      if [ -f "${settings}" ]; then
        ${pkgs.jq}/bin/jq '.enabledThemes = ["noctalia.theme.css"]' "${settings}" > "${settings}.tmp"
        mv "${settings}.tmp" "${settings}"
      else
        mkdir -p "$(dirname "${settings}")"
        echo '{"enabledThemes":["noctalia.theme.css"]}' > "${settings}"
      fi
    fi
  '';
}
