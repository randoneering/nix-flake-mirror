{ pkgs, ... }:
{
  home.packages = with pkgs.unstable; [
    # utils
    dbeaver-bin
    obsidian
    tmux
    packer
    openstackclient
    qemu
    jq
    nodejs
    claude-code

    # k8s
    kubectl
    minikube
    docker
    docker-compose
    # Security
    syft
    grype
    prowler
    scorecard
    # Static Site
    hugo

    # Desktop Customization
    gnome-tweaks
    gnome-extension-manager

    # Social
    discord
    slack
    signal-desktop

    # Office
    onlyoffice-desktopeditors
  ];
}
