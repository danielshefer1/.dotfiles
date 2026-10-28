{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.starship;
  # Starship is a community template since noctalia 5.4, downloaded at runtime rather than shipped in the package
  noctaliaApply = "${config.xdg.stateHome}/noctalia/community-templates/starship/apply.sh";
  hookPath = lib.makeBinPath (
    with pkgs;
    [
      coreutils
      diffutils
      findutils
      gawk
      gnugrep
      gnused
    ]
  );
in
{
  # Noctalia's hook rewrites the palette block inside starship.toml, so it has to be a writable file
  # instead of a store symlink: write it on every switch and let the hook fill in the palette.
  home.file.${cfg.configPath}.enable = lib.mkForce false;
  home.activation.starshipWritableConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run rm -f $VERBOSE_ARG "${cfg.configPath}"
    run install -m644 ${
      (pkgs.formats.toml { }).generate "starship.toml" cfg.settings
    } "${cfg.configPath}"
    # Activation's PATH lacks awk and friends, which the hook needs
    run ${pkgs.coreutils}/bin/env PATH="${hookPath}:$PATH" ${pkgs.bash}/bin/bash ${noctaliaApply} || true
  '';
}
