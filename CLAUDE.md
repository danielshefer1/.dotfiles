# Rules for writing in this repo

## 1. One file, one purpose
- Every file does exactly one thing (one app, one service, one concern).
- If a file starts doing more than one thing, split it into separate files.

## 2. Files are organized by folders
- System-level config goes in `modules/system/`, user-level (home-manager) config in `modules/home/`.
  Both are shared by every machine.
- Config for one machine only (hardware-configuration.nix, GPU drivers, …) goes in `hosts/<hostname>/`.
  Every folder in `hosts/` becomes a `nixosConfigurations.<hostname>` in `flake.nix`, and its name is
  also set as the hostname.
- Group related files in a folder rather than leaving them loose (e.g. `modules/home/packages/`).

## 3. Each app gets its own folder
- When an app needs more than one file, all of its files live in a folder named after the app:
  ```
  modules/home/noctalia/
  ├── default.nix      # imports the other modules in this folder
  ├── bar.nix
  ├── idle.nix
  └── templates/       # a sub-group, with its own default.nix
  ```
- Every folder of modules has the same `default.nix`:
  ```nix
  { importDir, ... }:

  {
    imports = importDir ./.;
  }
  ```
  `importDir` (`lib/import-dir.nix`, passed in from `flake.nix`) imports every `.nix` file in the
  folder and every subfolder that has a `default.nix`. New files and folders are picked up
  automatically — never add them to an import list by hand.
- `.nix` files that aren't modules (e.g. a shared derivation) go in a subfolder without a
  `default.nix` (e.g. `modules/home/nix-scripts/pkgs/`), so `importDir` skips them.
- If an app is a single file today (e.g. `modules/home/kitty.nix`) and you need to add a
  second file, first move it into `modules/home/kitty/` and then add the new file there.

## 4. Everything is declarative
- All configuration is expressed in Nix and applied by rebuilding. No manual setup steps.
- Don't edit files under `~/.config`, `/etc`, etc. by hand, and don't install with
  `nix-env`, `nix profile`, or other imperative package managers.
- Non-Nix files (CSS, shell, awk, templates) live in the repo next to the module that uses them
  and are referenced by path from Nix.
- New files must be `git add`ed before building — flakes only see tracked files.
