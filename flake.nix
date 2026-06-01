{
  description = "Randoneering Multi-System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-update.url = "github:nix-community/nixpkgs-update";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix/release-26.05";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    flox-nixpkgs.url = "github:flox/nixpkgs/stable";
    flox.url = "github:flox/flox";
    agent-config = {
      url = "github:randoneering/randoneering-agent-guide";
      flake = false;
    };
    sidra.url = "github:wimpysworld/sidra";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-update,
    nixpkgs-unstable,
    home-manager,
    catppuccin,
    nvf,
    flox,
    flox-nixpkgs,
    sops-nix,
    agent-config,
    ...
  }: let
    nixosCatppuccinPath = ./modules/desktop/catppuccin.nix;
    homeCatppuccinPath = ./home/theme/catppuccin.nix;

    nixosCatppuccinModule =
      if builtins.pathExists nixosCatppuccinPath
      then nixosCatppuccinPath
      else {};

    homeCatppuccinModule =
      if builtins.pathExists homeCatppuccinPath
      then homeCatppuccinPath
      else {};
  in {
    nixosConfigurations = {
      nix-L16 = let
        username = "justin";
        hostname = "nix-l16";
        overlay-unstable = final: prev: {
          unstable = import nixpkgs-unstable {
            system = prev.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        };
        specialArgs = {
          inherit username hostname;
        };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            (
              {
                config,
                pkgs,
                ...
              }: {
                nixpkgs.overlays = [overlay-unstable];
              }
            )
            catppuccin.nixosModules.catppuccin
            nixosCatppuccinModule
            ./hosts/L16/default.nix
            ./users/${username}/nixos.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                nvf.homeManagerModules.default
                sops-nix.homeManagerModules.sops
                catppuccin.homeModules.catppuccin
                homeCatppuccinModule
              ];

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
      nix-lemur = let
        username = "justin";
        hostname = "nix-lemur";
        overlay-unstable = final: prev: {
          unstable = import nixpkgs-unstable {
            system = prev.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        };
        specialArgs = {inherit username hostname;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            (
              {
                config,
                pkgs,
                ...
              }: {
                nixpkgs.overlays = [overlay-unstable];
              }
            )
            catppuccin.nixosModules.catppuccin
            nixosCatppuccinModule
            ./hosts/lemur/default.nix
            ./users/${username}/nixos.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                nvf.homeManagerModules.default
                sops-nix.homeManagerModules.sops
                catppuccin.homeModules.catppuccin
                homeCatppuccinModule
              ];

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
      wks = let
        username = "justin";
        hostname = "wks";
        overlay-unstable = final: prev: {
          unstable = import nixpkgs-unstable {
            system = prev.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        };
        specialArgs = {inherit username hostname;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            (
              {
                config,
                pkgs,
                ...
              }: {
                nixpkgs.overlays = [overlay-unstable];
              }
            )
            catppuccin.nixosModules.catppuccin
            nixosCatppuccinModule
            ./hosts/wks/default.nix
            ./users/${username}/nixos.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                nvf.homeManagerModules.default
                sops-nix.homeManagerModules.sops
                catppuccin.homeModules.catppuccin
                homeCatppuccinModule
              ];

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
    };
  };
}
