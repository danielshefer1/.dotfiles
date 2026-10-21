{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
      # LazyVim dependencies
      git
      gcc
      gnumake
      unzip
      ripgrep
      fd
      lazygit
      tree-sitter
      nodejs
      # LSPs / formatters, installed by Nix instead of Mason (see nvim/lua/plugins/nix.lua)
      lua-language-server
      stylua
      nil
      nixfmt
      clang-tools # clangd, clang-format
      nasm
      rust-analyzer
      pyright
      ruff
      vtsls
      dockerfile-language-server
      docker-compose-language-service
      hadolint
      vscode-langservers-extracted # jsonls
      yaml-language-server
      taplo
      marksman
      markdownlint-cli2
      bash-language-server
      shellcheck
      shfmt
      # Debug adapters for the dap.core extra
      vscode-extensions.vadimcn.vscode-lldb.adapter # codelldb (C/C++, Rust)
      python3Packages.debugpy # debugpy-adapter
      # LazyVim calls Mason's name for vscode-js-debug's dapDebugServer
      (writeShellScriptBin "js-debug-adapter" ''exec ${vscode-js-debug}/bin/js-debug "$@"'')
    ];
  };

  # HM's generated init.lua only sets provider paths and would land inside the symlinked dir below
  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

  # Out-of-store symlink keeps the config writable, so lazy-lock.json updates and live edits
  # work without a rebuild
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/home/neovim/nvim";
}
