{ pkgs, ... }:
let
  fzf-nixpkgs = pkgs.writeShellApplication {
    name = "fzf-nixpkgs";
    runtimeInputs = with pkgs; [
      fzf
      jq
      coreutils
      findutils
    ];
    text = ''
      cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/fzf-nixpkgs"
      cache="$cache_dir/packages.tsv"
      mkdir -p "$cache_dir"

      # Rebuild if missing, older than a day, or --refresh given
      if [ ! -s "$cache" ] || [ "''${1:-}" = "--refresh" ] \
         || [ -n "$(find "$cache" -mtime +1)" ]; then
        echo "Indexing nixpkgs..." >&2
        nix search nixpkgs '^' --json \
          | jq -r 'to_entries[]
              | [(.key | split(".") | .[2:] | join(".")),
                 .value.version,
                 (.value.description // "")] | @tsv' \
          > "$cache.tmp"
        mv "$cache.tmp" "$cache"
      fi

      pkg=$(fzf --delimiter='\t' \
              --preview 'echo {3}' --preview-window=down,3,wrap \
              < "$cache" | cut -f1) || exit 0

      if [ -n "$pkg" ]; then
        echo "$pkg"
      fi
    '';
  };
in
{
  home.packages = [ fzf-nixpkgs ];
}
