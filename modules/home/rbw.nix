{ pkgs, ... }:

{
  # Terminal client for the Bitwarden vault; API keys live there next to passwords
  programs.rbw = {
    enable = true;
    settings = {
      email = "dandanshefer@gmail.com";
      pinentry = pkgs.pinentry-gnome3;
    };
  };

  programs.zsh.initContent = ''
    # withkey VAR item cmd...: run cmd with VAR set to the rbw entry `item`
    withkey() {
      local var=$1 item=$2 val
      shift 2
      val=$(rbw get "$item") || return
      env "$var=$val" "$@"
    }
  '';
}
