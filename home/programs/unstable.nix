{pkgs, ...}: {

  home.packages = with pkgs.unstable; [
      # utils
      dbeaver-bin


      # productivity
      obsidian
      claude-code

      # Security
      syft
      grype

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

      zed-editor



  ];
}
