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

  nix-add = pkgs.writeShellApplication {
    name = "nix-add";
    runtimeInputs = [
      fzf-nixpkgs
      pkgs.gawk
      pkgs.coreutils
    ];
    text = ''
      nix_file="''${NIX_ADD_FILE:-$HOME/.dotfiles/home.nix}"

      # Pass args through (e.g. --refresh)
      pkg=$(fzf-nixpkgs "$@") || exit 0
      [ -n "$pkg" ] || exit 0

      if [ ! -f "$nix_file" ]; then
        echo "error: $nix_file not found" >&2
        exit 1
      fi

      tmp=$(mktemp)
      trap 'rm -f "$tmp"' EXIT

      # Find `home.packages = ... [`, follow bracket depth to its closing `]`,
      # insert the package just before it with the list's indentation.
      # Uses a `pkgs.` prefix unless the list is `with pkgs; [ ... ]`.
      if awk -v pkg="$pkg" '
        function count(s, re,   t) { t = s; return gsub(re, "", t) }

        !done && !inlist && /home\.packages[[:space:]]*=/ {
          inlist = 1; depth = 0
          prefix = ($0 ~ /with[[:space:]]+pkgs[[:space:]]*;/) ? "" : "pkgs."
        }

        inlist && !done {
          line = $0; sub(/#.*/, "", line)

          n = split(line, toks, /[[:space:]]+/)
          for (i = 1; i <= n; i++)
            if (toks[i] == pkg || toks[i] == "pkgs." pkg) dup = 1

          newdepth = depth + count(line, "\\[") - count(line, "\\]")

          if (depth > 0 && newdepth == 0) {
            if (line !~ /^[[:space:]]*\]/) {
              bad = 1
            } else {
              if (indent == "") {
                match($0, /^[[:space:]]*/)
                indent = substr($0, 1, RLENGTH) "  "
              }
              if (!dup) print indent prefix pkg
            }
            done = 1; inlist = 0
          } else if (depth == 1 && newdepth == 1 && line ~ /[^[:space:]]/) {
            match($0, /^[[:space:]]*/)
            indent = substr($0, 1, RLENGTH)
          }
          depth = newdepth
        }

        { print }

        END {
          if (!done || bad) exit 3
          if (dup) exit 2
        }
      ' "$nix_file" > "$tmp"; then
        rc=0
      else
        rc=$?
      fi

      case "$rc" in
        0)
          cat "$tmp" > "$nix_file"   # keeps permissions / symlinks intact
          echo "Added '$pkg' to $nix_file" >&2
          ;;
        2)
          echo "'$pkg' is already in $nix_file, skipping" >&2
          exit 0
          ;;
        *)
          echo "error: couldn't find a multi-line home.packages list" \
               "with ']' on its own line in $nix_file" >&2
          exit 1
          ;;
      esac

      exec nix-git-rebuild
    '';
  };
in
{
  home.packages = [
    fzf-nixpkgs
    nix-add
  ];
}
