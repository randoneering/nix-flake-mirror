{ pkgs, ... }:
let
  floxMcpWrapper = pkgs.writeShellScriptBin "flox-mcp" ''
    unset PYTHONPATH PYTHONHOME PYTHONNOUSERSITE VIRTUAL_ENV
    exec flox activate -r flox/flox-mcp-server -- flox-mcp "$@"
  '';
in
{
  home.packages = with pkgs; [
    # archives
    zip
    gnomeExtensions.pop-shell
    pop-gtk-theme
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
    marp-cli
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
    bitwarden-desktop
    protonvpn-gui
    protonmail-desktop
    floxMcpWrapper
  ];
}
