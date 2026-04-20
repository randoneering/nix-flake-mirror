{
  pkgs,
  sidra,
  ...
}: {
  home.packages =
    [sidra.packages.${pkgs.stdenv.hostPlatform.system}.default]
    ++ (with pkgs.unstable; [
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
      bootdev-cli
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
      brave
      androidenv.androidPkgs.platform-tools
      # database-stuff
      duckdb
      # Office
      onlyoffice-desktopeditors
    ]);
}
