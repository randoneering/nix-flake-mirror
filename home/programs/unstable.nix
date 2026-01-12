{pkgs, ...}: {

  home.packages = with pkgs.unstable; [
      # utils
      dbeaver-bin
      popsicle
      dconf
      freshfetch
      gimp3
      opencode

      # productivity
      obsidian
      planify
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
