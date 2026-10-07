# Lists the modules in `dir` for `imports`: every .nix file except default.nix, plus every
# subfolder with a default.nix. Folders without one (templates, shared derivations) are skipped.
dir:
let
  entries = builtins.readDir dir;
  isModule =
    name: type:
    if type == "directory" then
      builtins.pathExists (dir + "/${name}/default.nix")
    else
      name != "default.nix" && builtins.match ".*\\.nix" name != null;
in
map (name: dir + "/${name}") (
  builtins.filter (name: isModule name entries.${name}) (builtins.attrNames entries)
)
