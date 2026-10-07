{
  config,
  lib,
  pkgs,
  ...
}:

let
  noctaliaTheme = pkgs.vscode-marketplace.noctalia.noctaliatheme;
in
{
  # Noctalia's vscode template rewrites this extension's theme file in place, so it gets a writable
  # copy at the exact path the template targets instead of a store symlink (-n keeps a theme file
  # noctalia already rendered). Dropping extensions.json makes VS Code rescan and register it.
  home.activation.noctaliaVscodeTheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    extensions="${config.home.homeDirectory}/.vscode/extensions"
    theme_dir="$extensions/noctalia.noctaliatheme-0.0.5"
    if [ ! -e "$theme_dir/package.json" ]; then
      run mkdir -p "$theme_dir"
      run cp -r -n --no-preserve=mode ${noctaliaTheme}/share/vscode/extensions/noctalia.noctaliatheme/. "$theme_dir"
      run rm -f $VERBOSE_ARG "$extensions/extensions.json"
    fi
  '';
}
