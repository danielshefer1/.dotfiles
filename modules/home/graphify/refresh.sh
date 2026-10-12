# Git hook (post-merge, post-rewrite) for ~/Projects/personal-organizer: when main moves,
# regenerate the graphify graph and Obsidian export in the background. Never fails the git command.

hook=$(basename "$0")
# post-rewrite also fires on `commit --amend`; only a rebase (git pull with pull.rebase) counts
if [[ $hook == post-rewrite && ${1:-} != rebase ]]; then exit 0; fi
if [[ $(git branch --show-current) != main ]]; then exit 0; fi
top=$(git rev-parse --show-toplevel)
# Worktrees share these hooks; only the main checkout has graphify-out/
if [[ ! -d $top/graphify-out ]]; then exit 0; fi

cd "$top"
export PYTHONHASHSEED=0 # works around the graphify wrapper's re-exec bug (0.9.74)
# shellcheck disable=SC2016
setsid -f flock -n graphify-out/.refresh.lock "$BASH" -c '
  echo "== $(date -Is) $0"
  graphify update . && graphify export obsidian --dir "$HOME/Obsidian Vault/personal-organizer"
  echo "== exit $?"
' "$hook" >>graphify-out/refresh.log 2>&1 </dev/null || true
