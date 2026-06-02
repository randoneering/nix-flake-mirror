{
  pkgs,
  sidra,
  ...
}: {
  home.packages = with pkgs.unstable; [
    # utils
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

  home.file = {
    ".config/zed/settings.json".text = builtins.toJSON {
      theme = "Catppuccin Mocha";
    };

    ".config/zed/themes/catppuccin-mauve.json".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/zed/b54cb81708d06912d50e6bb9fd2fd2103b9dda25/themes/catppuccin-mauve.json";
      sha256 = "0snziczwv7qgbp3qls59v7h56i9h03a88kvv813fd27q7zxvkk1d";
    };
  };
}
