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

DOTFILES="$dotfiles" exec nix-git-rebuild "Add $pkg to $topic"
