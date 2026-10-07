cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-packages"
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
  if [ ! -s "$cache" ] || [ "${2:-}" = "--refresh" ] \
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
  refresh "$s" "${1:-}"
  if [ -s "$cache_dir/$s.tsv" ]; then
    sources+=("$cache_dir/$s.tsv")
  fi
done

if [ ${#sources[@]} -eq 0 ]; then
  echo "error: no package index available" >&2
  exit 1
fi

pkg=$(cat "${sources[@]}" \
        | fzf --delimiter='\t' --with-nth=1,2,4 \
              --preview 'echo {3}' --preview-window=down,3,wrap \
        | cut -f1) || exit 0

if [ -n "$pkg" ]; then
  echo "$pkg"
fi
