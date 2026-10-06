{ pkgs, ... }:
let
  # Picks a package from nixpkgs + NUR (as `nur.repos.<owner>.<pkg>`) and
  # prints its dotted attr path. Each source is cached separately as
  # `attr \t version \t description \t source`.
  fzf-packages = pkgs.writeShellApplication {
    name = "fzf-packages";
    runtimeInputs = with pkgs; [
      fzf
      jq
      curl
      coreutils
      findutils
    ];
    text = ''
      cache_dir="''${XDG_CACHE_HOME:-$HOME/.cache}/fzf-packages"
      mkdir -p "$cache_dir"

      nur_index=https://raw.githubusercontent.com/nix-community/nur-search/master/data/packages.json

      index_nixpkgs() {
        nix search nixpkgs '^' --json \
          | jq -r 'to_entries[]
              | [(.key | split(".") | .[2:] | join(".")),
                 .value.version,
                 (.value.description // ""),
                 "nixpkgs"] | @tsv'
      }

      # Keys are already full attr paths (nur.repos.<owner>.<pkg>)
      index_nur() {
        curl -fsSL "$nur_index" \
          | jq -r 'to_entries[]
              | select(.value.meta.broken != true)
              | [.key,
                 (.value.version // ""),
                 (.value.meta.description // ""),
                 "nur"] | @tsv'
      }

      # Rebuild if missing, older than a day, or --refresh given.
      # On failure, keep whatever cache was there.
      refresh() {
        local cache="$cache_dir/$1.tsv"
        if [ ! -s "$cache" ] || [ "''${2:-}" = "--refresh" ] \
           || [ -n "$(find "$cache" -mtime +1)" ]; then
          echo "Indexing $1..." >&2
          if "index_$1" > "$cache.tmp" && [ -s "$cache.tmp" ]; then
            mv "$cache.tmp" "$cache"
          else
            rm -f "$cache.tmp"
            echo "warning: couldn't index $1" >&2
          fi
        fi
      }

      sources=()
      for s in nixpkgs nur; do
        refresh "$s" "''${1:-}"
        if [ -s "$cache_dir/$s.tsv" ]; then
          sources+=("$cache_dir/$s.tsv")
        fi
      done

      if [ ''${#sources[@]} -eq 0 ]; then
        echo "error: no package index available" >&2
        exit 1
      fi

      pkg=$(cat "''${sources[@]}" \
              | fzf --delimiter='\t' --with-nth=1,2,4 \
                    --preview 'echo {3}' --preview-window=down,3,wrap \
              | cut -f1) || exit 0

      if [ -n "$pkg" ]; then
        echo "$pkg"
      fi
    '';
  };

  # Walks a file's `home.packages = ... [ ... ]` list. With list=1, prints each
  # single-attr-path entry in canonical form (sans `pkgs.` and quotes, so
  # `nur.repos."0x4A6F".foo` -> `nur.repos.0x4A6F.foo`); otherwise prints the
  # file with every entry named in `remove` (newline-separated) dropped.
  # Exits 3 if the list isn't found, 2 if some requested entry wasn't removed.
  packages-awk = pkgs.writeText "packages.awk" ''
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
          && line ~ /^[[:space:]]*[A-Za-z0-9_.+"-]+[[:space:]]*$/) {
        pkg = line; gsub(/[[:space:]]/, "", pkg); sub(/^pkgs\./, "", pkg)
        gsub(/"/, "", pkg)
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
  '';

  # Shared by nix-add / nix-remove: locating the topic files under
  # modules/home/packages (one `home.packages` list per topic).
  packages-lib = ''
    pkg_dir="''${NIX_ADD_DIR:-$HOME/.dotfiles/modules/home/packages}"

    if [ ! -d "$pkg_dir" ]; then
      echo "error: $pkg_dir not found" >&2
      exit 1
    fi

    dotfiles="$(git -C "$pkg_dir" rev-parse --show-toplevel)"

    # Topic names (file names without .nix), default.nix excluded
    topics() {
      local f
      for f in "$pkg_dir"/*.nix; do
        [ -e "$f" ] || continue
        [ "$(basename "$f")" = default.nix ] && continue
        basename "$f" .nix
      done
    }

    # `<pkg>\t<topic>` for every package in every topic file
    installed() {
      local t p list
      while read -r t; do
        [ -n "$t" ] || continue
        if ! list=$(awk -v list=1 -f ${packages-awk} "$pkg_dir/$t.nix"); then
          echo "warning: no home.packages list in $pkg_dir/$t.nix, skipping" >&2
          continue
        fi
        while read -r p; do
          [ -n "$p" ] && printf '%s\t%s\n' "$p" "$t"
        done <<< "$list"
      done <<< "$(topics)"
    }

    # Canonical dotted attr path -> Nix syntax, quoting segments that aren't
    # plain identifiers (e.g. NUR owners like `0x4A6F`)
    nix_attr() {
      awk -F. '{
        for (i = 1; i <= NF; i++) {
          s = $i
          if (s !~ /^[A-Za-z_][A-Za-z0-9_-]*$/ \
              || s ~ /^(if|then|else|assert|with|let|in|rec|inherit)$/)
            s = "\"" s "\""
          printf "%s%s", (i > 1 ? "." : ""), s
        }
        print ""
      }' <<< "$1"
    }
  '';

  nix-add = pkgs.writeShellApplication {
    name = "nix-add";
    runtimeInputs = [
      fzf-packages
      pkgs.fzf
      pkgs.gawk
      pkgs.coreutils
      pkgs.gnused
      pkgs.git
    ];
    text = ''
      ${packages-lib}

      # Pass args through (e.g. --refresh)
      pkg=$(fzf-packages "$@") || exit 0
      [ -n "$pkg" ] || exit 0
      attr=$(nix_attr "$pkg")

      existing=$(installed | awk -F'\t' -v p="$pkg" '$1 == p { print $2 }')
      if [ -n "$existing" ]; then
        echo "'$pkg' is already in $existing, skipping" >&2
        exit 0
      fi

      # Pick a topic, or type a new name to create it. --print-query puts the
      # typed query on line 1 and the selection (if any) on line 2.
      if out=$(fzf --print-query --prompt="topic for $pkg> " \
                 --header='Enter to pick, or type a new name to create it' \
                 --preview "cat '$pkg_dir'/{}.nix" \
                 <<< "$(topics)"); then
        topic=$(sed -n 2p <<< "$out")
      elif [ $? -eq 1 ]; then
        topic=$(sed -n 1p <<< "$out")   # no match: use what was typed
      else
        exit 0                          # Esc / Ctrl-C
      fi

      if ! [[ "$topic" =~ ^[A-Za-z0-9_-]+$ ]] || [ "$topic" = default ]; then
        echo "error: invalid topic name '$topic'" >&2
        exit 1
      fi

      # The NUR index tracks NUR's latest; bump the pinned input so it has $pkg
      if [[ "$pkg" == nur.repos.* ]]; then
        nix flake update nur --flake "$dotfiles"
      fi

      nix_file="$pkg_dir/$topic.nix"

      if [ ! -e "$nix_file" ]; then
        cat > "$nix_file" <<EOF
      { pkgs, ... }:

      {
        home.packages = with pkgs; [
          $attr
        ];
      }
      EOF
        echo "Created topic '$topic' with '$pkg'" >&2
      else
        tmp=$(mktemp)
        trap 'rm -f "$tmp"' EXIT

        # Find `home.packages = ... [`, follow bracket depth to its closing `]`,
        # insert the package just before it with the list's indentation.
        # Uses a `pkgs.` prefix unless the list is `with pkgs; [ ... ]`.
        if ! awk -v pkg="$attr" '
          function count(s, re,   t) { t = s; return gsub(re, "", t) }

          !done && !inlist && /home\.packages[[:space:]]*=/ {
            inlist = 1; depth = 0
            prefix = ($0 ~ /with[[:space:]]+pkgs[[:space:]]*;/) ? "" : "pkgs."
          }

          inlist && !done {
            line = $0; sub(/#.*/, "", line)
            newdepth = depth + count(line, "\\[") - count(line, "\\]")

            if (depth > 0 && newdepth == 0) {
              if (line !~ /^[[:space:]]*\]/) {
                bad = 1
              } else {
                if (indent == "") {
                  match($0, /^[[:space:]]*/)
                  indent = substr($0, 1, RLENGTH) "  "
                }
                print indent prefix pkg
              }
              done = 1; inlist = 0
            } else if (depth == 1 && newdepth == 1 && line ~ /[^[:space:]]/) {
              match($0, /^[[:space:]]*/)
              indent = substr($0, 1, RLENGTH)
            }
            depth = newdepth
          }

          { print }

          END { if (!done || bad) exit 3 }
        ' "$nix_file" > "$tmp"; then
          echo "error: couldn't find a multi-line home.packages list" \
               "with ']' on its own line in $nix_file" >&2
          exit 1
        fi

        cat "$tmp" > "$nix_file"   # keeps permissions / symlinks intact
        echo "Added '$pkg' to $topic" >&2
      fi

      # Same as the nix-git alias; `|| true` mirrors the `;` in nix-git-rebuild,
      # so the rebuild still runs even if there's nothing to commit.
      git -C "$dotfiles" add . \
        && git -C "$dotfiles" commit -m "Add $pkg to $topic" \
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
      ${packages-lib}

      all=$(installed)
      if [ -z "$all" ]; then
        echo "No packages found in $pkg_dir" >&2
        exit 0
      fi

      # Align the topic column past the longest name (NUR paths run long)
      width=$(awk -F'\t' 'length($1) > w { w = length($1) } END { print w + 2 }' <<< "$all")

      # Tab / Shift-Tab to mark several
      selected=$(fzf --multi --prompt='remove> ' \
                   --delimiter='\t' --tabstop="$width" \
                   --header='Tab to select multiple, Enter to remove' \
                   <<< "$all") || exit 0
      [ -n "$selected" ] || exit 0

      tmp=$(mktemp)
      trap 'rm -f "$tmp"' EXIT

      while read -r topic; do
        nix_file="$pkg_dir/$topic.nix"
        remove=$(awk -F'\t' -v t="$topic" '$2 == t { print $1 }' <<< "$selected")

        if ! awk -v remove="$remove" -f ${packages-awk} "$nix_file" > "$tmp"; then
          echo "error: failed to remove the selected packages from $nix_file" >&2
          exit 1
        fi
        cat "$tmp" > "$nix_file"   # keeps permissions / symlinks intact

        # Drop the topic file once its list is empty
        if [ -z "$(awk -v list=1 -f ${packages-awk} "$nix_file")" ]; then
          rm "$nix_file"
          echo "Removed empty topic '$topic'" >&2
        fi
      done <<< "$(cut -f2 <<< "$selected" | sort -u)"

      names=$(cut -f1 <<< "$selected" | paste -sd' ')
      echo "Removed $names" >&2

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
    fzf-packages
    nix-add
    nix-remove
  ];

  programs.zsh.shellAliases = {
    nix-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles#nixos";
    nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";

    nix-git = "git -C $HOME/.dotfiles add . && git -C $HOME/.dotfiles commit -m 'Update'";
    nix-git-rebuild = "nix-git ; sudo nixos-rebuild switch --flake ~/.dotfiles#nixos";
  };
}
