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
      lmstudio

      # Go
      go
      # JavaScript
      pnpm
      biome
      # k8s/Containers
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

      # database-stuff
      duckdb
      # Office
      onlyoffice-desktopeditors
    ]);
}
