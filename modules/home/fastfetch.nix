{
  config,
  lib,
  pkgs,
  ...
}:

let
  # fastfetch 2.69 prints only the logo when config.jsonc has no "modules" list.
  modules = [
    "title"
    "separator"
    "os"
    "host"
    "kernel"
    "uptime"
    "packages"
    "shell"
    "display"
    "de"
    "wm"
    "wmtheme"
    "theme"
    "icons"
    "font"
    "cursor"
    "terminal"
    "terminalfont"
    "cpu"
    "gpu"
    "memory"
    "swap"
    "disk"
    "localip"
    "battery"
    "poweradapter"
    "locale"
    "break"
    "colors"
  ];
in
{
  # config.jsonc stays a writable file (not a store symlink) because noctalia's fastfetch
  # template hook merges its colors into it; this only sets "modules" and keeps the rest.
  home.activation.fastfetchConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    fastfetch_config="${config.xdg.configHome}/fastfetch/config.jsonc"
    fastfetch_tmp="$(mktemp)"
    if [ -e "$fastfetch_config" ]; then cat "$fastfetch_config"; else echo '{}'; fi \
      | ${pkgs.jq}/bin/jq --argjson modules '${builtins.toJSON modules}' '.modules = $modules' >"$fastfetch_tmp"
    run install -D -m644 "$fastfetch_tmp" "$fastfetch_config"
    rm -f "$fastfetch_tmp"
  '';
}
