{
  pkgs,
  sidra,
  ...
}: let
  floxMcpWrapper = pkgs.writeShellScriptBin "flox-mcp" ''
    unset PYTHONPATH PYTHONHOME PYTHONNOUSERSITE VIRTUAL_ENV
    exec flox activate -r flox/flox-mcp-server -- flox-mcp "$@"
  '';

  sidraPackage =
    if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then
      pkgs.callPackage "${sidra}/nix/linux.nix" {
        version = (pkgs.lib.importJSON "${sidra}/package.json").version;
        fetchurl = args:
          pkgs.fetchurl (
            args
            // {
              hash = "sha256-QqCH6ln75uTc910w8MorgSBcNuZjyfjgyCmgOtiJk3M=";
            }
          );
      }
    else
      sidra.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.packages =
    [sidraPackage]
    ++ (with pkgs; [
      # archives
      zip
      gtk4
      gtk3
      sassc
      meson
      libglibutil
      dig
      # utils
      btop
      dpkg
      ripgrep
      nfs-utils
      git
      wget
      awscli2
      google-cloud-sdk
      gh
      popsicle
      dconf
      freshfetch
      gimp3
      nmap
      azure-cli
      # python
      ruff
      uv

      # nix dev
      niv
      nixpkgs-review

      # IDE/Database Manager
      mongosh
      postgresql
      mysql80
      pgformatter

      # IaC
      opentofu

      # Configuration Management
      ansible

      # Steam?
      glibc

      # Security
      proton-pass
      proton-authenticator
      protonvpn-gui
      protonmail-desktop
      floxMcpWrapper
    ]);
}
