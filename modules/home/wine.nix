{ config, pkgs, ... }:

{
  home.sessionVariables = {
    WINEPREFIX = "$HOME/.local/share/wineprefixes/default";
    WINEARCH = "win64";
  };

  home.activation.initWinePrefix = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    export WINEPREFIX="$HOME/.local/share/wineprefixes/default"
    export WINEARCH="win64"
    if [ ! -d "$WINEPREFIX" ]; then
      echo "Initializing 64-bit Wine prefix at $WINEPREFIX..."
      ${pkgs.wineWow64Packages.stable}/bin/wineboot --init
    fi
  '';
}
