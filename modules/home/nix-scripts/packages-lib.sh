# Shared by nix-add / nix-remove: locating the topic files under
# modules/home/packages (one `home.packages` list per topic).
# $PACKAGES_AWK points at packages.awk.

pkg_dir="${NIX_ADD_DIR:-$HOME/.dotfiles/modules/home/packages}"

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
    if ! list=$(awk -v list=1 -f "$PACKAGES_AWK" "$pkg_dir/$t.nix"); then
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
