{ pkgs, ... }:
let
  # Fuzzy-picks a directory under the given root (default: $HOME) and starts
  # Claude Code there. Any further args are passed through to claude.
  #   fzf-claude                 # pick under ~
  #   fzf-claude ~/src           # pick under ~/src
  #   fzf-claude . --continue    # pick under cwd, resume last session
  fzf-claude = pkgs.writeShellApplication {
    name = "fzf-claude";
    # claude itself comes from PATH, so this follows the installed version
    runtimeInputs = with pkgs; [
      fd
      fzf
      eza
    ];
    text = ''
      root="''${1:-$HOME}"
      [ $# -gt 0 ] && shift

      if [ ! -d "$root" ]; then
        echo "error: $root is not a directory" >&2
        exit 1
      fi
      cd "$root"

      # Root itself first, then every subdirectory (hidden included,
      # .gitignore'd paths and VCS/dependency dirs skipped)
      dir=$( { echo .; fd --type d --hidden \
                          --exclude .git --exclude node_modules \
                          --exclude .cache --exclude .direnv; } \
             | fzf --prompt="claude in $(basename "$PWD")/> " \
                   --preview 'eza --tree --level=2 --icons --color=always \
                                  --group-directories-first {}' ) || exit 0
      [ -n "$dir" ] || exit 0

      cd "$dir"
      exec claude "$@"
    '';
  };
in
{
  home.packages = [ fzf-claude ];
}
