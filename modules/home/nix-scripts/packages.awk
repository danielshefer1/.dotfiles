# Walks a file's `home.packages = ... [ ... ]` list. With list=1, prints each
# single-attr-path entry in canonical form (sans `pkgs.` and quotes, so
# `nur.repos."0x4A6F".foo` -> `nur.repos.0x4A6F.foo`); otherwise prints the
# file with every entry named in `remove` (newline-separated) dropped.
# Exits 3 if the list isn't found, 2 if some requested entry wasn't removed.

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
