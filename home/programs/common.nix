{ pkgs, ... }:
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
    # python
    ruff
    uv

    # nix dev
    niv

    # IDE/Database Manager
    mongosh
    postgresql
    mysql80
    pgformatter

    # IaC
    docker-compose
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
  ];

}
