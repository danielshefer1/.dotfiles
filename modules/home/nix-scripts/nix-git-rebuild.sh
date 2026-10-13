# Usage: nix-git-rebuild [commit message]
# Commits everything in the dotfiles repo, rebuilds, then pushes. The rebuild
# still runs if there's nothing to commit. $DOTFILES overrides the repo location.

dotfiles="${DOTFILES:-$HOME/.dotfiles}"

git -C "$dotfiles" add . \
  && git -C "$dotfiles" commit -m "${1:-Update}" \
  || true

sudo nixos-rebuild switch --flake "$dotfiles"

# Only after a successful rebuild, so the other hosts never pull a broken config.
# A failed push (e.g. offline) only warns: the commit stays and goes out next time.
git -C "$dotfiles" push \
  || echo "warning: push failed, run 'git -C $dotfiles push' later" >&2
