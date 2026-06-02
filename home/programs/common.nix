{pkgs, ...}: {
  home.packages = with pkgs; [
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
    mysql84
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
    proton-vpn
    protonmail-desktop
  ];
}
