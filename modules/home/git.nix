{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Daniel Shefer";
        email = "dandanshefer@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      # Authenticate HTTPS pushes with the token from `gh auth login`
      credential."https://github.com".helper = "!gh auth git-credential";
      core.editor = "nvim";

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        cm = "commit -m";
        lg = "log --oneline --graph --decorate --all";
      };
    };

    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      "result"
    ];
  };
}
