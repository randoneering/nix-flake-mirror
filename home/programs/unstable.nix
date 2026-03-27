{pkgs, ...}: {
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
    zed-editor
    # k8s
    kubectl
    minikube
    docker
    docker-compose
    # Security

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

    # database-stuff
    duckdb
    # Office
    onlyoffice-desktopeditors
  ];
}
