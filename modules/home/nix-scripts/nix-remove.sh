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

  if ! awk -v remove="$remove" -f "$PACKAGES_AWK" "$nix_file" > "$tmp"; then
    echo "error: failed to remove the selected packages from $nix_file" >&2
    exit 1
  fi
  cat "$tmp" > "$nix_file"   # keeps permissions / symlinks intact

  # Drop the topic file once its list is empty
  if [ -z "$(awk -v list=1 -f "$PACKAGES_AWK" "$nix_file")" ]; then
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
