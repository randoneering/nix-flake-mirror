{pkgs, ...}: {

  home.packages = with pkgs; [
    # archives
    zip

    # utils
    btop
    dpkg
    ripgrep
    nfs-utils
    git
    wget
    marp-cli
    awscli2

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
