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
      pkgs.git
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

      dotfiles="$(dirname "$nix_file")"

      # Same as the nix-git alias; `|| true` mirrors the `;` in nix-git-rebuild,
      # so the rebuild still runs even if there's nothing to commit.
      git -C "$dotfiles" add . \
        && git -C "$dotfiles" commit -m "Add $pkg" \
        || true

      exec sudo nixos-rebuild switch --flake "$dotfiles#nixos"
    '';
  };

  nix-remove = pkgs.writeShellApplication {
    name = "nix-remove";
    runtimeInputs = with pkgs; [
      fzf
      gawk
      coreutils
      git
    ];
    text = ''
      nix_file="''${NIX_ADD_FILE:-$HOME/.dotfiles/home.nix}"

      if [ ! -f "$nix_file" ]; then
        echo "error: $nix_file not found" >&2
        exit 1
      fi

      # Walks the `home.packages = ... [ ... ]` list. With list=1, prints each
      # single-identifier entry (sans `pkgs.`); otherwise prints the file with
      # every entry named in `remove` (newline-separated) dropped.
      # Exits 3 if the list isn't found, 2 if some requested entry wasn't removed.
      # shellcheck disable=SC2016
      packages_awk='
        function count(s, re,   t) { t = s; return gsub(re, "", t) }

        BEGIN {
          n = split(remove, r, "\n")
          for (i = 1; i <= n; i++) if (r[i] != "") { want[r[i]] = 1; nwant++ }
        }

        !done && !inlist && /home\.packages[[:space:]]*=/ { inlist = 1; depth = 0 }

        inlist && !done {
          line = $0; sub(/#.*/, "", line)
          opens = count(line, "\\[")
          newdepth = depth + opens - count(line, "\\]")

          if (depth == 1 && newdepth == 1 \
              && line ~ /^[[:space:]]*[A-Za-z0-9_.+-]+[[:space:]]*$/) {
            pkg = line; gsub(/[[:space:]]/, "", pkg); sub(/^pkgs\./, "", pkg)
            if (list) print pkg
            else if ((pkg in want) && !(pkg in gone)) { gone[pkg] = 1; ngone++; next }
          }

          if (newdepth == 0 && (depth > 0 || opens > 0)) { done = 1; inlist = 0 }
          depth = newdepth
        }

        !list { print }

        END {
          if (!done) exit 3
          if (!list && ngone != nwant) exit 2
        }
      '

      if ! installed=$(awk -v list=1 "$packages_awk" "$nix_file"); then
        echo "error: couldn't find a multi-line home.packages list in $nix_file" >&2
        exit 1
      fi
      if [ -z "$installed" ]; then
        echo "No packages found in home.packages of $nix_file" >&2
        exit 0
      fi

      # Tab / Shift-Tab to mark several
      selected=$(fzf --multi --prompt='remove> ' \
                   --header='Tab to select multiple, Enter to remove' \
                   <<< "$installed") || exit 0
      [ -n "$selected" ] || exit 0

      tmp=$(mktemp)
      trap 'rm -f "$tmp"' EXIT

      if ! awk -v remove="$selected" "$packages_awk" "$nix_file" > "$tmp"; then
        echo "error: failed to remove the selected packages from $nix_file" >&2
        exit 1
      fi

      cat "$tmp" > "$nix_file"   # keeps permissions / symlinks intact

      names=$(paste -sd' ' <<< "$selected")
      echo "Removed $names from $nix_file" >&2

      dotfiles="$(dirname "$nix_file")"

      git -C "$dotfiles" add . \
        && git -C "$dotfiles" commit -m "Remove $names" \
        || true

      # Rebuild first so the removed packages drop out of the current
      # generation, then clean (same as the nix-clean alias).
      sudo nixos-rebuild switch --flake "$dotfiles#nixos"
      sudo nix-collect-garbage -d
      nix-collect-garbage -d
    '';
  };
in
{
  home.packages = [
    fzf-nixpkgs
    nix-add
    nix-remove
  ];
}
