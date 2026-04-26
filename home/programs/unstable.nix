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
<<<<<<< HEAD
=======
      bootdev-cli
      lmstudio
>>>>>>> 1138ba5093849886ab7e043be7b90767e4775ebd
      go
      # k8s
      kubectl
      docker
      docker-compose
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
      brave
      # database-stuff
      duckdb
      # Office
      onlyoffice-desktopeditors
    ]);
}
