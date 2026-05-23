{pkgs, ...}: {
  home.packages = with pkgs; [
    # utils
    dbeaver-bin
    obsidian
    tmux
    packer
    openstackclient
    qemu
    jq
    nodejs
    zed-editor
    lmstudio
    atuin-desktop
    # Go
    go
    # JavaScript
    pnpm
    biome
    # k8s/Containers
    kubectl
    docker
    docker-compose
    talosctl
    omnictl
    helm
    kustomize
    k9s
    # Security
    prowler

    # Static Site
    hugo

    # Desktop Customization
    gnome-tweaks
    gnome-extension-manager

    # Social
    discord
    slack

    # database-stuff
    duckdb
    # Office
    onlyoffice-desktopeditors
  ];
}
