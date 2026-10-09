{ inputs, pkgs, ... }:

let
  torlink = inputs.torlink.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [
    # Sort FitGirl search by relevance so older exact-title posts aren't missed.
    # Drop the patch once https://github.com/baairon/torlink/issues/197 is fixed upstream.
    /*
      (torlink.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./fitgirl-relevance.patch ];
      }))
    */
  ];
}
