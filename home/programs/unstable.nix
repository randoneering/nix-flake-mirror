{
  pkgs,
  sidra,
  ...
}: {
  home.packages = with pkgs.unstable; [
    # utils
    devenv
    llmfit
    dbeaver-bin
    obsidian
    tmux
    packer
    openstackclient
    qemu
    jq
    nodejs
    zed-editor
    sidra.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    kubernetes-helm
    kustomize
    k9s
    headlamp
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
