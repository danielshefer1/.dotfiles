{ pkgs, ... }:
let
  # Regenerates personal-organizer's graphify graph and Obsidian export when main moves
  graphify-refresh = pkgs.writeShellApplication {
    name = "graphify-refresh";
    runtimeInputs = [
      pkgs.graphify
      pkgs.util-linux
      pkgs.git
      pkgs.coreutils
    ];
    text = builtins.readFile ./refresh.sh;
  };
  hook = "${graphify-refresh}/bin/graphify-refresh";
in
{
  # Per-repo hooks, not programs.git.hooks: that sets a global core.hooksPath, which disables every repo's own .git/hooks
  home.file."Projects/personal-organizer/.git/hooks/post-merge".source = hook;
  home.file."Projects/personal-organizer/.git/hooks/post-rewrite".source = hook;
}
