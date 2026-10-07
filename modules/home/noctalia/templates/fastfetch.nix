{
  config,
  lib,
  pkgs,
  ...
}:

{
  # The fastfetch template's hook merges colors into config.jsonc and bails if it doesn't exist.
  # An empty object keeps fastfetch's default modules.
  home.activation.fastfetchNoctaliaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    fastfetch_config="${config.xdg.configHome}/fastfetch/config.jsonc"
    if [ ! -e "$fastfetch_config" ]; then
      run install -D -m644 ${pkgs.writeText "fastfetch-config.jsonc" "{}\n"} "$fastfetch_config"
    fi
  '';
}
