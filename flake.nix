{
  description = "Daniels' NixOS + Niri Flake Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    niri.url = "github:epireyn/niri-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    torlink = {
      url = "github:baairon/torlink";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      niri,
      home-manager,
      ...
    }@inputs:
    let
      # Passed to every module so each folder's default.nix can import its siblings
      importDir = import ./lib/import-dir.nix;
    in
    {
      # One configuration per folder in hosts/; the folder name is also the hostname,
      # so `nixos-rebuild switch --flake ~/.dotfiles` picks the right one on each machine
      nixosConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir ./hosts)) (
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs importDir; };
          modules = [
            ./hosts/${host}
            ./modules/system
            { networking.hostName = host; }
            niri.nixosModules.niri

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs importDir; };
                users.daniels = import ./home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        }
      );
    };
}
