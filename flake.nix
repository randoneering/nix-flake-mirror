{
  description = "Randoneering Multi-System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-update.url = "github:nix-community/nixpkgs-update";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    sidra.url = "github:wimpysworld/sidra";
    devenv.url = "github:cachix/devenv";
    deploy-rs.url = "github:serokell/deploy-rs";
    llama-cpp-src.url = "github:ggml-org/llama.cpp";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-update,
    nixpkgs-unstable,
    home-manager,
    nvf,
    sops-nix,
    devenv,
    deploy-rs,
    llama-cpp-src,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = {
      devenv = devenv.packages.${system}.devenv;
      deploy-rs = deploy-rs.packages.${system}.deploy-rs;
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        devenv.packages.${system}.devenv
        deploy-rs.packages.${system}.deploy-rs
      ];
    };

    deploy.nodes = {
      nix-L16 = {
        hostname = "nix-L16";
        sshUser = "justin";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.nix-L16;
        };
      };
      nix-lemur = {
        hostname = "nix-lemur";
        sshUser = "justin";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.nix-lemur;
        };
      };
      wks = {
        hostname = "wks";
        sshUser = "justin";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.wks;
        };
      };
    };

    checks.${system} = deploy-rs.lib.${system}.deployChecks self.deploy;

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
            ./hosts/L16/default.nix
            ./users/${username}/nixos.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                nvf.homeManagerModules.default
                sops-nix.homeManagerModules.sops
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
            ./hosts/lemur/default.nix
            ./users/${username}/nixos.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                nvf.homeManagerModules.default
                sops-nix.homeManagerModules.sops
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
        specialArgs = {inherit username hostname llama-cpp-src;};
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
            ./hosts/wks/default.nix
            ./users/${username}/nixos.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                nvf.homeManagerModules.default
                sops-nix.homeManagerModules.sops
              ];

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;
            }
          ];
        };
    };
  };
}
